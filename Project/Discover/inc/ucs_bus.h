#ifndef UCS_BUS_H
#define UCS_BUS_H

#include "stm8s.h"

#define MY_ADRESS 0x11 //Grupo 17
#define STX       0x02

#define MAX_DATA_LENGTH   64
#define MAX_FRAME_LENGTH (MAX_DATA_LENGTH + 6) /* STX + Tam + Dest + Src + Cmd + Data... + BCC */

#define BUTTON_1 GPIO_PIN_2
#define BUTTON_2 GPIO_PIN_3

#define RS485_EN_PORT   GPIOE         
#define RS485_EN_PIN    GPIO_PIN_5     

#define LED_1    GPIO_PIN_0
#define LED_2    GPIO_PIN_1

typedef enum {
    NAK = 0x15,
    ACK = 0x06
} ANSWER_TYPE;

typedef enum {
    CMD_BTN_STATUS_1  = 0x01,
    CMD_BTN_STATUS_2  = 0x02,
    CMD_LED_WRITE_1   = 0x03,
    CMD_LED_WRITE_2   = 0x04,
    CMD_LED_BLINK_1   = 0x05,
    CMD_LED_BLINK_2   = 0x06,
    CMD_DISPLAY_WRITE = 0x07
} COMMANDS;

typedef enum {
    WAIT_STX = 0,
    WAIT_LEN,
    READ_PAYLOAD,
    ADRESS_VERIFY,
    BCC_VERIFY
} UCS_RCV_STATE;

typedef struct {
    ANSWER_TYPE answer;
    uint8_t data[MAX_DATA_LENGTH];
    uint8_t data_len;
} UCS_Answer;

typedef struct {
    uint8_t stx;
    uint8_t length;  /* Tam */
    uint8_t dest;
    uint8_t src;
    uint8_t cmd;
    uint8_t data[MAX_DATA_LENGTH];
    uint8_t data_len; /* número de bytes válidos em data */
    uint8_t bcc;
} UCS_Frame;

typedef struct {
    uint8_t my_address;
    uint8_t rx_buffer[MAX_FRAME_LENGTH];
    uint8_t rx_index;
    uint8_t expected_length;
    UCS_RCV_STATE state;
} UCS_Context;

/* Globais (se quiser acessar externamente) */
extern UCS_Context ucs_context;
extern UCS_Frame frame_RX;
extern UCS_Frame frame_TX;

/* Prototipos */
void Context_Init(UCS_Context* ctx, uint8_t my_address);
void UCS_Init(void);
void UCS_Listener(void);
void Process_Frame(UCS_Context* ctx, UCS_Frame* frame_RX);
void command_handler(UCS_Frame* frame);

UCS_Answer read_button_status(GPIO_Pin_TypeDef button_pin);
UCS_Answer set_led_state(GPIO_Pin_TypeDef led_pin, const uint8_t* state);
UCS_Answer blink_led(GPIO_Pin_TypeDef led_pin, const uint8_t* data);
UCS_Answer write_display(const uint8_t* data, uint8_t data_len);

void send_answer(UCS_Frame* frame_RX, const UCS_Answer* answer_packet);
void UCS_SendPacket(const UCS_Frame* frame);

#endif /* UCS_BUS_H */
