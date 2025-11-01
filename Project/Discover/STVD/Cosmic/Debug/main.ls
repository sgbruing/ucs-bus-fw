   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.5 - 22 May 2025
   4                     ; Optimizer V4.6.5 - 22 May 2025
  55                     ; 53 void main(void)
  55                     ; 54 {
  57                     	switch	.text
  58  0000               _main:
  62                     ; 57     CLK_Configuration();
  64  0000 ad2e          	call	_CLK_Configuration
  66                     ; 60     GPIO_Configuration();
  68  0002 ad30          	call	_GPIO_Configuration
  70                     ; 62     LCD_init();  
  72  0004 cd00d8        	call	_LCD_init
  74                     ; 63     LCD_clear_home(); 
  76  0007 cd01d8        	call	_LCD_clear_home
  78                     ; 65     LCD_goto(3, 0);                              
  80  000a ae0300        	ldw	x,#768
  81  000d cd01e4        	call	_LCD_goto
  83                     ; 66     LCD_putstr("UCS"); 
  85  0010 ae0008        	ldw	x,#L12
  86  0013 cd01be        	call	_LCD_putstr
  88                     ; 68 	UART2_Init(9600,UART2_WORDLENGTH_8D,UART2_STOPBITS_1,UART2_PARITY_NO,UART2_SYNCMODE_CLOCK_DISABLE,UART2_MODE_TXRX_ENABLE);
  90  0016 4b0c          	push	#12
  91  0018 4b80          	push	#128
  92  001a 4b00          	push	#0
  93  001c 4b00          	push	#0
  94  001e 4b00          	push	#0
  95  0020 ae2580        	ldw	x,#9600
  96  0023 89            	pushw	x
  97  0024 5f            	clrw	x
  98  0025 89            	pushw	x
  99  0026 cd0000        	call	_UART2_Init
 101  0029 5b09          	addw	sp,#9
 102  002b               L32:
 103                     ; 73         UCS_Listener();
 105  002b cd0000        	call	_UCS_Listener
 108  002e 20fb          	jra	L32
 132                     ; 94 void CLK_Configuration(void)
 132                     ; 95 {
 133                     	switch	.text
 134  0030               _CLK_Configuration:
 138                     ; 98   CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
 140  0030 4f            	clr	a
 142                     ; 100 }
 145  0031 cc0000        	jp	_CLK_HSIPrescalerConfig
 170                     ; 102 void GPIO_Configuration(void)
 170                     ; 103 {
 171                     	switch	.text
 172  0034               _GPIO_Configuration:
 176                     ; 105   GPIO_DeInit(GPIOD);
 178  0034 ae500f        	ldw	x,#20495
 179  0037 cd0000        	call	_GPIO_DeInit
 181                     ; 106   GPIO_DeInit(GPIOE);
 183  003a ae5014        	ldw	x,#20500
 184  003d cd0000        	call	_GPIO_DeInit
 186                     ; 109   GPIO_Init(GPIOD, GPIO_PIN_0, GPIO_MODE_OUT_PP_LOW_FAST); //LED ON BOARD
 188  0040 4be0          	push	#224
 189  0042 4b01          	push	#1
 190  0044 ae500f        	ldw	x,#20495
 191  0047 cd0000        	call	_GPIO_Init
 193  004a 85            	popw	x
 194                     ; 111   GPIO_Init(GPIOE, GPIO_PIN_0, GPIO_MODE_OUT_PP_LOW_FAST); //LED 1
 196  004b 4be0          	push	#224
 197  004d 4b01          	push	#1
 198  004f ae5014        	ldw	x,#20500
 199  0052 cd0000        	call	_GPIO_Init
 201  0055 85            	popw	x
 202                     ; 112   GPIO_Init(GPIOE, GPIO_PIN_1, GPIO_MODE_OUT_PP_LOW_FAST); //LED 2
 204  0056 4be0          	push	#224
 205  0058 4b02          	push	#2
 206  005a ae5014        	ldw	x,#20500
 207  005d cd0000        	call	_GPIO_Init
 209  0060 85            	popw	x
 210                     ; 115   GPIO_Init(GPIOE, GPIO_PIN_2, GPIO_MODE_IN_FL_NO_IT); //BOT�O 1
 212  0061 4b00          	push	#0
 213  0063 4b04          	push	#4
 214  0065 ae5014        	ldw	x,#20500
 215  0068 cd0000        	call	_GPIO_Init
 217  006b 85            	popw	x
 218                     ; 116   GPIO_Init(GPIOE, GPIO_PIN_3, GPIO_MODE_IN_FL_NO_IT); //BOT�O 2
 220  006c 4b00          	push	#0
 221  006e 4b08          	push	#8
 222  0070 ae5014        	ldw	x,#20500
 223  0073 cd0000        	call	_GPIO_Init
 225  0076 85            	popw	x
 226                     ; 118 }
 229  0077 81            	ret	
 264                     .const:	section	.text
 265  0000               L07:
 266  0000 0000ffff      	dc.l	65535
 267                     ; 120 void LCD_GPIO_init(void)
 267                     ; 121 {
 268                     	switch	.text
 269  0078               _LCD_GPIO_init:
 271  0078 5204          	subw	sp,#4
 272       00000004      OFST:	set	4
 275                     ; 123     GPIO_Init(LCD_PORT, LCD_RS, GPIO_MODE_OUT_PP_HIGH_FAST);
 277  007a 4bf0          	push	#240
 278  007c 4b01          	push	#1
 279  007e ae5005        	ldw	x,#20485
 280  0081 cd0000        	call	_GPIO_Init
 282  0084 85            	popw	x
 283                     ; 124     GPIO_Init(LCD_PORT, LCD_EN, GPIO_MODE_OUT_PP_HIGH_FAST);
 285  0085 4bf0          	push	#240
 286  0087 4b02          	push	#2
 287  0089 ae5005        	ldw	x,#20485
 288  008c cd0000        	call	_GPIO_Init
 290  008f 85            	popw	x
 291                     ; 125     GPIO_Init(LCD_PORT, LCD_DB4, GPIO_MODE_OUT_PP_HIGH_FAST);
 293  0090 4bf0          	push	#240
 294  0092 4b04          	push	#4
 295  0094 ae5005        	ldw	x,#20485
 296  0097 cd0000        	call	_GPIO_Init
 298  009a 85            	popw	x
 299                     ; 126     GPIO_Init(LCD_PORT, LCD_DB5, GPIO_MODE_OUT_PP_HIGH_FAST);
 301  009b 4bf0          	push	#240
 302  009d 4b08          	push	#8
 303  009f ae5005        	ldw	x,#20485
 304  00a2 cd0000        	call	_GPIO_Init
 306  00a5 85            	popw	x
 307                     ; 127     GPIO_Init(LCD_PORT, LCD_DB6, GPIO_MODE_OUT_PP_HIGH_FAST);
 309  00a6 4bf0          	push	#240
 310  00a8 4b10          	push	#16
 311  00aa ae5005        	ldw	x,#20485
 312  00ad cd0000        	call	_GPIO_Init
 314  00b0 85            	popw	x
 315                     ; 128     GPIO_Init(LCD_PORT, LCD_DB7, GPIO_MODE_OUT_PP_HIGH_FAST);
 317  00b1 4bf0          	push	#240
 318  00b3 4b20          	push	#32
 319  00b5 ae5005        	ldw	x,#20485
 320  00b8 cd0000        	call	_GPIO_Init
 322  00bb 85            	popw	x
 323                     ; 130 	for (Tempo_Aux=0;Tempo_Aux<0xFFFF;Tempo_Aux++) continue;
 325  00bc 5f            	clrw	x
 326  00bd 1f03          	ldw	(OFST-1,sp),x
 327  00bf 1f01          	ldw	(OFST-3,sp),x
 329  00c1               L76:
 332  00c1 96            	ldw	x,sp
 333  00c2 5c            	incw	x
 334  00c3 a601          	ld	a,#1
 335  00c5 cd0000        	call	c_lgadc
 340  00c8 96            	ldw	x,sp
 341  00c9 5c            	incw	x
 342  00ca cd0000        	call	c_ltor
 344  00cd ae0000        	ldw	x,#L07
 345  00d0 cd0000        	call	c_lcmp
 347  00d3 25ec          	jrult	L76
 348                     ; 131 }
 351  00d5 5b04          	addw	sp,#4
 352  00d7 81            	ret	
 380                     ; 133 void LCD_init(void)
 380                     ; 134 {                                     
 381                     	switch	.text
 382  00d8               _LCD_init:
 386                     ; 135      LCD_GPIO_init();    
 388  00d8 ad9e          	call	_LCD_GPIO_init
 390                     ; 136     toggle_EN_pin();
 392  00da cd01f9        	call	_toggle_EN_pin
 394                     ; 138     GPIO_WriteLow(LCD_PORT, LCD_RS);            
 396  00dd 4b01          	push	#1
 397  00df ae5005        	ldw	x,#20485
 398  00e2 cd0000        	call	_GPIO_WriteLow
 400  00e5 84            	pop	a
 401                     ; 139     GPIO_WriteLow(LCD_PORT, LCD_DB7);   
 403  00e6 ad2c          	call	LC001
 404                     ; 142     GPIO_WriteHigh(LCD_PORT, LCD_DB4);                      
 406  00e8 ad46          	call	LC002
 408                     ; 145     GPIO_WriteLow(LCD_PORT, LCD_DB7);   
 410  00ea ad28          	call	LC001
 411                     ; 148     GPIO_WriteHigh(LCD_PORT, LCD_DB4);  
 413  00ec ad42          	call	LC002
 415                     ; 151     GPIO_WriteLow(LCD_PORT, LCD_DB7);   
 417  00ee ad24          	call	LC001
 418                     ; 154     GPIO_WriteHigh(LCD_PORT, LCD_DB4);  
 420  00f0 ad3e          	call	LC002
 422                     ; 157     GPIO_WriteLow(LCD_PORT, LCD_DB7);   
 424  00f2 ad20          	call	LC001
 425                     ; 160     GPIO_WriteLow(LCD_PORT, LCD_DB4);  
 427  00f4 4b04          	push	#4
 428  00f6 ae5005        	ldw	x,#20485
 429  00f9 cd0000        	call	_GPIO_WriteLow
 431  00fc 84            	pop	a
 432                     ; 161     toggle_EN_pin();
 434  00fd cd01f9        	call	_toggle_EN_pin
 436                     ; 163     LCD_send((_4_pin_interface | _2_row_display | _5x7_dots), CMD);
 438  0100 ae2800        	ldw	x,#10240
 439  0103 ad37          	call	_LCD_send
 441                     ; 164     LCD_send((display_on | cursor_off | blink_off), CMD); 
 443  0105 ae0c00        	ldw	x,#3072
 444  0108 ad32          	call	_LCD_send
 446                     ; 165     LCD_send(clear_display, CMD);         
 448  010a ae0100        	ldw	x,#256
 449  010d ad2d          	call	_LCD_send
 451                     ; 166     LCD_send((cursor_direction_inc | display_no_shift), CMD);
 453  010f ae0600        	ldw	x,#1536
 455                     ; 167 }   
 458  0112 2028          	jp	_LCD_send
 459  0114               LC001:
 460  0114 4b20          	push	#32
 461  0116 ae5005        	ldw	x,#20485
 462  0119 cd0000        	call	_GPIO_WriteLow
 464  011c 84            	pop	a
 465                     ; 140     GPIO_WriteLow(LCD_PORT, LCD_DB6);   
 467  011d 4b10          	push	#16
 468  011f ae5005        	ldw	x,#20485
 469  0122 cd0000        	call	_GPIO_WriteLow
 471  0125 84            	pop	a
 472                     ; 141     GPIO_WriteHigh(LCD_PORT, LCD_DB5);   
 474  0126 4b08          	push	#8
 475  0128 ae5005        	ldw	x,#20485
 476  012b cd0000        	call	_GPIO_WriteHigh
 478  012e 84            	pop	a
 479  012f 81            	ret	
 480  0130               LC002:
 481  0130 4b04          	push	#4
 482  0132 ae5005        	ldw	x,#20485
 483  0135 cd0000        	call	_GPIO_WriteHigh
 485  0138 84            	pop	a
 486                     ; 155     toggle_EN_pin();                  
 488  0139 cc01f9        	jp	_toggle_EN_pin
 534                     ; 170 void LCD_send(unsigned char value, unsigned char mode)
 534                     ; 171 {                               
 535                     	switch	.text
 536  013c               _LCD_send:
 538  013c 89            	pushw	x
 539       00000000      OFST:	set	0
 542                     ; 172     switch(mode)
 544  013d 9f            	ld	a,xl
 546                     ; 182               break;
 547  013e 4d            	tnz	a
 548  013f 270d          	jreq	L501
 549  0141 4a            	dec	a
 550  0142 2613          	jrne	L331
 551                     ; 176               GPIO_WriteHigh(LCD_PORT, LCD_RS);   
 553  0144 4b01          	push	#1
 554  0146 ae5005        	ldw	x,#20485
 555  0149 cd0000        	call	_GPIO_WriteHigh
 557                     ; 177               break;
 559  014c 2008          	jp	LC003
 560  014e               L501:
 561                     ; 181               GPIO_WriteLow(LCD_PORT, LCD_RS);   
 563  014e 4b01          	push	#1
 564  0150 ae5005        	ldw	x,#20485
 565  0153 cd0000        	call	_GPIO_WriteLow
 567  0156               LC003:
 568  0156 84            	pop	a
 569                     ; 182               break;
 571  0157               L331:
 572                     ; 186        LCD_4bit_send(value);
 574  0157 7b01          	ld	a,(OFST+1,sp)
 575  0159 ad02          	call	_LCD_4bit_send
 577                     ; 187 }  
 580  015b 85            	popw	x
 581  015c 81            	ret	
 617                     ; 190 void LCD_4bit_send(unsigned char lcd_data)       
 617                     ; 191 {
 618                     	switch	.text
 619  015d               _LCD_4bit_send:
 621  015d 88            	push	a
 622       00000000      OFST:	set	0
 625                     ; 192     toggle_io(lcd_data, 7, LCD_DB7);
 627  015e 4b20          	push	#32
 628  0160 ae0007        	ldw	x,#7
 629  0163 95            	ld	xh,a
 630  0164 cd0228        	call	_toggle_io
 632  0167 84            	pop	a
 633                     ; 193     toggle_io(lcd_data, 6, LCD_DB6);
 635  0168 4b10          	push	#16
 636  016a 7b02          	ld	a,(OFST+2,sp)
 637  016c ae0006        	ldw	x,#6
 638  016f 95            	ld	xh,a
 639  0170 cd0228        	call	_toggle_io
 641  0173 84            	pop	a
 642                     ; 194     toggle_io(lcd_data, 5, LCD_DB5);
 644  0174 4b08          	push	#8
 645  0176 7b02          	ld	a,(OFST+2,sp)
 646  0178 ae0005        	ldw	x,#5
 647  017b 95            	ld	xh,a
 648  017c cd0228        	call	_toggle_io
 650  017f 84            	pop	a
 651                     ; 195     toggle_io(lcd_data, 4, LCD_DB4);
 653  0180 4b04          	push	#4
 654  0182 7b02          	ld	a,(OFST+2,sp)
 655  0184 ae0004        	ldw	x,#4
 656  0187 95            	ld	xh,a
 657  0188 cd0228        	call	_toggle_io
 659  018b 84            	pop	a
 660                     ; 196     toggle_EN_pin();
 662  018c ad6b          	call	_toggle_EN_pin
 664                     ; 197     toggle_io(lcd_data, 3, LCD_DB7);
 666  018e 4b20          	push	#32
 667  0190 7b02          	ld	a,(OFST+2,sp)
 668  0192 ae0003        	ldw	x,#3
 669  0195 95            	ld	xh,a
 670  0196 cd0228        	call	_toggle_io
 672  0199 84            	pop	a
 673                     ; 198     toggle_io(lcd_data, 2, LCD_DB6);
 675  019a 4b10          	push	#16
 676  019c 7b02          	ld	a,(OFST+2,sp)
 677  019e ae0002        	ldw	x,#2
 678  01a1 95            	ld	xh,a
 679  01a2 cd0228        	call	_toggle_io
 681  01a5 84            	pop	a
 682                     ; 199     toggle_io(lcd_data, 1, LCD_DB5);
 684  01a6 4b08          	push	#8
 685  01a8 7b02          	ld	a,(OFST+2,sp)
 686  01aa ae0001        	ldw	x,#1
 687  01ad 95            	ld	xh,a
 688  01ae ad78          	call	_toggle_io
 690  01b0 84            	pop	a
 691                     ; 200     toggle_io(lcd_data, 0, LCD_DB4);
 693  01b1 4b04          	push	#4
 694  01b3 7b02          	ld	a,(OFST+2,sp)
 695  01b5 5f            	clrw	x
 696  01b6 95            	ld	xh,a
 697  01b7 ad6f          	call	_toggle_io
 699  01b9 84            	pop	a
 700                     ; 201     toggle_EN_pin();
 702  01ba ad3d          	call	_toggle_EN_pin
 704                     ; 202 }  
 707  01bc 84            	pop	a
 708  01bd 81            	ret	
 744                     ; 205 void LCD_putstr(char *lcd_string)
 744                     ; 206 {
 745                     	switch	.text
 746  01be               _LCD_putstr:
 748  01be 89            	pushw	x
 749       00000000      OFST:	set	0
 752  01bf f6            	ld	a,(x)
 753  01c0               L171:
 754                     ; 209         LCD_send(*lcd_string++, DAT);
 756  01c0 5c            	incw	x
 757  01c1 1f01          	ldw	(OFST+1,sp),x
 758  01c3 ae0001        	ldw	x,#1
 759  01c6 95            	ld	xh,a
 760  01c7 cd013c        	call	_LCD_send
 762                     ; 210     }while(*lcd_string != '\0');
 764  01ca 1e01          	ldw	x,(OFST+1,sp)
 765  01cc f6            	ld	a,(x)
 766  01cd 26f1          	jrne	L171
 767                     ; 211 }
 770  01cf 85            	popw	x
 771  01d0 81            	ret	
 806                     ; 213 void LCD_putchar(char char_data)
 806                     ; 214 {
 807                     	switch	.text
 808  01d1               _LCD_putchar:
 812                     ; 215     LCD_send(char_data, DAT);
 814  01d1 ae0001        	ldw	x,#1
 815  01d4 95            	ld	xh,a
 817                     ; 216 }
 820  01d5 cc013c        	jp	_LCD_send
 844                     ; 218 void LCD_clear_home(void)
 844                     ; 219 {
 845                     	switch	.text
 846  01d8               _LCD_clear_home:
 850                     ; 220     LCD_send(clear_display, CMD);
 852  01d8 ae0100        	ldw	x,#256
 853  01db cd013c        	call	_LCD_send
 855                     ; 221     LCD_send(goto_home, CMD);
 857  01de ae0200        	ldw	x,#512
 859                     ; 222 }
 862  01e1 cc013c        	jp	_LCD_send
 906                     ; 224 void LCD_goto(unsigned char  x_pos, unsigned char  y_pos)
 906                     ; 225 {                                                   
 907                     	switch	.text
 908  01e4               _LCD_goto:
 910  01e4 89            	pushw	x
 911       00000000      OFST:	set	0
 914                     ; 226     if(y_pos == 0)    
 916  01e5 9f            	ld	a,xl
 917  01e6 4d            	tnz	a
 918  01e7 2605          	jrne	L742
 919                     ; 228         LCD_send((0x80 | x_pos), CMD);
 921  01e9 9e            	ld	a,xh
 922  01ea aa80          	or	a,#128
 925  01ec 2004          	jra	L152
 926  01ee               L742:
 927                     ; 232         LCD_send((0x80 | 0x40 | x_pos), CMD); 
 929  01ee 7b01          	ld	a,(OFST+1,sp)
 930  01f0 aac0          	or	a,#192
 932  01f2               L152:
 933  01f2 5f            	clrw	x
 934  01f3 95            	ld	xh,a
 935  01f4 cd013c        	call	_LCD_send
 936                     ; 234 }
 939  01f7 85            	popw	x
 940  01f8 81            	ret	
 976                     	switch	.const
 977  0004               L052:
 978  0004 000005ff      	dc.l	1535
 979                     ; 236 void toggle_EN_pin(void)
 979                     ; 237 {
 980                     	switch	.text
 981  01f9               _toggle_EN_pin:
 983  01f9 5204          	subw	sp,#4
 984       00000004      OFST:	set	4
 987                     ; 239     GPIO_WriteHigh(LCD_PORT, LCD_EN);    
 989  01fb 4b02          	push	#2
 990  01fd ae5005        	ldw	x,#20485
 991  0200 cd0000        	call	_GPIO_WriteHigh
 993  0203 5f            	clrw	x
 994  0204 84            	pop	a
 995                     ; 241 		for (Tempo_Aux=0;Tempo_Aux<0x05FF;Tempo_Aux++) continue;
 997  0205 1f03          	ldw	(OFST-1,sp),x
 998  0207 1f01          	ldw	(OFST-3,sp),x
1000  0209               L372:
1003  0209 96            	ldw	x,sp
1004  020a 5c            	incw	x
1005  020b a601          	ld	a,#1
1006  020d cd0000        	call	c_lgadc
1011  0210 96            	ldw	x,sp
1012  0211 5c            	incw	x
1013  0212 cd0000        	call	c_ltor
1015  0215 ae0004        	ldw	x,#L052
1016  0218 cd0000        	call	c_lcmp
1018  021b 25ec          	jrult	L372
1019                     ; 242     GPIO_WriteLow(LCD_PORT,LCD_EN);   
1021  021d 4b02          	push	#2
1022  021f ae5005        	ldw	x,#20485
1023  0222 cd0000        	call	_GPIO_WriteLow
1025  0225 5b05          	addw	sp,#5
1026                     ; 243 }
1029  0227 81            	ret	
1113                     ; 245 void toggle_io(unsigned char lcd_data, unsigned char bit_pos, unsigned char pin_num)
1113                     ; 246 {
1114                     	switch	.text
1115  0228               _toggle_io:
1117  0228 89            	pushw	x
1118  0229 88            	push	a
1119       00000001      OFST:	set	1
1122                     ; 247     bool temp = FALSE;
1124                     ; 249     temp = (0x01 & (lcd_data >> bit_pos));  
1126  022a 9f            	ld	a,xl
1127  022b 5f            	clrw	x
1128  022c 97            	ld	xl,a
1129  022d 7b02          	ld	a,(OFST+1,sp)
1130  022f 5d            	tnzw	x
1131  0230 2704          	jreq	L652
1132  0232               L062:
1133  0232 44            	srl	a
1134  0233 5a            	decw	x
1135  0234 26fc          	jrne	L062
1136  0236               L652:
1137  0236 a401          	and	a,#1
1138  0238 6b01          	ld	(OFST+0,sp),a
1140                     ; 251     switch(temp)
1142  023a 4a            	dec	a
1143  023b 260b          	jrne	L103
1146                     ; 255             GPIO_WriteHigh(LCD_PORT, pin_num);   
1148  023d 7b06          	ld	a,(OFST+5,sp)
1149  023f 88            	push	a
1150  0240 ae5005        	ldw	x,#20485
1151  0243 cd0000        	call	_GPIO_WriteHigh
1153                     ; 256             break;
1155  0246 2009          	jra	L743
1156  0248               L103:
1157                     ; 261             GPIO_WriteLow(LCD_PORT, pin_num);   
1159  0248 7b06          	ld	a,(OFST+5,sp)
1160  024a 88            	push	a
1161  024b ae5005        	ldw	x,#20485
1162  024e cd0000        	call	_GPIO_WriteLow
1164                     ; 262             break;
1165  0251               L743:
1166  0251 5b04          	addw	sp,#4
1167                     ; 265 }
1170  0253 81            	ret	
1183                     	xdef	_main
1184                     	xdef	_toggle_io
1185                     	xdef	_toggle_EN_pin
1186                     	xdef	_LCD_goto
1187                     	xdef	_LCD_clear_home
1188                     	xdef	_LCD_putchar
1189                     	xdef	_LCD_putstr
1190                     	xdef	_LCD_4bit_send
1191                     	xdef	_LCD_send
1192                     	xdef	_LCD_init
1193                     	xdef	_LCD_GPIO_init
1194                     	xdef	_GPIO_Configuration
1195                     	xdef	_CLK_Configuration
1196                     	xref	_UCS_Listener
1197                     	xref	_UART2_Init
1198                     	xref	_GPIO_WriteLow
1199                     	xref	_GPIO_WriteHigh
1200                     	xref	_GPIO_Init
1201                     	xref	_GPIO_DeInit
1202                     	xref	_CLK_HSIPrescalerConfig
1203                     	switch	.const
1204  0008               L12:
1205  0008 55435300      	dc.b	"UCS",0
1225                     	xref	c_lcmp
1226                     	xref	c_ltor
1227                     	xref	c_lgadc
1228                     	end
