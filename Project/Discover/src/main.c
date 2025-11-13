
#include "stm8s.h"
#include "stm8_tsl_api.h"
#include "ucs_bus.h"

void CLK_Configuration(void);
void GPIO_Configuration(void);

#define LCD_PORT                              GPIOB
 
#define LCD_RS                                GPIO_PIN_0     
#define LCD_EN                                GPIO_PIN_1   
#define LCD_DB4                               GPIO_PIN_2       
#define LCD_DB5                               GPIO_PIN_3
#define LCD_DB6                               GPIO_PIN_4 
#define LCD_DB7                               GPIO_PIN_5 
 
#define clear_display                         0x01                
#define goto_home                             0x02
#define cursor_direction_inc                  (0x04 | 0x02)
#define cursor_direction_dec                  (0x04 | 0x00)
#define display_shift                         (0x04 | 0x01) 
#define display_no_shift                      (0x04 | 0x00)
 
#define display_on                            (0x08 | 0x04)
#define display_off                           (0x08 | 0x02) 
#define cursor_on                             (0x08 | 0x02)       
#define cursor_off                            (0x08 | 0x00)   
#define blink_on                              (0x08 | 0x01)   
#define blink_off                             (0x08 | 0x00)   
                                    
#define _8_pin_interface                      (0x20 | 0x10)   
#define _4_pin_interface                      (0x20 | 0x00)      
#define _2_row_display                        (0x20 | 0x08) 
#define _1_row_display                        (0x20 | 0x00)
#define _5x10_dots                            (0x20 | 0x40)      
#define _5x7_dots                             (0x20 | 0x00)
 
#define DAT                                   1
#define CMD                                   0
 
void LCD_GPIO_init(void);
void LCD_init(void);  
void LCD_send(unsigned char value, unsigned char mode);
void LCD_4bit_send(unsigned char lcd_data);              
void LCD_putstr(char *lcd_string);               
void LCD_putchar(char char_data);             
void LCD_clear_home(void);            
void LCD_goto(unsigned char  x_pos, unsigned char  y_pos);
void toggle_EN_pin(void);
void toggle_io(unsigned char lcd_data, unsigned char bit_pos, unsigned char pin_num);

void main(void)
{
	unsigned long TempoAux;
    /* Configures clocks */
    CLK_Configuration();

    /* Configures GPIOs */
    GPIO_Configuration();

    LCD_init();  
    LCD_clear_home(); 
 
    LCD_goto(3, 0);                              
    LCD_putstr("UCS"); 
		
	UART2_Init(9600,UART2_WORDLENGTH_8D,UART2_STOPBITS_1,UART2_PARITY_NO,UART2_SYNCMODE_CLOCK_DISABLE,UART2_MODE_TXRX_ENABLE);
		
		UCS_Init();
    
		do
    {
		
        UCS_Listener();

		/*if (cont>0){
			LCD_clear_home();
			LCD_goto(0, 0); 
			LCD_putstr(dadosrx);
			
			if(dadosrx[0] == 'a'){
				GPIO_WriteLow(GPIOE, GPIO_PIN_0); //LIGA led
			} else if(dadosrx[0] == 'b'){
				GPIO_WriteLow(GPIOE, GPIO_PIN_1); //LIGA led
			} else if(dadosrx[0] == 'c'){
				GPIO_WriteHigh(GPIOE, GPIO_PIN_0); //DESLIGA led
				GPIO_WriteHigh(GPIOE, GPIO_PIN_1); //DESLIGA led
			}
		}*/
		
  }while(1);

}

void CLK_Configuration(void)
{

  /* Fmaster = 16MHz */
  CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);

}

void GPIO_Configuration(void)
{
  /* GPIOD reset */
  GPIO_DeInit(GPIOD);
  GPIO_DeInit(GPIOE);

  /* Configure PD0 (LED1) as output push-pull low (led switched on) */
  GPIO_Init(GPIOD, GPIO_PIN_0, GPIO_MODE_OUT_PP_LOW_FAST); //LED ON BOARD
	
  GPIO_Init(GPIOE, GPIO_PIN_0, GPIO_MODE_OUT_PP_LOW_FAST); //LED 1
  GPIO_Init(GPIOE, GPIO_PIN_1, GPIO_MODE_OUT_PP_LOW_FAST); //LED 2
	
	
  GPIO_Init(GPIOE, GPIO_PIN_2, GPIO_MODE_IN_FL_NO_IT); //BOT�O 1
  GPIO_Init(GPIOE, GPIO_PIN_3, GPIO_MODE_IN_FL_NO_IT); //BOT�O 2

}

void LCD_GPIO_init(void)
{
	unsigned long Tempo_Aux;
    GPIO_Init(LCD_PORT, LCD_RS, GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(LCD_PORT, LCD_EN, GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(LCD_PORT, LCD_DB4, GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(LCD_PORT, LCD_DB5, GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(LCD_PORT, LCD_DB6, GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(LCD_PORT, LCD_DB7, GPIO_MODE_OUT_PP_HIGH_FAST);
    //delay_ms(10);
	for (Tempo_Aux=0;Tempo_Aux<0xFFFF;Tempo_Aux++) continue;
}

void LCD_init(void)
{                                     
     LCD_GPIO_init();    
    toggle_EN_pin();
            
    GPIO_WriteLow(LCD_PORT, LCD_RS);            
    GPIO_WriteLow(LCD_PORT, LCD_DB7);   
    GPIO_WriteLow(LCD_PORT, LCD_DB6);   
    GPIO_WriteHigh(LCD_PORT, LCD_DB5);   
    GPIO_WriteHigh(LCD_PORT, LCD_DB4);                      
    toggle_EN_pin();
             
    GPIO_WriteLow(LCD_PORT, LCD_DB7);   
    GPIO_WriteLow(LCD_PORT, LCD_DB6);   
    GPIO_WriteHigh(LCD_PORT, LCD_DB5);   
    GPIO_WriteHigh(LCD_PORT, LCD_DB4);  
    toggle_EN_pin();
 
    GPIO_WriteLow(LCD_PORT, LCD_DB7);   
    GPIO_WriteLow(LCD_PORT, LCD_DB6);   
    GPIO_WriteHigh(LCD_PORT, LCD_DB5);   
    GPIO_WriteHigh(LCD_PORT, LCD_DB4);  
    toggle_EN_pin();                  
 
    GPIO_WriteLow(LCD_PORT, LCD_DB7);   
    GPIO_WriteLow(LCD_PORT, LCD_DB6);   
    GPIO_WriteHigh(LCD_PORT, LCD_DB5);        
    GPIO_WriteLow(LCD_PORT, LCD_DB4);  
    toggle_EN_pin();
 
    LCD_send((_4_pin_interface | _2_row_display | _5x7_dots), CMD);
    LCD_send((display_on | cursor_off | blink_off), CMD); 
    LCD_send(clear_display, CMD);         
    LCD_send((cursor_direction_inc | display_no_shift), CMD);
}   
 
 
void LCD_send(unsigned char value, unsigned char mode)
{                               
    switch(mode)
    {
          case DAT:
          {
              GPIO_WriteHigh(LCD_PORT, LCD_RS);   
              break;
          }
          case CMD:
          {
              GPIO_WriteLow(LCD_PORT, LCD_RS);   
              break;
           }
       }
      
       LCD_4bit_send(value);
}  
    
 
void LCD_4bit_send(unsigned char lcd_data)       
{
    toggle_io(lcd_data, 7, LCD_DB7);
    toggle_io(lcd_data, 6, LCD_DB6);
    toggle_io(lcd_data, 5, LCD_DB5);
    toggle_io(lcd_data, 4, LCD_DB4);
    toggle_EN_pin();
    toggle_io(lcd_data, 3, LCD_DB7);
    toggle_io(lcd_data, 2, LCD_DB6);
    toggle_io(lcd_data, 1, LCD_DB5);
    toggle_io(lcd_data, 0, LCD_DB4);
    toggle_EN_pin();
}  
 
 
void LCD_putstr(char *lcd_string)
{
    do
    {
        LCD_send(*lcd_string++, DAT);
    }while(*lcd_string != '\0');
}
 
void LCD_putchar(char char_data)
{
    LCD_send(char_data, DAT);
}
 
void LCD_clear_home(void)
{
    LCD_send(clear_display, CMD);
    LCD_send(goto_home, CMD);
}
 
void LCD_goto(unsigned char  x_pos, unsigned char  y_pos)
{                                                   
    if(y_pos == 0)    
    {                              
        LCD_send((0x80 | x_pos), CMD);
    }
    else 
    {                                              
        LCD_send((0x80 | 0x40 | x_pos), CMD); 
    }
}
 
void toggle_EN_pin(void)
{
	unsigned long Tempo_Aux;
    GPIO_WriteHigh(LCD_PORT, LCD_EN);    
    //delay_ms(2);
		for (Tempo_Aux=0;Tempo_Aux<0x05FF;Tempo_Aux++) continue;
    GPIO_WriteLow(LCD_PORT,LCD_EN);   
}
 
void toggle_io(unsigned char lcd_data, unsigned char bit_pos, unsigned char pin_num)
{
    bool temp = FALSE;
    
    temp = (0x01 & (lcd_data >> bit_pos));  
                                         
    switch(temp)
    {
        case TRUE:
        {
            GPIO_WriteHigh(LCD_PORT, pin_num);   
            break;
        }
 
        default:
        {
            GPIO_WriteLow(LCD_PORT, pin_num);   
            break;
         }
      }
}