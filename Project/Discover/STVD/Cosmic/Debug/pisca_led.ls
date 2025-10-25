   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.5 - 22 May 2025
   4                     ; Optimizer V4.6.5 - 22 May 2025
  62                     .const:	section	.text
  63  0000               L41:
  64  0000 0000ffff      	dc.l	65535
  65                     ; 6 void main(void)
  65                     ; 7 {
  66                     	scross	off
  67                     	switch	.text
  68  0000               _main:
  70  0000 5204          	subw	sp,#4
  71       00000004      OFST:	set	4
  74                     ; 10 CLK_Configuration();
  76  0002 ad42          	call	_CLK_Configuration
  78                     ; 12 GPIO_Configuration();
  80  0004 ad44          	call	_GPIO_Configuration
  82  0006               L72:
  83                     ; 15 GPIO_WriteHigh(GPIOD, GPIO_PIN_0);
  85  0006 4b01          	push	#1
  86  0008 ae500f        	ldw	x,#20495
  87  000b cd0000        	call	_GPIO_WriteHigh
  89  000e 5f            	clrw	x
  90  000f 84            	pop	a
  91                     ; 16 for (TempoAux=0;TempoAux<0xFFFF;TempoAux++) continue;
  93  0010 1f03          	ldw	(OFST-1,sp),x
  94  0012 1f01          	ldw	(OFST-3,sp),x
  96  0014               L53:
  99  0014 96            	ldw	x,sp
 100  0015 5c            	incw	x
 101  0016 a601          	ld	a,#1
 102  0018 cd0000        	call	c_lgadc
 107  001b 96            	ldw	x,sp
 108  001c ad1e          	call	LC001
 110  001e 25f4          	jrult	L53
 111                     ; 17 GPIO_WriteLow(GPIOD, GPIO_PIN_0);
 113  0020 4b01          	push	#1
 114  0022 ae500f        	ldw	x,#20495
 115  0025 cd0000        	call	_GPIO_WriteLow
 117  0028 5f            	clrw	x
 118  0029 84            	pop	a
 119                     ; 18 for (TempoAux=0;TempoAux<0xFFFF;TempoAux++) continue;
 121  002a 1f03          	ldw	(OFST-1,sp),x
 122  002c 1f01          	ldw	(OFST-3,sp),x
 124  002e               L34:
 127  002e 96            	ldw	x,sp
 128  002f 5c            	incw	x
 129  0030 a601          	ld	a,#1
 130  0032 cd0000        	call	c_lgadc
 135  0035 96            	ldw	x,sp
 136  0036 ad04          	call	LC001
 138  0038 25f4          	jrult	L34
 140  003a 20ca          	jra	L72
 141  003c               LC001:
 142  003c 5c            	incw	x
 143  003d cd0000        	call	c_ltor
 145  0040 ae0000        	ldw	x,#L41
 146  0043 cc0000        	jp	c_lcmp
 170                     ; 22 void CLK_Configuration(void)
 170                     ; 23 {
 171                     	switch	.text
 172  0046               _CLK_Configuration:
 176                     ; 25   CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
 178  0046 4f            	clr	a
 180                     ; 26 }
 183  0047 cc0000        	jp	_CLK_HSIPrescalerConfig
 208                     ; 28 void GPIO_Configuration(void)
 208                     ; 29 {
 209                     	switch	.text
 210  004a               _GPIO_Configuration:
 214                     ; 31   GPIO_DeInit(GPIOD);
 216  004a ae500f        	ldw	x,#20495
 217  004d cd0000        	call	_GPIO_DeInit
 219                     ; 33   GPIO_Init(GPIOD, GPIO_PIN_0, GPIO_MODE_OUT_PP_LOW_FAST);
 221  0050 4be0          	push	#224
 222  0052 4b01          	push	#1
 223  0054 ae500f        	ldw	x,#20495
 224  0057 cd0000        	call	_GPIO_Init
 226  005a 85            	popw	x
 227                     ; 34 }
 230  005b 81            	ret	
 243                     	xdef	_main
 244                     	xdef	_GPIO_Configuration
 245                     	xdef	_CLK_Configuration
 246                     	xref	_GPIO_WriteLow
 247                     	xref	_GPIO_WriteHigh
 248                     	xref	_GPIO_Init
 249                     	xref	_GPIO_DeInit
 250                     	xref	_CLK_HSIPrescalerConfig
 269                     	xref	c_lcmp
 270                     	xref	c_ltor
 271                     	xref	c_lgadc
 272                     	end
