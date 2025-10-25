#include "stm8s.h"
#include "stm8_tsl_api.h"

void CLK_Configuration(void);
void GPIO_Configuration(void);

void main(void)
{
unsigned long TempoAux;
  /* Configures clocks */
  CLK_Configuration();

  /* Configures GPIOs */
  GPIO_Configuration();

UART2_Init(9600,UART2_WORDLENGTH_8D,UART2_STOPBITS_1,UART2_PARITY_NO,UART2_SYNCMODE_CLOCK_DISABLE,UART2_MODE_TXRX_ENABLE);

  do
  {
//UART2_ReceiveData8();
UART2_SendData8(0X30);

      GPIO_WriteHigh(GPIOD, GPIO_PIN_0);
for (TempoAux=0;TempoAux<0x7FFF;TempoAux++) continue;
      GPIO_WriteLow(GPIOD, GPIO_PIN_0);
for (TempoAux=0;TempoAux<0x7FFF;TempoAux++) continue;

  }while(1);

}

//verifica flag recebimento de dados na serial
//if (UART2_GetFlagStatus(UART2_FLAG_RXNE) == TRUE)

//aguarda termino envio na serial
//while(UART2_GetFlagStatus(UART2_FLAG_TC)==FALSE)

void CLK_Configuration(void)
{

  /* Fmaster = 16MHz */
  CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);

}

void GPIO_Configuration(void)
{
  /* GPIOD reset */
  GPIO_DeInit(GPIOD);

  /* Configure PD0 (LED1) as output push-pull low (led switched on) */
  GPIO_Init(GPIOD, GPIO_PIN_0, GPIO_MODE_OUT_PP_LOW_FAST);
  GPIO_Init(GPIOD, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST);

}