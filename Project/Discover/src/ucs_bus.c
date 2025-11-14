#include "ucs_bus.h"
#include <string.h>

extern void LCD_clear_home(void);
extern void LCD_send(unsigned char value, unsigned char mode);
extern void LCD_putchar(char char_data);

#define CMD 0

UCS_Context ucs_context;
UCS_Frame frame_RX;
UCS_Frame frame_TX;

void Context_Init(UCS_Context* ctx, uint8_t my_address)
{
    ctx->my_address      = my_address;
    ctx->rx_index        = 0;
    ctx->expected_length = 0;
    ctx->state           = WAIT_STX;
}

void UCS_Init(void)
{
    Context_Init(&ucs_context, MY_ADRESS);
}

void UCS_Listener(void)
{
    unsigned long timeout;
    int i;
    int cont;

    timeout = 0xFFFFUL;
    cont    = 0;

    /* limpa buffer */
    for (i = 0; i < MAX_FRAME_LENGTH; i++) {
        ucs_context.rx_buffer[i] = 0;
    }
    ucs_context.rx_index        = 0;
    ucs_context.expected_length = 0;

    /* lê bytes até timeout */
    do {
        if (UART2_GetFlagStatus(UART2_FLAG_RXNE) == TRUE) {
            if (cont < MAX_FRAME_LENGTH) {
                ucs_context.rx_buffer[cont] = UART2_ReceiveData8();
                cont++;
            } else {
                (void)UART2_ReceiveData8(); /* descarta extra */
            }
            timeout = 0xFFFFUL;
        }
        timeout--;
    } while (timeout > 0UL);

    /* processa se chegou algo */
    if (cont > 0) {
        ucs_context.state = WAIT_STX;

        for (i = 0; i < cont; i++) {
            switch (ucs_context.state) {
            case WAIT_STX:
                if (ucs_context.rx_buffer[i] == STX) {
                    ucs_context.state    = WAIT_LEN;
                    ucs_context.rx_index = (uint8_t)i;
                }
                break;

            case WAIT_LEN:
                ucs_context.expected_length = ucs_context.rx_buffer[i];
                ucs_context.state           = ADRESS_VERIFY;
                break;

            case ADRESS_VERIFY:
                if (ucs_context.rx_buffer[i] == ucs_context.my_address) {
                    ucs_context.state = BCC_VERIFY;
                } else {
                    ucs_context.state = WAIT_STX; /* endereço errado, descarta */
                }
                break;

            case BCC_VERIFY:
                /* aqui daria pra checar BCC, por enquanto só vai para READ_PAYLOAD */
                ucs_context.state = READ_PAYLOAD;
                break;

            case READ_PAYLOAD:
                Process_Frame(&ucs_context, &frame_RX);
                ucs_context.state = WAIT_STX;
                break;

            default:
                ucs_context.state = WAIT_STX;
                break;
            }
        }
    }
}

void send_answer(UCS_Frame* frame_RX, const UCS_Answer* answer_packet)
{
    uint8_t i;

    frame_TX.stx = STX;

    /* primeiro byte do data = tipo de resposta (ACK/NAK) */
    frame_TX.data[0]  = (uint8_t)answer_packet->answer;
    frame_TX.data_len = (uint8_t)(answer_packet->data_len + 1U);

    for (i = 0; i < answer_packet->data_len && i < (MAX_DATA_LENGTH - 1U); i++) {
        frame_TX.data[i + 1U] = answer_packet->data[i];
    }

    /* Tam = Tam + Dest + Src + Cmd + Data... + BCC */
    frame_TX.length = (uint8_t)(5U + frame_TX.data_len);

    frame_TX.dest = frame_RX->src;
    frame_TX.src  = frame_RX->dest;
    frame_TX.cmd  = frame_RX->cmd;

    /* BCC simples: XOR de todos os campos após STX */
    frame_TX.bcc = frame_TX.length ^ frame_TX.dest ^ frame_TX.src ^ frame_TX.cmd;
    for (i = 0; i < frame_TX.data_len; i++) {
        frame_TX.bcc ^= frame_TX.data[i];
    }

    UCS_SendPacket(&frame_TX);
}

void UCS_SendPacket(const UCS_Frame* frame)
{
    uint8_t i;

    UART2_SendData8(frame->stx);
    UART2_SendData8(frame->length);
    UART2_SendData8(frame->dest);
    UART2_SendData8(frame->src);
    UART2_SendData8(frame->cmd);

    for (i = 0; i < frame->data_len; i++) {
        UART2_SendData8(frame->data[i]);
    }

    UART2_SendData8(frame->bcc);
}

void Process_Frame(UCS_Context* ctx, UCS_Frame* frame_RX)
{
    uint8_t idx;
    uint8_t tam;
    uint8_t dlen;

    idx = ctx->rx_index;
    tam = ctx->rx_buffer[idx + 1U]; /* Tam */

    frame_RX->stx    = ctx->rx_buffer[idx];
    frame_RX->length = tam;
    frame_RX->dest   = ctx->rx_buffer[idx + 2U];
    frame_RX->src    = ctx->rx_buffer[idx + 3U];
    frame_RX->cmd    = ctx->rx_buffer[idx + 4U];

    if (tam > 5U) {
        dlen = (uint8_t)(tam - 5U); /* Tam, Dest, Src, Cmd, BCC */
        if (dlen > MAX_DATA_LENGTH) {
            dlen = MAX_DATA_LENGTH;
        }
        frame_RX->data_len = dlen;
        memcpy(frame_RX->data, &ctx->rx_buffer[idx + 5U], dlen);
    } else {
        frame_RX->data_len = 0U;
    }

    frame_RX->bcc = ctx->rx_buffer[idx + tam];

    command_handler(frame_RX);
}

void command_handler(UCS_Frame* frame)
{
    UCS_Answer answer_packet;
    uint8_t i;

    answer_packet.answer   = NAK;
    answer_packet.data_len = 0U;

    for (i = 0; i < MAX_DATA_LENGTH; i++) {
        answer_packet.data[i] = 0U;
    }

    switch (frame->cmd) {
    case CMD_BTN_STATUS_1:
        answer_packet = read_button_status(BUTTON_1);
        break;

    case CMD_BTN_STATUS_2:
        answer_packet = read_button_status(BUTTON_2);
        break;

    case CMD_LED_WRITE_1:
        answer_packet = set_led_state(LED_1, frame->data);
        break;

    case CMD_LED_WRITE_2:
        answer_packet = set_led_state(LED_2, frame->data);
        break;

    case CMD_LED_BLINK_1:
        answer_packet = blink_led(LED_1, frame->data);
        break;

    case CMD_LED_BLINK_2:
        answer_packet = blink_led(LED_2, frame->data);
        break;

    case CMD_DISPLAY_WRITE:
        answer_packet = write_display(frame->data, frame->data_len);
        break;

    default:
        answer_packet.answer = NAK;
        break;
    }

    send_answer(frame, &answer_packet);
}

UCS_Answer read_button_status(GPIO_Pin_TypeDef button_pin)
{
    UCS_Answer answer_packet;

    answer_packet.answer   = NAK;
    answer_packet.data_len = 1U;
    answer_packet.data[0]  = 0U;

    switch (button_pin) {
    case BUTTON_1:
    case BUTTON_2:
        answer_packet.answer  = ACK;
        answer_packet.data[0] = (uint8_t)!GPIO_ReadInputPin(GPIOE, button_pin);
        break;

    default:
        /* mantém NAK */
        break;
    }

    return answer_packet;
}

UCS_Answer set_led_state(GPIO_Pin_TypeDef led_pin, const uint8_t* data)
{
    UCS_Answer answer_packet;

    answer_packet.answer   = NAK;
    answer_packet.data_len = 0U;
    uint8_t state = data[0];

    if (state > 1) {
        return answer_packet;
    }

    switch (led_pin) {
    case LED_1:
    case LED_2:
        if (state == 1) {
            GPIO_WriteLow(GPIOE, led_pin);  /* ON (se LED ativo em LOW) */
        } else {
            GPIO_WriteHigh(GPIOE, led_pin); /* OFF */
        }
        answer_packet.answer = ACK;
        break;

    default:
        break;
    }

    return answer_packet;
}

UCS_Answer blink_led(GPIO_Pin_TypeDef led_pin, const uint8_t* data)
{
    UCS_Answer answer_packet;
    uint8_t times;
    uint8_t delay_val;
    uint16_t i;
    uint16_t j;

    answer_packet.answer   = NAK;
    answer_packet.data_len = 0U;
    times      = 0U;
    delay_val  = 0U;

    switch (led_pin) {
    case LED_1:
    case LED_2:
        break;
    default:
        return answer_packet;
    }

    if (data != 0) {
        times     = data[0];
        delay_val = data[1];
    }

    for (i = 0U; i < times; i++) {
        GPIO_WriteLow(GPIOE, led_pin); /* ON */
        for (j = 0U; j < (uint16_t)delay_val * 1000U; j++) {
            /* delay tosco */
        }
        GPIO_WriteHigh(GPIOE, led_pin); /* OFF */
        for (j = 0U; j < (uint16_t)delay_val * 1000U; j++) {
        }
    }

    answer_packet.answer = ACK;
    return answer_packet;
}

UCS_Answer write_display(const uint8_t* data, uint8_t data_len)
{
    UCS_Answer answer_packet;
    uint8_t pos;
    uint8_t i;

    answer_packet.answer   = ACK;
    answer_packet.data_len = 0U;

    if (data == 0 || data_len == 0U) {
        return answer_packet;
    }

    LCD_clear_home();

    pos = data[0]; /* posição inicial no display */

    LCD_send(pos, CMD);
    for (i = 1U; i < data_len; i++) {
        LCD_putchar((char)data[i]);
    }

    return answer_packet;
}
