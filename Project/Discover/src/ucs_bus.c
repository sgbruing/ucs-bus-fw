#include "ucs_bus.h"
#include <string.h>

UCS_Context ucs_context;
UCS_Frame frame_RX;
UCS_Frame frame_TX;

void Context_Init(UCS_Context* ctx, uint8_t my_address) {
    ctx->my_address = my_address;
    ctx->rx_index = 0;
    ctx->expected_length = 0;
    ctx->state = WAIT_STX;
}

void UCS_Init() {
    Context_Init(&ucs_context, MY_ADRESS);
}

void UCS_Listener(){

    unsigned long timeout = 0xFFFF;
    int i, cont = 0;
    for(i=0; i<MAX_FRAME_LENGTH; i++){
        ucs_context.rx_buffer[i] = 0;
    }
    ucs_context.rx_index = 0;
    ucs_context.expected_length = 0;   

    do{
        
        if (UART2_GetFlagStatus(UART2_FLAG_RXNE) == TRUE){
            ucs_context.rx_buffer[cont] = UART2_ReceiveData8(); 
            cont++;
            timeout = 0xFFFF;
        }
        timeout--;
        
    } while(timeout>0);

    if (cont>0){
        ucs_context.state = WAIT_STX;
        i=0;
        for(i=0; i<MAX_FRAME_LENGTH; i++){
            
            switch (ucs_context.state)
            {
                case WAIT_STX:
                    if(ucs_context.rx_buffer[i] == STX){
                        ucs_context.state = WAIT_LEN;
                        ucs_context.rx_index = i;
                    }
                    break;
                case WAIT_LEN:
                    ucs_context.expected_length = ucs_context.rx_buffer[i];
                    ucs_context.state = BCC_VERIFY;
                    break;
                case BCC_VERIFY:
                    ucs_context.state = READ_PAYLOAD;
                    break;
                case READ_PAYLOAD:
                    Process_Frame(&ucs_context, &frame_RX);
                    ucs_context.state = WAIT_STX;
                    break;
                default:
                    break;
            } 
        }
    }

}

void Process_Frame(UCS_Context* ctx, UCS_Frame* frame_RX) {
    uint8_t idx = ctx->rx_index;
    uint8_t tam = ctx->rx_buffer[idx + 1]; /* Tam = bytes Tam..BCC inclusive */

    frame_RX->stx = ctx->rx_buffer[idx];
    frame_RX->length = tam;
    frame_RX->dest = ctx->rx_buffer[idx + 2];
    frame_RX->src = ctx->rx_buffer[idx + 3];
    frame_RX->cmd = ctx->rx_buffer[idx + 4];

    /* calcula e copia dados (se existirem). dados = Tam - 5 (Tam, Dest, Src, Cmd, BCC) */
    if (tam > 5) {
        uint8_t dlen = tam - 5;
        if (dlen > MAX_DATA_LENGTH) dlen = MAX_DATA_LENGTH; /* proteção */
        frame_RX->data_len = dlen;
        memcpy(frame_RX->data, &ctx->rx_buffer[idx + 5], dlen);
    } else {
        frame_RX->data_len = 0;
    }

    /* BCC no índice idx + tam */
    frame_RX->bcc = ctx->rx_buffer[idx + tam];

    command_handler(frame_RX);
}

void command_handler(UCS_Frame* frame) {
    switch (frame->cmd) {
        case CMD_BTN_STATUS_1:
            read_button_status(1);
            break;
        case CMD_BTN_STATUS_2:
            read_button_status(2);
            break;
        case CMD_LED_WRITE_1:
            set_led_state(1, frame->data);
            break;
        case CMD_LED_WRITE_2:
            set_led_state(2, frame->data);
            break;
        case CMD_LED_BLINK_1:
            blink_led(1, frame->data);
            break;
        case CMD_LED_BLINK_2:
            blink_led(2, frame->data);
            break;
        case CMD_DISPLAY_WRITE:
            write_display(frame->data);
            break;
        default:
            // Handle unknown command
            break;
    }
}

void read_button_status(uint8_t button_number) {
    // GPIO_Pin_TypeDef pin;
    // switch (button_number) {
    //     case 1:
    //         pin = GPIO_PIN_2;
    //         break;
    //     case 2:
    //         pin = GPIO_PIN_3;
    //         break;
    //     default:
    //         return; // Invalid button number
    // }

    // if (GPIO_ReadInputPin(GPIOE, pin) == RESET) {
    //     // Button is pressed
    // } else {
    //     // Button is not pressed
    // }
}

void set_led_state(uint8_t led_number, uint8_t* state) {
    GPIO_Pin_TypeDef pin;
    uint8_t s;

    /* escolha pino no topo (declarações no início da função) */
    switch (led_number) {
        case 1:
            pin = GPIO_PIN_0; /* ajuste conforme seu hardware (ex: GPIOE, PIN_0) */
            break;
        case 2:
            pin = GPIO_PIN_1;
            break;
        default:
            return;
    }

    s = state ? state[0] : 0;
    if (s == 1) {
        GPIO_WriteLow(GPIOE, pin); /* LED ON (pull low no seu hardware) */
    } else {
        GPIO_WriteHigh(GPIOE, pin); /* LED OFF */
    }
}

void blink_led(uint8_t led_number, uint8_t* data) {
    GPIO_Pin_TypeDef pin;
    uint8_t times = 0;
    uint8_t delay_val = 0;
    uint16_t i, j;

    switch (led_number) {
        case 1:
            pin = GPIO_PIN_0;
            break;
        case 2:
            pin = GPIO_PIN_1;
            break;
        default:
            return;
    }

    if (data) {
        times = data[0];
        delay_val = data[1];
    }

    for (i = 0; i < times; i++) {
        GPIO_WriteLow(GPIOE, pin); /* ON */
        for(j = 0 ; j < delay_val * 1000 ; j++){
           ;   
        }
        GPIO_WriteHigh(GPIOE, pin); /* OFF */
        for(j = 0 ; j < delay_val * 1000 ; j++){
           ;   
        }
    }
}

void write_display(uint8_t* data) {
    // LCD_clear_home();
    // LCD_goto(0, 0);
    // LCD_putstr(message);
}