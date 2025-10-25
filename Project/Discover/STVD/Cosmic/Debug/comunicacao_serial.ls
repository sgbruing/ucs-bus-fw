   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.5 - 22 May 2025
   4                     ; Optimizer V4.6.5 - 22 May 2025
  65                     .const:	section	.text
  66  0000               L02:
  67  0000 0000ffff      	dc.l	65535
  68                     ; 7 void main(void)
  68                     ; 8 {
  69                     	scross	off
  70                     	switch	.text
  71  0000               _main:
  73  0000 5204          	subw	sp,#4
  74       00000004      OFST:	set	4
  77                     ; 11   CLK_Configuration();
  79  0002 ad5c          	call	_CLK_Configuration
  81                     ; 14   GPIO_Configuration();
  83  0004 ad5e          	call	_GPIO_Configuration
  85                     ; 16 UART2_Init(9600,UART2_WORDLENGTH_8D,UART2_STOPBITS_1,UART2_PARITY_NO,UART2_SYNCMODE_CLOCK_DISABLE,UART2_MODE_TXRX_ENABLE);
  87  0006 4b0c          	push	#12
  88  0008 4b80          	push	#128
  89  000a 4b00          	push	#0
  90  000c 4b00          	push	#0
  91  000e 4b00          	push	#0
  92  0010 ae2580        	ldw	x,#9600
  93  0013 89            	pushw	x
  94  0014 5f            	clrw	x
  95  0015 89            	pushw	x
  96  0016 cd0000        	call	_UART2_Init
  98  0019 5b09          	addw	sp,#9
  99  001b               L72:
 100                     ; 21 UART2_SendData8(0X30);
 102  001b a630          	ld	a,#48
 103  001d cd0000        	call	_UART2_SendData8
 105                     ; 23       GPIO_WriteHigh(GPIOD, GPIO_PIN_0);
 107  0020 4b01          	push	#1
 108  0022 ae500f        	ldw	x,#20495
 109  0025 cd0000        	call	_GPIO_WriteHigh
 111  0028 5f            	clrw	x
 112  0029 84            	pop	a
 113                     ; 24 for (TempoAux=0;TempoAux<0xFFFF;TempoAux++) continue;
 115  002a 1f03          	ldw	(OFST-1,sp),x
 116  002c 1f01          	ldw	(OFST-3,sp),x
 118  002e               L53:
 121  002e 96            	ldw	x,sp
 122  002f 5c            	incw	x
 123  0030 a601          	ld	a,#1
 124  0032 cd0000        	call	c_lgadc
 129  0035 96            	ldw	x,sp
 130  0036 ad1e          	call	LC001
 132  0038 25f4          	jrult	L53
 133                     ; 25       GPIO_WriteLow(GPIOD, GPIO_PIN_0);
 135  003a 4b01          	push	#1
 136  003c ae500f        	ldw	x,#20495
 137  003f cd0000        	call	_GPIO_WriteLow
 139  0042 5f            	clrw	x
 140  0043 84            	pop	a
 141                     ; 26 for (TempoAux=0;TempoAux<0xFFFF;TempoAux++) continue;
 143  0044 1f03          	ldw	(OFST-1,sp),x
 144  0046 1f01          	ldw	(OFST-3,sp),x
 146  0048               L34:
 149  0048 96            	ldw	x,sp
 150  0049 5c            	incw	x
 151  004a a601          	ld	a,#1
 152  004c cd0000        	call	c_lgadc
 157  004f 96            	ldw	x,sp
 158  0050 ad04          	call	LC001
 160  0052 25f4          	jrult	L34
 162  0054 20c5          	jra	L72
 163  0056               LC001:
 164  0056 5c            	incw	x
 165  0057 cd0000        	call	c_ltor
 167  005a ae0000        	ldw	x,#L02
 168  005d cc0000        	jp	c_lcmp
 192                     ; 38 void CLK_Configuration(void)
 192                     ; 39 {
 193                     	switch	.text
 194  0060               _CLK_Configuration:
 198                     ; 42   CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
 200  0060 4f            	clr	a
 202                     ; 44 }
 205  0061 cc0000        	jp	_CLK_HSIPrescalerConfig
 230                     ; 46 void GPIO_Configuration(void)
 230                     ; 47 {
 231                     	switch	.text
 232  0064               _GPIO_Configuration:
 236                     ; 49   GPIO_DeInit(GPIOD);
 238  0064 ae500f        	ldw	x,#20495
 239  0067 cd0000        	call	_GPIO_DeInit
 241                     ; 52   GPIO_Init(GPIOD, GPIO_PIN_0, GPIO_MODE_OUT_PP_LOW_FAST);
 243  006a 4be0          	push	#224
 244  006c 4b01          	push	#1
 245  006e ae500f        	ldw	x,#20495
 246  0071 cd0000        	call	_GPIO_Init
 248  0074 85            	popw	x
 249                     ; 53   GPIO_Init(GPIOD, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST);
 251  0075 4be0          	push	#224
 252  0077 4b20          	push	#32
 253  0079 ae500f        	ldw	x,#20495
 254  007c cd0000        	call	_GPIO_Init
 256  007f 85            	popw	x
 257                     ; 55 }
 260  0080 81            	ret	
 273                     	xdef	_main
 274                     	xdef	_GPIO_Configuration
 275                     	xdef	_CLK_Configuration
 276                     	xref	_UART2_SendData8
 277                     	xref	_UART2_Init
 278                     	xref	_GPIO_WriteLow
 279                     	xref	_GPIO_WriteHigh
 280                     	xref	_GPIO_Init
 281                     	xref	_GPIO_DeInit
 282                     	xref	_CLK_HSIPrescalerConfig
 301                     	xref	c_lcmp
 302                     	xref	c_ltor
 303                     	xref	c_lgadc
 304                     	end
