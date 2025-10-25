#include "ucs_bus.h"
#include <stdint.h>
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

    unsigned long time = 0xFFFF;

    do
    {
		
		unsigned long contTempo = 0xFFFF;
		int cont = 0;	
		
		int i=0;
		for(i=0; i<10; i++){
			ucs_context.rx_buffer[i] = 0;
		}
		
		do{
			
			if (UART2_GetFlagStatus(UART2_FLAG_RXNE) == TRUE){
				ucs_context.rx_buffer[cont] = UART2_ReceiveData8(); 
				cont++;
				contTempo = 0xFFFF;
			}
			contTempo--;
			
		} while(contTempo>0);

		if (cont>0){
			LCD_clear_home();
			LCD_goto(0, 0); 
			LCD_putstr(ucs_context.rx_buffer);
			
			if(ucs_context.rx_buffer[0] == 'a'){
				GPIO_WriteLow(GPIOE, GPIO_PIN_0); //LIGA led
			} else if(ucs_context.rx_buffer[0] == 'b'){
				GPIO_WriteLow(GPIOE, GPIO_PIN_1); //LIGA led
			} else if(ucs_context.rx_buffer[0] == 'c'){
				GPIO_WriteHigh(GPIOE, GPIO_PIN_0); //DESLIGA led
				GPIO_WriteHigh(GPIOE, GPIO_PIN_1); //DESLIGA led
			}
		}
		
  }while(1);



    uint8_t byte = UART2_ReceiveData8();
    
    switch (ucs_context.state) {
        case WAIT_STX:
            if (byte == UCS_STX) {
                ucs_context.state = WAIT_LEN;
                ucs_context.rx_index = 0;
                ucs_context.rx_buffer[ucs_context.rx_index++] = byte;
            }
            break;
        
        case WAIT_LEN:
            ucs_context.expected_length = byte;
            ucs_context.rx_buffer[ucs_context.rx_index++] = byte;
            ucs_context.state = READ_PAYLOAD;
            break;
        
        case READ_PAYLOAD:
            ucs_context.rx_buffer[ucs_context.rx_index++] = byte;
            if (ucs_context.rx_index >= ucs_context.expected_length + 2) { // +2 for STX and LEN
                // Full frame received, process it
                Process_Frame(ucs_context.rx_buffer, ucs_context.rx_index);
                ucs_context.state = WAIT_STX; // Reset state for next frame
            }
            break;
        
        default:
            ucs_context.state = WAIT_STX; // Reset state on error
            break;
    }
}