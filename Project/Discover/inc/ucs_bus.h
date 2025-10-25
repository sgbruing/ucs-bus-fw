
#define MY_ADRESS 0x01
#define STX 0x02
#define ACK 0x06 
#define NAK = 0x15
#define MAX_DATA_LENGTH 64
#define MAX_FRAME_LENGTH (UCS_MAX_DATA_LENGTH + 5) // STX, LEN, DEST, SRC, CMD, BCC

/* Structs 8*/
typedef struct ucs_frame {
    uint8_t stx;
    uint8_t length;
    uint8_t dest;
    uint8_t src;
    COMMANDS cmd;
    uint8_t data[64];
    uint8_t bcc;
} UCS_Frame;

typedef struct ucs_context {
    uint8_t my_address;
    uint8_t rx_buffer[64];
    uint8_t rx_index;
    uint8_t expected_length;
    enum { WAIT_STX, WAIT_LEN, READ_PAYLOAD } state;
} UCS_Context;

/* Enums */
typedef enum {
	BTN_STATUS_1 = 0x1,
	BTN_STATUS_2 = 0x2,
	LED_WRITE_1 = 0X3,
	LED_WRITE_2 = 0X4,
	LED_TOGGLE_1 = 0X5,
	LED_TOGGLE_2 = 0X6,
	DISPLAY_WRITE = 0X7,
} COMMANDS;
	