#ifndef UCS_BUS_H
#define UCS_BUS_H

#include "stm8s.h"

#define MY_ADRESS 0x01
#define STX 0x02
#define ACK 0x06
#define NAK 0x15

#define MAX_DATA_LENGTH 64
#define MAX_FRAME_LENGTH (MAX_DATA_LENGTH + 6) /* STX + Tam + Dest + Src + Cmd + Data... + BCC */

typedef enum {
    CMD_BTN_STATUS_1 = 0x01,
    CMD_BTN_STATUS_2 = 0x02,
    CMD_LED_WRITE_1  = 0x03,
    CMD_LED_WRITE_2  = 0x04,
    CMD_LED_BLINK_1 = 0x05,
    CMD_LED_BLINK_2 = 0x06,
    CMD_DISPLAY_WRITE= 0x07
} COMMANDS;

typedef enum {
    WAIT_STX = 0,
    WAIT_LEN,
    READ_PAYLOAD,
    BCC_VERIFY
} UCS_RCV_STATE;

/* Frame */
typedef struct {
    uint8_t stx;
    uint8_t length; /* Tam */
    uint8_t dest;
    uint8_t src;
    uint8_t cmd;
    uint8_t data[MAX_DATA_LENGTH];
    uint8_t data_len; /* número de bytes válidos em data */
    uint8_t bcc;
} UCS_Frame;

/* Context */
typedef struct {
    uint8_t my_address;
    uint8_t rx_buffer[MAX_FRAME_LENGTH];
    uint8_t rx_index;
    uint8_t expected_length;
    UCS_RCV_STATE state;
} UCS_Context;

/* Prototypes */
void Context_Init(UCS_Context* ctx, uint8_t my_address);
void UCS_Init(void);
void UCS_Listener(void);
void Process_Frame(UCS_Context* ctx, UCS_Frame* frame);

void command_handler(UCS_Frame* frame);

void read_button_status(uint8_t button_number);
void set_led_state(uint8_t led_number, uint8_t* state);
void blink_led(uint8_t led_number, uint8_t* data);
void write_display(uint8_t* data);

#endif /* UCS_BUS_H */