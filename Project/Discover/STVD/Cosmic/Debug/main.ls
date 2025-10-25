   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.5 - 22 May 2025
   4                     ; Optimizer V4.6.5 - 22 May 2025
  97                     ; 52 void main(void)
  97                     ; 53 {
  99                     	switch	.text
 100  0000               _main:
 102  0000 5214          	subw	sp,#20
 103       00000014      OFST:	set	20
 106                     ; 56   CLK_Configuration();
 108  0002 cd00cb        	call	_CLK_Configuration
 110                     ; 59   GPIO_Configuration();
 112  0005 cd00cf        	call	_GPIO_Configuration
 114                     ; 61 	LCD_init();  
 116  0008 cd0173        	call	_LCD_init
 118                     ; 62     LCD_clear_home(); 
 120  000b cd0273        	call	_LCD_clear_home
 122                     ; 64     LCD_goto(3, 0);                              
 124  000e ae0300        	ldw	x,#768
 125  0011 cd027f        	call	_LCD_goto
 127                     ; 65     LCD_putstr("UCS"); 
 129  0014 ae0008        	ldw	x,#L34
 130  0017 cd0259        	call	_LCD_putstr
 132                     ; 67 	UART2_Init(9600,UART2_WORDLENGTH_8D,UART2_STOPBITS_1,UART2_PARITY_NO,UART2_SYNCMODE_CLOCK_DISABLE,UART2_MODE_TXRX_ENABLE);
 134  001a 4b0c          	push	#12
 135  001c 4b80          	push	#128
 136  001e 4b00          	push	#0
 137  0020 4b00          	push	#0
 138  0022 4b00          	push	#0
 139  0024 ae2580        	ldw	x,#9600
 140  0027 89            	pushw	x
 141  0028 5f            	clrw	x
 142  0029 89            	pushw	x
 143  002a cd0000        	call	_UART2_Init
 145  002d 5b09          	addw	sp,#9
 146  002f               L54:
 147                     ; 73 		unsigned long contTempo = 0xFFFF;
 149  002f aeffff        	ldw	x,#65535
 150  0032 1f07          	ldw	(OFST-13,sp),x
 151  0034 5f            	clrw	x
 152  0035 1f05          	ldw	(OFST-15,sp),x
 154                     ; 74 		int cont = 0;	
 156  0037 1f03          	ldw	(OFST-17,sp),x
 158                     ; 77 		int i=0;
 160                     ; 78 		for(i=0; i<10; i++){
 162  0039 1f09          	ldw	(OFST-11,sp),x
 164  003b               L15:
 165                     ; 79 			dadosrx[i] = 0;
 167  003b 96            	ldw	x,sp
 168  003c 1c000b        	addw	x,#OFST-9
 169  003f 1f01          	ldw	(OFST-19,sp),x
 171  0041 72fb09        	addw	x,(OFST-11,sp)
 172  0044 7f            	clr	(x)
 173                     ; 78 		for(i=0; i<10; i++){
 175  0045 1e09          	ldw	x,(OFST-11,sp)
 176  0047 5c            	incw	x
 177  0048 1f09          	ldw	(OFST-11,sp),x
 181  004a a3000a        	cpw	x,#10
 182  004d 2fec          	jrslt	L15
 183  004f               L75:
 184                     ; 102 			if (UART2_GetFlagStatus(UART2_FLAG_RXNE) == TRUE){
 186  004f ae0020        	ldw	x,#32
 187  0052 cd0000        	call	_UART2_GetFlagStatus
 189  0055 4a            	dec	a
 190  0056 261a          	jrne	L56
 191                     ; 103 				dadosrx[cont] = UART2_ReceiveData8(); 
 193  0058 cd0000        	call	_UART2_ReceiveData8
 195  005b 96            	ldw	x,sp
 196  005c 1c000b        	addw	x,#OFST-9
 197  005f 1f01          	ldw	(OFST-19,sp),x
 199  0061 72fb03        	addw	x,(OFST-17,sp)
 200  0064 f7            	ld	(x),a
 201                     ; 104 				cont++;
 203  0065 1e03          	ldw	x,(OFST-17,sp)
 204  0067 5c            	incw	x
 205  0068 1f03          	ldw	(OFST-17,sp),x
 207                     ; 105 				contTempo = 0xFFFF;
 209  006a aeffff        	ldw	x,#65535
 210  006d 1f07          	ldw	(OFST-13,sp),x
 211  006f 5f            	clrw	x
 212  0070 1f05          	ldw	(OFST-15,sp),x
 214  0072               L56:
 215                     ; 107 			contTempo--;
 217  0072 96            	ldw	x,sp
 218  0073 1c0005        	addw	x,#OFST-15
 219  0076 a601          	ld	a,#1
 220  0078 cd0000        	call	c_lgsbc
 223                     ; 109 		} while(contTempo>0);
 225  007b 96            	ldw	x,sp
 226  007c 1c0005        	addw	x,#OFST-15
 227  007f cd0000        	call	c_lzmp
 229  0082 26cb          	jrne	L75
 230                     ; 111 		if (cont>0){
 232  0084 9c            	rvf	
 233  0085 1e03          	ldw	x,(OFST-17,sp)
 234  0087 2da6          	jrsle	L54
 235                     ; 112 			LCD_clear_home();
 237  0089 cd0273        	call	_LCD_clear_home
 239                     ; 113 			LCD_goto(0, 0); 
 241  008c 5f            	clrw	x
 242  008d cd027f        	call	_LCD_goto
 244                     ; 114 			LCD_putstr(dadosrx);
 246  0090 96            	ldw	x,sp
 247  0091 1c000b        	addw	x,#OFST-9
 248  0094 cd0259        	call	_LCD_putstr
 250                     ; 116 			if(dadosrx[0] == 'a'){
 252  0097 7b0b          	ld	a,(OFST-9,sp)
 253  0099 a161          	cp	a,#97
 254  009b 2604          	jrne	L17
 255                     ; 117 				GPIO_WriteLow(GPIOE, GPIO_PIN_0); //LIGA led
 257  009d 4b01          	push	#1
 260  009f 2006          	jp	LC002
 261  00a1               L17:
 262                     ; 118 			} else if(dadosrx[0] == 'b'){
 264  00a1 a162          	cp	a,#98
 265  00a3 260a          	jrne	L57
 266                     ; 119 				GPIO_WriteLow(GPIOE, GPIO_PIN_1); //LIGA led
 268  00a5 4b02          	push	#2
 269  00a7               LC002:
 270  00a7 ae5014        	ldw	x,#20500
 271  00aa cd0000        	call	_GPIO_WriteLow
 274  00ad 2018          	jp	LC001
 275  00af               L57:
 276                     ; 120 			} else if(dadosrx[0] == 'c'){
 278  00af a163          	cp	a,#99
 279  00b1 2703cc002f    	jrne	L54
 280                     ; 121 				GPIO_WriteHigh(GPIOE, GPIO_PIN_0); //DESLIGA led
 282  00b6 4b01          	push	#1
 283  00b8 ae5014        	ldw	x,#20500
 284  00bb cd0000        	call	_GPIO_WriteHigh
 286  00be 84            	pop	a
 287                     ; 122 				GPIO_WriteHigh(GPIOE, GPIO_PIN_1); //DESLIGA led
 289  00bf 4b02          	push	#2
 290  00c1 ae5014        	ldw	x,#20500
 291  00c4 cd0000        	call	_GPIO_WriteHigh
 293  00c7               LC001:
 294  00c7 84            	pop	a
 295  00c8 cc002f        	jra	L54
 319                     ; 158 void CLK_Configuration(void)
 319                     ; 159 {
 320                     	switch	.text
 321  00cb               _CLK_Configuration:
 325                     ; 162   CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
 327  00cb 4f            	clr	a
 329                     ; 164 }
 332  00cc cc0000        	jp	_CLK_HSIPrescalerConfig
 357                     ; 166 void GPIO_Configuration(void)
 357                     ; 167 {
 358                     	switch	.text
 359  00cf               _GPIO_Configuration:
 363                     ; 169   GPIO_DeInit(GPIOD);
 365  00cf ae500f        	ldw	x,#20495
 366  00d2 cd0000        	call	_GPIO_DeInit
 368                     ; 170   GPIO_DeInit(GPIOE);
 370  00d5 ae5014        	ldw	x,#20500
 371  00d8 cd0000        	call	_GPIO_DeInit
 373                     ; 173   GPIO_Init(GPIOD, GPIO_PIN_0, GPIO_MODE_OUT_PP_LOW_FAST); //LED ON BOARD
 375  00db 4be0          	push	#224
 376  00dd 4b01          	push	#1
 377  00df ae500f        	ldw	x,#20495
 378  00e2 cd0000        	call	_GPIO_Init
 380  00e5 85            	popw	x
 381                     ; 175   GPIO_Init(GPIOE, GPIO_PIN_0, GPIO_MODE_OUT_PP_LOW_FAST); //LED 1
 383  00e6 4be0          	push	#224
 384  00e8 4b01          	push	#1
 385  00ea ae5014        	ldw	x,#20500
 386  00ed cd0000        	call	_GPIO_Init
 388  00f0 85            	popw	x
 389                     ; 176   GPIO_Init(GPIOE, GPIO_PIN_1, GPIO_MODE_OUT_PP_LOW_FAST); //LED 2
 391  00f1 4be0          	push	#224
 392  00f3 4b02          	push	#2
 393  00f5 ae5014        	ldw	x,#20500
 394  00f8 cd0000        	call	_GPIO_Init
 396  00fb 85            	popw	x
 397                     ; 179   GPIO_Init(GPIOE, GPIO_PIN_2, GPIO_MODE_IN_FL_NO_IT); //BOTÃO 1
 399  00fc 4b00          	push	#0
 400  00fe 4b04          	push	#4
 401  0100 ae5014        	ldw	x,#20500
 402  0103 cd0000        	call	_GPIO_Init
 404  0106 85            	popw	x
 405                     ; 180   GPIO_Init(GPIOE, GPIO_PIN_3, GPIO_MODE_IN_FL_NO_IT); //BOTÃO 2
 407  0107 4b00          	push	#0
 408  0109 4b08          	push	#8
 409  010b ae5014        	ldw	x,#20500
 410  010e cd0000        	call	_GPIO_Init
 412  0111 85            	popw	x
 413                     ; 182 }
 416  0112 81            	ret	
 451                     .const:	section	.text
 452  0000               L011:
 453  0000 0000ffff      	dc.l	65535
 454                     ; 184 void LCD_GPIO_init(void)
 454                     ; 185 {
 455                     	switch	.text
 456  0113               _LCD_GPIO_init:
 458  0113 5204          	subw	sp,#4
 459       00000004      OFST:	set	4
 462                     ; 187     GPIO_Init(LCD_PORT, LCD_RS, GPIO_MODE_OUT_PP_HIGH_FAST);
 464  0115 4bf0          	push	#240
 465  0117 4b01          	push	#1
 466  0119 ae5005        	ldw	x,#20485
 467  011c cd0000        	call	_GPIO_Init
 469  011f 85            	popw	x
 470                     ; 188     GPIO_Init(LCD_PORT, LCD_EN, GPIO_MODE_OUT_PP_HIGH_FAST);
 472  0120 4bf0          	push	#240
 473  0122 4b02          	push	#2
 474  0124 ae5005        	ldw	x,#20485
 475  0127 cd0000        	call	_GPIO_Init
 477  012a 85            	popw	x
 478                     ; 189     GPIO_Init(LCD_PORT, LCD_DB4, GPIO_MODE_OUT_PP_HIGH_FAST);
 480  012b 4bf0          	push	#240
 481  012d 4b04          	push	#4
 482  012f ae5005        	ldw	x,#20485
 483  0132 cd0000        	call	_GPIO_Init
 485  0135 85            	popw	x
 486                     ; 190     GPIO_Init(LCD_PORT, LCD_DB5, GPIO_MODE_OUT_PP_HIGH_FAST);
 488  0136 4bf0          	push	#240
 489  0138 4b08          	push	#8
 490  013a ae5005        	ldw	x,#20485
 491  013d cd0000        	call	_GPIO_Init
 493  0140 85            	popw	x
 494                     ; 191     GPIO_Init(LCD_PORT, LCD_DB6, GPIO_MODE_OUT_PP_HIGH_FAST);
 496  0141 4bf0          	push	#240
 497  0143 4b10          	push	#16
 498  0145 ae5005        	ldw	x,#20485
 499  0148 cd0000        	call	_GPIO_Init
 501  014b 85            	popw	x
 502                     ; 192     GPIO_Init(LCD_PORT, LCD_DB7, GPIO_MODE_OUT_PP_HIGH_FAST);
 504  014c 4bf0          	push	#240
 505  014e 4b20          	push	#32
 506  0150 ae5005        	ldw	x,#20485
 507  0153 cd0000        	call	_GPIO_Init
 509  0156 85            	popw	x
 510                     ; 194 	for (Tempo_Aux=0;Tempo_Aux<0xFFFF;Tempo_Aux++) continue;
 512  0157 5f            	clrw	x
 513  0158 1f03          	ldw	(OFST-1,sp),x
 514  015a 1f01          	ldw	(OFST-3,sp),x
 516  015c               L341:
 519  015c 96            	ldw	x,sp
 520  015d 5c            	incw	x
 521  015e a601          	ld	a,#1
 522  0160 cd0000        	call	c_lgadc
 527  0163 96            	ldw	x,sp
 528  0164 5c            	incw	x
 529  0165 cd0000        	call	c_ltor
 531  0168 ae0000        	ldw	x,#L011
 532  016b cd0000        	call	c_lcmp
 534  016e 25ec          	jrult	L341
 535                     ; 195 }
 538  0170 5b04          	addw	sp,#4
 539  0172 81            	ret	
 567                     ; 197 void LCD_init(void)
 567                     ; 198 {                                     
 568                     	switch	.text
 569  0173               _LCD_init:
 573                     ; 199      LCD_GPIO_init();    
 575  0173 ad9e          	call	_LCD_GPIO_init
 577                     ; 200     toggle_EN_pin();
 579  0175 cd0294        	call	_toggle_EN_pin
 581                     ; 202     GPIO_WriteLow(LCD_PORT, LCD_RS);            
 583  0178 4b01          	push	#1
 584  017a ae5005        	ldw	x,#20485
 585  017d cd0000        	call	_GPIO_WriteLow
 587  0180 84            	pop	a
 588                     ; 203     GPIO_WriteLow(LCD_PORT, LCD_DB7);   
 590  0181 ad2c          	call	LC003
 591                     ; 206     GPIO_WriteHigh(LCD_PORT, LCD_DB4);                      
 593  0183 ad46          	call	LC004
 595                     ; 209     GPIO_WriteLow(LCD_PORT, LCD_DB7);   
 597  0185 ad28          	call	LC003
 598                     ; 212     GPIO_WriteHigh(LCD_PORT, LCD_DB4);  
 600  0187 ad42          	call	LC004
 602                     ; 215     GPIO_WriteLow(LCD_PORT, LCD_DB7);   
 604  0189 ad24          	call	LC003
 605                     ; 218     GPIO_WriteHigh(LCD_PORT, LCD_DB4);  
 607  018b ad3e          	call	LC004
 609                     ; 221     GPIO_WriteLow(LCD_PORT, LCD_DB7);   
 611  018d ad20          	call	LC003
 612                     ; 224     GPIO_WriteLow(LCD_PORT, LCD_DB4);  
 614  018f 4b04          	push	#4
 615  0191 ae5005        	ldw	x,#20485
 616  0194 cd0000        	call	_GPIO_WriteLow
 618  0197 84            	pop	a
 619                     ; 225     toggle_EN_pin();
 621  0198 cd0294        	call	_toggle_EN_pin
 623                     ; 227     LCD_send((_4_pin_interface | _2_row_display | _5x7_dots), CMD);
 625  019b ae2800        	ldw	x,#10240
 626  019e ad37          	call	_LCD_send
 628                     ; 228     LCD_send((display_on | cursor_off | blink_off), CMD); 
 630  01a0 ae0c00        	ldw	x,#3072
 631  01a3 ad32          	call	_LCD_send
 633                     ; 229     LCD_send(clear_display, CMD);         
 635  01a5 ae0100        	ldw	x,#256
 636  01a8 ad2d          	call	_LCD_send
 638                     ; 230     LCD_send((cursor_direction_inc | display_no_shift), CMD);
 640  01aa ae0600        	ldw	x,#1536
 642                     ; 231 }   
 645  01ad 2028          	jp	_LCD_send
 646  01af               LC003:
 647  01af 4b20          	push	#32
 648  01b1 ae5005        	ldw	x,#20485
 649  01b4 cd0000        	call	_GPIO_WriteLow
 651  01b7 84            	pop	a
 652                     ; 204     GPIO_WriteLow(LCD_PORT, LCD_DB6);   
 654  01b8 4b10          	push	#16
 655  01ba ae5005        	ldw	x,#20485
 656  01bd cd0000        	call	_GPIO_WriteLow
 658  01c0 84            	pop	a
 659                     ; 205     GPIO_WriteHigh(LCD_PORT, LCD_DB5);   
 661  01c1 4b08          	push	#8
 662  01c3 ae5005        	ldw	x,#20485
 663  01c6 cd0000        	call	_GPIO_WriteHigh
 665  01c9 84            	pop	a
 666  01ca 81            	ret	
 667  01cb               LC004:
 668  01cb 4b04          	push	#4
 669  01cd ae5005        	ldw	x,#20485
 670  01d0 cd0000        	call	_GPIO_WriteHigh
 672  01d3 84            	pop	a
 673                     ; 219     toggle_EN_pin();                  
 675  01d4 cc0294        	jp	_toggle_EN_pin
 721                     ; 234 void LCD_send(unsigned char value, unsigned char mode)
 721                     ; 235 {                               
 722                     	switch	.text
 723  01d7               _LCD_send:
 725  01d7 89            	pushw	x
 726       00000000      OFST:	set	0
 729                     ; 236     switch(mode)
 731  01d8 9f            	ld	a,xl
 733                     ; 246               break;
 734  01d9 4d            	tnz	a
 735  01da 270d          	jreq	L161
 736  01dc 4a            	dec	a
 737  01dd 2613          	jrne	L702
 738                     ; 240               GPIO_WriteHigh(LCD_PORT, LCD_RS);   
 740  01df 4b01          	push	#1
 741  01e1 ae5005        	ldw	x,#20485
 742  01e4 cd0000        	call	_GPIO_WriteHigh
 744                     ; 241               break;
 746  01e7 2008          	jp	LC005
 747  01e9               L161:
 748                     ; 245               GPIO_WriteLow(LCD_PORT, LCD_RS);   
 750  01e9 4b01          	push	#1
 751  01eb ae5005        	ldw	x,#20485
 752  01ee cd0000        	call	_GPIO_WriteLow
 754  01f1               LC005:
 755  01f1 84            	pop	a
 756                     ; 246               break;
 758  01f2               L702:
 759                     ; 250        LCD_4bit_send(value);
 761  01f2 7b01          	ld	a,(OFST+1,sp)
 762  01f4 ad02          	call	_LCD_4bit_send
 764                     ; 251 }  
 767  01f6 85            	popw	x
 768  01f7 81            	ret	
 804                     ; 254 void LCD_4bit_send(unsigned char lcd_data)       
 804                     ; 255 {
 805                     	switch	.text
 806  01f8               _LCD_4bit_send:
 808  01f8 88            	push	a
 809       00000000      OFST:	set	0
 812                     ; 256     toggle_io(lcd_data, 7, LCD_DB7);
 814  01f9 4b20          	push	#32
 815  01fb ae0007        	ldw	x,#7
 816  01fe 95            	ld	xh,a
 817  01ff cd02c3        	call	_toggle_io
 819  0202 84            	pop	a
 820                     ; 257     toggle_io(lcd_data, 6, LCD_DB6);
 822  0203 4b10          	push	#16
 823  0205 7b02          	ld	a,(OFST+2,sp)
 824  0207 ae0006        	ldw	x,#6
 825  020a 95            	ld	xh,a
 826  020b cd02c3        	call	_toggle_io
 828  020e 84            	pop	a
 829                     ; 258     toggle_io(lcd_data, 5, LCD_DB5);
 831  020f 4b08          	push	#8
 832  0211 7b02          	ld	a,(OFST+2,sp)
 833  0213 ae0005        	ldw	x,#5
 834  0216 95            	ld	xh,a
 835  0217 cd02c3        	call	_toggle_io
 837  021a 84            	pop	a
 838                     ; 259     toggle_io(lcd_data, 4, LCD_DB4);
 840  021b 4b04          	push	#4
 841  021d 7b02          	ld	a,(OFST+2,sp)
 842  021f ae0004        	ldw	x,#4
 843  0222 95            	ld	xh,a
 844  0223 cd02c3        	call	_toggle_io
 846  0226 84            	pop	a
 847                     ; 260     toggle_EN_pin();
 849  0227 ad6b          	call	_toggle_EN_pin
 851                     ; 261     toggle_io(lcd_data, 3, LCD_DB7);
 853  0229 4b20          	push	#32
 854  022b 7b02          	ld	a,(OFST+2,sp)
 855  022d ae0003        	ldw	x,#3
 856  0230 95            	ld	xh,a
 857  0231 cd02c3        	call	_toggle_io
 859  0234 84            	pop	a
 860                     ; 262     toggle_io(lcd_data, 2, LCD_DB6);
 862  0235 4b10          	push	#16
 863  0237 7b02          	ld	a,(OFST+2,sp)
 864  0239 ae0002        	ldw	x,#2
 865  023c 95            	ld	xh,a
 866  023d cd02c3        	call	_toggle_io
 868  0240 84            	pop	a
 869                     ; 263     toggle_io(lcd_data, 1, LCD_DB5);
 871  0241 4b08          	push	#8
 872  0243 7b02          	ld	a,(OFST+2,sp)
 873  0245 ae0001        	ldw	x,#1
 874  0248 95            	ld	xh,a
 875  0249 ad78          	call	_toggle_io
 877  024b 84            	pop	a
 878                     ; 264     toggle_io(lcd_data, 0, LCD_DB4);
 880  024c 4b04          	push	#4
 881  024e 7b02          	ld	a,(OFST+2,sp)
 882  0250 5f            	clrw	x
 883  0251 95            	ld	xh,a
 884  0252 ad6f          	call	_toggle_io
 886  0254 84            	pop	a
 887                     ; 265     toggle_EN_pin();
 889  0255 ad3d          	call	_toggle_EN_pin
 891                     ; 266 }  
 894  0257 84            	pop	a
 895  0258 81            	ret	
 931                     ; 269 void LCD_putstr(char *lcd_string)
 931                     ; 270 {
 932                     	switch	.text
 933  0259               _LCD_putstr:
 935  0259 89            	pushw	x
 936       00000000      OFST:	set	0
 939  025a f6            	ld	a,(x)
 940  025b               L542:
 941                     ; 273         LCD_send(*lcd_string++, DAT);
 943  025b 5c            	incw	x
 944  025c 1f01          	ldw	(OFST+1,sp),x
 945  025e ae0001        	ldw	x,#1
 946  0261 95            	ld	xh,a
 947  0262 cd01d7        	call	_LCD_send
 949                     ; 274     }while(*lcd_string != '\0');
 951  0265 1e01          	ldw	x,(OFST+1,sp)
 952  0267 f6            	ld	a,(x)
 953  0268 26f1          	jrne	L542
 954                     ; 275 }
 957  026a 85            	popw	x
 958  026b 81            	ret	
 993                     ; 277 void LCD_putchar(char char_data)
 993                     ; 278 {
 994                     	switch	.text
 995  026c               _LCD_putchar:
 999                     ; 279     LCD_send(char_data, DAT);
1001  026c ae0001        	ldw	x,#1
1002  026f 95            	ld	xh,a
1004                     ; 280 }
1007  0270 cc01d7        	jp	_LCD_send
1031                     ; 282 void LCD_clear_home(void)
1031                     ; 283 {
1032                     	switch	.text
1033  0273               _LCD_clear_home:
1037                     ; 284     LCD_send(clear_display, CMD);
1039  0273 ae0100        	ldw	x,#256
1040  0276 cd01d7        	call	_LCD_send
1042                     ; 285     LCD_send(goto_home, CMD);
1044  0279 ae0200        	ldw	x,#512
1046                     ; 286 }
1049  027c cc01d7        	jp	_LCD_send
1093                     ; 288 void LCD_goto(unsigned char  x_pos, unsigned char  y_pos)
1093                     ; 289 {                                                   
1094                     	switch	.text
1095  027f               _LCD_goto:
1097  027f 89            	pushw	x
1098       00000000      OFST:	set	0
1101                     ; 290     if(y_pos == 0)    
1103  0280 9f            	ld	a,xl
1104  0281 4d            	tnz	a
1105  0282 2605          	jrne	L323
1106                     ; 292         LCD_send((0x80 | x_pos), CMD);
1108  0284 9e            	ld	a,xh
1109  0285 aa80          	or	a,#128
1112  0287 2004          	jra	L523
1113  0289               L323:
1114                     ; 296         LCD_send((0x80 | 0x40 | x_pos), CMD); 
1116  0289 7b01          	ld	a,(OFST+1,sp)
1117  028b aac0          	or	a,#192
1119  028d               L523:
1120  028d 5f            	clrw	x
1121  028e 95            	ld	xh,a
1122  028f cd01d7        	call	_LCD_send
1123                     ; 298 }
1126  0292 85            	popw	x
1127  0293 81            	ret	
1163                     	switch	.const
1164  0004               L072:
1165  0004 000005ff      	dc.l	1535
1166                     ; 300 void toggle_EN_pin(void)
1166                     ; 301 {
1167                     	switch	.text
1168  0294               _toggle_EN_pin:
1170  0294 5204          	subw	sp,#4
1171       00000004      OFST:	set	4
1174                     ; 303     GPIO_WriteHigh(LCD_PORT, LCD_EN);    
1176  0296 4b02          	push	#2
1177  0298 ae5005        	ldw	x,#20485
1178  029b cd0000        	call	_GPIO_WriteHigh
1180  029e 5f            	clrw	x
1181  029f 84            	pop	a
1182                     ; 305 		for (Tempo_Aux=0;Tempo_Aux<0x05FF;Tempo_Aux++) continue;
1184  02a0 1f03          	ldw	(OFST-1,sp),x
1185  02a2 1f01          	ldw	(OFST-3,sp),x
1187  02a4               L743:
1190  02a4 96            	ldw	x,sp
1191  02a5 5c            	incw	x
1192  02a6 a601          	ld	a,#1
1193  02a8 cd0000        	call	c_lgadc
1198  02ab 96            	ldw	x,sp
1199  02ac 5c            	incw	x
1200  02ad cd0000        	call	c_ltor
1202  02b0 ae0004        	ldw	x,#L072
1203  02b3 cd0000        	call	c_lcmp
1205  02b6 25ec          	jrult	L743
1206                     ; 306     GPIO_WriteLow(LCD_PORT,LCD_EN);   
1208  02b8 4b02          	push	#2
1209  02ba ae5005        	ldw	x,#20485
1210  02bd cd0000        	call	_GPIO_WriteLow
1212  02c0 5b05          	addw	sp,#5
1213                     ; 307 }
1216  02c2 81            	ret	
1300                     ; 309 void toggle_io(unsigned char lcd_data, unsigned char bit_pos, unsigned char pin_num)
1300                     ; 310 {
1301                     	switch	.text
1302  02c3               _toggle_io:
1304  02c3 89            	pushw	x
1305  02c4 88            	push	a
1306       00000001      OFST:	set	1
1309                     ; 311     bool temp = FALSE;
1311                     ; 313     temp = (0x01 & (lcd_data >> bit_pos));  
1313  02c5 9f            	ld	a,xl
1314  02c6 5f            	clrw	x
1315  02c7 97            	ld	xl,a
1316  02c8 7b02          	ld	a,(OFST+1,sp)
1317  02ca 5d            	tnzw	x
1318  02cb 2704          	jreq	L672
1319  02cd               L003:
1320  02cd 44            	srl	a
1321  02ce 5a            	decw	x
1322  02cf 26fc          	jrne	L003
1323  02d1               L672:
1324  02d1 a401          	and	a,#1
1325  02d3 6b01          	ld	(OFST+0,sp),a
1327                     ; 315     switch(temp)
1329  02d5 4a            	dec	a
1330  02d6 260b          	jrne	L553
1333                     ; 319             GPIO_WriteHigh(LCD_PORT, pin_num);   
1335  02d8 7b06          	ld	a,(OFST+5,sp)
1336  02da 88            	push	a
1337  02db ae5005        	ldw	x,#20485
1338  02de cd0000        	call	_GPIO_WriteHigh
1340                     ; 320             break;
1342  02e1 2009          	jra	L324
1343  02e3               L553:
1344                     ; 325             GPIO_WriteLow(LCD_PORT, pin_num);   
1346  02e3 7b06          	ld	a,(OFST+5,sp)
1347  02e5 88            	push	a
1348  02e6 ae5005        	ldw	x,#20485
1349  02e9 cd0000        	call	_GPIO_WriteLow
1351                     ; 326             break;
1352  02ec               L324:
1353  02ec 5b04          	addw	sp,#4
1354                     ; 329 }
1357  02ee 81            	ret	
1370                     	xdef	_main
1371                     	xdef	_toggle_io
1372                     	xdef	_toggle_EN_pin
1373                     	xdef	_LCD_goto
1374                     	xdef	_LCD_clear_home
1375                     	xdef	_LCD_putchar
1376                     	xdef	_LCD_putstr
1377                     	xdef	_LCD_4bit_send
1378                     	xdef	_LCD_send
1379                     	xdef	_LCD_init
1380                     	xdef	_LCD_GPIO_init
1381                     	xdef	_GPIO_Configuration
1382                     	xdef	_CLK_Configuration
1383                     	xref	_UART2_GetFlagStatus
1384                     	xref	_UART2_ReceiveData8
1385                     	xref	_UART2_Init
1386                     	xref	_GPIO_WriteLow
1387                     	xref	_GPIO_WriteHigh
1388                     	xref	_GPIO_Init
1389                     	xref	_GPIO_DeInit
1390                     	xref	_CLK_HSIPrescalerConfig
1391                     	switch	.const
1392  0008               L34:
1393  0008 55435300      	dc.b	"UCS",0
1413                     	xref	c_lcmp
1414                     	xref	c_ltor
1415                     	xref	c_lgadc
1416                     	xref	c_lzmp
1417                     	xref	c_lgsbc
1418                     	end
