   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.5 - 22 May 2025
   4                     ; Optimizer V4.6.5 - 22 May 2025
 152                     ; 8 void Context_Init(UCS_Context* ctx, uint8_t my_address) {
 154                     	switch	.text
 155  0000               _Context_Init:
 157       fffffffe      OFST: set -2
 160                     ; 9     ctx->my_address = my_address;
 162  0000 7b03          	ld	a,(OFST+5,sp)
 163  0002 f7            	ld	(x),a
 164                     ; 10     ctx->rx_index = 0;
 166  0003 6f47          	clr	(71,x)
 167                     ; 11     ctx->expected_length = 0;
 169  0005 6f48          	clr	(72,x)
 170                     ; 12     ctx->state = WAIT_STX;
 172  0007 6f49          	clr	(73,x)
 173                     ; 13 }
 176  0009 81            	ret	
 201                     ; 15 void UCS_Init() {
 202                     	switch	.text
 203  000a               _UCS_Init:
 207                     ; 16     Context_Init(&ucs_context, MY_ADRESS);
 209  000a 4b01          	push	#1
 210  000c ae008e        	ldw	x,#_ucs_context
 211  000f adef          	call	_Context_Init
 213  0011 84            	pop	a
 214                     ; 17 }
 217  0012 81            	ret	
 274                     ; 19 void UCS_Listener(){
 275                     	switch	.text
 276  0013               _UCS_Listener:
 278  0013 5208          	subw	sp,#8
 279       00000008      OFST:	set	8
 282                     ; 21     unsigned long timeout = 0xFFFF;
 284  0015 aeffff        	ldw	x,#65535
 285  0018 1f05          	ldw	(OFST-3,sp),x
 286  001a 5f            	clrw	x
 287  001b 1f03          	ldw	(OFST-5,sp),x
 289                     ; 22     int i, cont = 0;
 291  001d 1f01          	ldw	(OFST-7,sp),x
 293                     ; 23     for(i=0; i<MAX_FRAME_LENGTH; i++){
 296  001f               L341:
 297                     ; 24         ucs_context.rx_buffer[i] = 0;
 300  001f 6f8f          	clr	(_ucs_context+1,x)
 301                     ; 23     for(i=0; i<MAX_FRAME_LENGTH; i++){
 303  0021 5c            	incw	x
 306  0022 a30046        	cpw	x,#70
 307  0025 2ff8          	jrslt	L341
 308  0027 1f07          	ldw	(OFST-1,sp),x
 310                     ; 26     ucs_context.rx_index = 0;
 312  0029 3fd5          	clr	_ucs_context+71
 313                     ; 27     ucs_context.expected_length = 0;   
 315  002b 3fd6          	clr	_ucs_context+72
 316  002d               L151:
 317                     ; 31         if (UART2_GetFlagStatus(UART2_FLAG_RXNE) == TRUE){
 319  002d ae0020        	ldw	x,#32
 320  0030 cd0000        	call	_UART2_GetFlagStatus
 322  0033 4a            	dec	a
 323  0034 2612          	jrne	L751
 324                     ; 32             ucs_context.rx_buffer[cont] = UART2_ReceiveData8(); 
 326  0036 cd0000        	call	_UART2_ReceiveData8
 328  0039 1e01          	ldw	x,(OFST-7,sp)
 329  003b e78f          	ld	(_ucs_context+1,x),a
 330                     ; 33             cont++;
 332  003d 5c            	incw	x
 333  003e 1f01          	ldw	(OFST-7,sp),x
 335                     ; 34             timeout = 0xFFFF;
 337  0040 aeffff        	ldw	x,#65535
 338  0043 1f05          	ldw	(OFST-3,sp),x
 339  0045 5f            	clrw	x
 340  0046 1f03          	ldw	(OFST-5,sp),x
 342  0048               L751:
 343                     ; 36         timeout--;
 345  0048 96            	ldw	x,sp
 346  0049 1c0003        	addw	x,#OFST-5
 347  004c a601          	ld	a,#1
 348  004e cd0000        	call	c_lgsbc
 351                     ; 38     } while(timeout>0);
 353  0051 96            	ldw	x,sp
 354  0052 1c0003        	addw	x,#OFST-5
 355  0055 cd0000        	call	c_lzmp
 357  0058 26d3          	jrne	L151
 358                     ; 40     if (cont>0){
 360  005a 9c            	rvf	
 361  005b 1e01          	ldw	x,(OFST-7,sp)
 362  005d 2d4a          	jrsle	L161
 363                     ; 41         ucs_context.state = WAIT_STX;
 365  005f 3fd7          	clr	_ucs_context+73
 366                     ; 42         i=0;
 368                     ; 43         for(i=0; i<MAX_FRAME_LENGTH; i++){
 370  0061 5f            	clrw	x
 371  0062 1f07          	ldw	(OFST-1,sp),x
 373  0064               L361:
 374                     ; 45             switch (ucs_context.state)
 376  0064 b6d7          	ld	a,_ucs_context+73
 378                     ; 64                 default:
 378                     ; 65                     break;
 379  0066 270b          	jreq	L301
 380  0068 4a            	dec	a
 381  0069 2718          	jreq	L501
 382  006b 4a            	dec	a
 383  006c 2725          	jreq	L111
 384  006e 4a            	dec	a
 385  006f 271c          	jreq	L701
 386  0071 202c          	jra	L371
 387  0073               L301:
 388                     ; 47                 case WAIT_STX:
 388                     ; 48                     if(ucs_context.rx_buffer[i] == STX){
 390  0073 e68f          	ld	a,(_ucs_context+1,x)
 391  0075 a102          	cp	a,#2
 392  0077 2626          	jrne	L371
 393                     ; 49                         ucs_context.state = WAIT_LEN;
 395  0079 350100d7      	mov	_ucs_context+73,#1
 396                     ; 50                         ucs_context.rx_index = i;
 398  007d 7b08          	ld	a,(OFST+0,sp)
 399  007f b7d5          	ld	_ucs_context+71,a
 400  0081 201c          	jra	L371
 401  0083               L501:
 402                     ; 53                 case WAIT_LEN:
 402                     ; 54                     ucs_context.expected_length = ucs_context.rx_buffer[i];
 404  0083 e68f          	ld	a,(_ucs_context+1,x)
 405  0085 b7d6          	ld	_ucs_context+72,a
 406                     ; 55                     ucs_context.state = BCC_VERIFY;
 408  0087 350300d7      	mov	_ucs_context+73,#3
 409                     ; 56                     break;
 411  008b 2012          	jra	L371
 412  008d               L701:
 413                     ; 57                 case BCC_VERIFY:
 413                     ; 58                     ucs_context.state = READ_PAYLOAD;
 415  008d 350200d7      	mov	_ucs_context+73,#2
 416                     ; 59                     break;
 418  0091 200c          	jra	L371
 419  0093               L111:
 420                     ; 60                 case READ_PAYLOAD:
 420                     ; 61                     Process_Frame(&ucs_context, &frame_RX);
 422  0093 ae0047        	ldw	x,#_frame_RX
 423  0096 89            	pushw	x
 424  0097 ae008e        	ldw	x,#_ucs_context
 425  009a ad10          	call	_Process_Frame
 427  009c 3fd7          	clr	_ucs_context+73
 428  009e 85            	popw	x
 429                     ; 62                     ucs_context.state = WAIT_STX;
 431                     ; 63                     break;
 433                     ; 64                 default:
 433                     ; 65                     break;
 435  009f               L371:
 436                     ; 43         for(i=0; i<MAX_FRAME_LENGTH; i++){
 438  009f 1e07          	ldw	x,(OFST-1,sp)
 439  00a1 5c            	incw	x
 440  00a2 1f07          	ldw	(OFST-1,sp),x
 444  00a4 a30046        	cpw	x,#70
 445  00a7 2fbb          	jrslt	L361
 446  00a9               L161:
 447                     ; 70 }
 450  00a9 5b08          	addw	sp,#8
 451  00ab 81            	ret	
 595                     ; 72 void Process_Frame(UCS_Context* ctx, UCS_Frame* frame_RX) {
 596                     	switch	.text
 597  00ac               _Process_Frame:
 599  00ac 89            	pushw	x
 600  00ad 5203          	subw	sp,#3
 601       00000003      OFST:	set	3
 604                     ; 73     uint8_t idx = ctx->rx_index;
 606  00af e647          	ld	a,(71,x)
 607  00b1 6b03          	ld	(OFST+0,sp),a
 609                     ; 74     uint8_t tam = ctx->rx_buffer[idx + 1]; /* Tam = bytes Tam..BCC inclusive */
 611  00b3 01            	rrwa	x,a
 612  00b4 1b03          	add	a,(OFST+0,sp)
 613  00b6 2401          	jrnc	L42
 614  00b8 5c            	incw	x
 615  00b9               L42:
 616  00b9 02            	rlwa	x,a
 617  00ba e602          	ld	a,(2,x)
 618  00bc 6b02          	ld	(OFST-1,sp),a
 620                     ; 76     frame_RX->stx = ctx->rx_buffer[idx];
 622  00be 5f            	clrw	x
 623  00bf 7b03          	ld	a,(OFST+0,sp)
 624  00c1 97            	ld	xl,a
 625  00c2 72fb04        	addw	x,(OFST+1,sp)
 626  00c5 e601          	ld	a,(1,x)
 627  00c7 1e08          	ldw	x,(OFST+5,sp)
 628  00c9 f7            	ld	(x),a
 629                     ; 77     frame_RX->length = tam;
 631  00ca 7b02          	ld	a,(OFST-1,sp)
 632  00cc e701          	ld	(1,x),a
 633                     ; 78     frame_RX->dest = ctx->rx_buffer[idx + 2];
 635  00ce 5f            	clrw	x
 636  00cf 7b03          	ld	a,(OFST+0,sp)
 637  00d1 97            	ld	xl,a
 638  00d2 72fb04        	addw	x,(OFST+1,sp)
 639  00d5 e603          	ld	a,(3,x)
 640  00d7 1e08          	ldw	x,(OFST+5,sp)
 641  00d9 e702          	ld	(2,x),a
 642                     ; 79     frame_RX->src = ctx->rx_buffer[idx + 3];
 644  00db 5f            	clrw	x
 645  00dc 7b03          	ld	a,(OFST+0,sp)
 646  00de 97            	ld	xl,a
 647  00df 72fb04        	addw	x,(OFST+1,sp)
 648  00e2 e604          	ld	a,(4,x)
 649  00e4 1e08          	ldw	x,(OFST+5,sp)
 650  00e6 e703          	ld	(3,x),a
 651                     ; 80     frame_RX->cmd = ctx->rx_buffer[idx + 4];
 653  00e8 5f            	clrw	x
 654  00e9 7b03          	ld	a,(OFST+0,sp)
 655  00eb 97            	ld	xl,a
 656  00ec 72fb04        	addw	x,(OFST+1,sp)
 657  00ef e605          	ld	a,(5,x)
 658  00f1 1e08          	ldw	x,(OFST+5,sp)
 659  00f3 e704          	ld	(4,x),a
 660                     ; 83     if (tam > 5) {
 662  00f5 7b02          	ld	a,(OFST-1,sp)
 663  00f7 a106          	cp	a,#6
 664  00f9 2526          	jrult	L762
 665                     ; 84         uint8_t dlen = tam - 5;
 667  00fb a005          	sub	a,#5
 669                     ; 85         if (dlen > MAX_DATA_LENGTH) dlen = MAX_DATA_LENGTH; /* proteção */
 671  00fd a141          	cp	a,#65
 672  00ff 2502          	jrult	L172
 675  0101 a640          	ld	a,#64
 677  0103               L172:
 678  0103 6b01          	ld	(OFST-2,sp),a
 679                     ; 86         frame_RX->data_len = dlen;
 681  0105 e745          	ld	(69,x),a
 682                     ; 87         memcpy(frame_RX->data, &ctx->rx_buffer[idx + 5], dlen);
 684  0107 5f            	clrw	x
 685  0108 97            	ld	xl,a
 686  0109 89            	pushw	x
 687  010a 7b05          	ld	a,(OFST+2,sp)
 688  010c 5f            	clrw	x
 689  010d 97            	ld	xl,a
 690  010e 72fb06        	addw	x,(OFST+3,sp)
 691  0111 1c0006        	addw	x,#6
 692  0114 89            	pushw	x
 693  0115 1e0c          	ldw	x,(OFST+9,sp)
 694  0117 1c0005        	addw	x,#5
 695  011a cd0000        	call	_memcpy
 697  011d 5b04          	addw	sp,#4
 699  011f 2002          	jra	L372
 700  0121               L762:
 701                     ; 89         frame_RX->data_len = 0;
 703  0121 6f45          	clr	(69,x)
 704  0123               L372:
 705                     ; 93     frame_RX->bcc = ctx->rx_buffer[idx + tam];
 707  0123 7b04          	ld	a,(OFST+1,sp)
 708  0125 97            	ld	xl,a
 709  0126 7b05          	ld	a,(OFST+2,sp)
 710  0128 1b02          	add	a,(OFST-1,sp)
 711  012a 2401          	jrnc	L03
 712  012c 5c            	incw	x
 713  012d               L03:
 714  012d 1b03          	add	a,(OFST+0,sp)
 715  012f 2401          	jrnc	L23
 716  0131 5c            	incw	x
 717  0132               L23:
 718  0132 02            	rlwa	x,a
 719  0133 e601          	ld	a,(1,x)
 720  0135 1e08          	ldw	x,(OFST+5,sp)
 721  0137 e746          	ld	(70,x),a
 722                     ; 95     command_handler(frame_RX);
 724  0139 ad03          	call	_command_handler
 726                     ; 96 }
 729  013b 5b05          	addw	sp,#5
 730  013d 81            	ret	
 771                     ; 98 void command_handler(UCS_Frame* frame) {
 772                     	switch	.text
 773  013e               _command_handler:
 775  013e 89            	pushw	x
 776       00000000      OFST:	set	0
 779                     ; 99     switch (frame->cmd) {
 781  013f e604          	ld	a,(4,x)
 783                     ; 121         default:
 783                     ; 122             // Handle unknown command
 783                     ; 123             break;
 784  0141 4a            	dec	a
 785  0142 2714          	jreq	L572
 786  0144 4a            	dec	a
 787  0145 2716          	jreq	L772
 788  0147 4a            	dec	a
 789  0148 2719          	jreq	L103
 790  014a 4a            	dec	a
 791  014b 271d          	jreq	L303
 792  014d 4a            	dec	a
 793  014e 2724          	jreq	L503
 794  0150 4a            	dec	a
 795  0151 2728          	jreq	L703
 796  0153 4a            	dec	a
 797  0154 2730          	jreq	L113
 798  0156 2034          	jra	L733
 799  0158               L572:
 800                     ; 100         case CMD_BTN_STATUS_1:
 800                     ; 101             read_button_status(1);
 802  0158 4c            	inc	a
 803  0159 ad33          	call	_read_button_status
 805                     ; 102             break;
 807  015b 202f          	jra	L733
 808  015d               L772:
 809                     ; 103         case CMD_BTN_STATUS_2:
 809                     ; 104             read_button_status(2);
 811  015d a602          	ld	a,#2
 812  015f ad2d          	call	_read_button_status
 814                     ; 105             break;
 816  0161 2029          	jra	L733
 817  0163               L103:
 818                     ; 106         case CMD_LED_WRITE_1:
 818                     ; 107             set_led_state(1, frame->data);
 820  0163 1c0005        	addw	x,#5
 821  0166 89            	pushw	x
 822  0167 4c            	inc	a
 824                     ; 108             break;
 826  0168 2006          	jp	LC003
 827  016a               L303:
 828                     ; 109         case CMD_LED_WRITE_2:
 828                     ; 110             set_led_state(2, frame->data);
 830  016a 1c0005        	addw	x,#5
 831  016d 89            	pushw	x
 832  016e a602          	ld	a,#2
 833  0170               LC003:
 834  0170 ad1d          	call	_set_led_state
 836                     ; 111             break;
 838  0172 200f          	jp	LC001
 839  0174               L503:
 840                     ; 112         case CMD_LED_BLINK_1:
 840                     ; 113             blink_led(1, frame->data);
 842  0174 1c0005        	addw	x,#5
 843  0177 89            	pushw	x
 844  0178 4c            	inc	a
 846                     ; 114             break;
 848  0179 2006          	jp	LC002
 849  017b               L703:
 850                     ; 115         case CMD_LED_BLINK_2:
 850                     ; 116             blink_led(2, frame->data);
 852  017b 1c0005        	addw	x,#5
 853  017e 89            	pushw	x
 854  017f a602          	ld	a,#2
 855  0181               LC002:
 856  0181 ad42          	call	_blink_led
 858  0183               LC001:
 859  0183 85            	popw	x
 860                     ; 117             break;
 862  0184 2006          	jra	L733
 863  0186               L113:
 864                     ; 118         case CMD_DISPLAY_WRITE:
 864                     ; 119             write_display(frame->data);
 866  0186 1c0005        	addw	x,#5
 867  0189 cd023f        	call	_write_display
 869                     ; 120             break;
 871                     ; 121         default:
 871                     ; 122             // Handle unknown command
 871                     ; 123             break;
 873  018c               L733:
 874                     ; 125 }
 877  018c 85            	popw	x
 878  018d 81            	ret	
 912                     ; 127 void read_button_status(uint8_t button_number) {
 913                     	switch	.text
 914  018e               _read_button_status:
 918                     ; 145 }
 921  018e 81            	ret	
1069                     ; 147 void set_led_state(uint8_t led_number, uint8_t* state) {
1070                     	switch	.text
1071  018f               _set_led_state:
1073  018f 88            	push	a
1074  0190 89            	pushw	x
1075       00000002      OFST:	set	2
1078                     ; 152     switch (led_number) {
1081                     ; 159         default:
1081                     ; 160             return;
1082  0191 4a            	dec	a
1083  0192 2705          	jreq	L753
1084  0194 4a            	dec	a
1085  0195 2705          	jreq	L163
1088  0197 2029          	jra	L754
1089  0199               L753:
1090                     ; 153         case 1:
1090                     ; 154             pin = GPIO_PIN_0; /* ajuste conforme seu hardware (ex: GPIOE, PIN_0) */
1092  0199 4c            	inc	a
1093                     ; 155             break;
1095  019a 2002          	jra	L354
1096  019c               L163:
1097                     ; 156         case 2:
1097                     ; 157             pin = GPIO_PIN_1;
1099  019c a602          	ld	a,#2
1100                     ; 158             break;
1102  019e               L354:
1103  019e 6b02          	ld	(OFST+0,sp),a
1105                     ; 163     s = state ? state[0] : 0;
1107  01a0 1e06          	ldw	x,(OFST+4,sp)
1108  01a2 2703          	jreq	L26
1109  01a4 f6            	ld	a,(x)
1110  01a5 2001          	jra	L46
1111  01a7               L26:
1112  01a7 4f            	clr	a
1113  01a8               L46:
1114  01a8 6b01          	ld	(OFST-1,sp),a
1116                     ; 164     if (s == 1) {
1118  01aa 4a            	dec	a
1119  01ab 260b          	jrne	L554
1120                     ; 165         GPIO_WriteLow(GPIOE, pin); /* LED ON (pull low no seu hardware) */
1122  01ad 7b02          	ld	a,(OFST+0,sp)
1123  01af 88            	push	a
1124  01b0 ae5014        	ldw	x,#20500
1125  01b3 cd0000        	call	_GPIO_WriteLow
1128  01b6 2009          	jp	LC004
1129  01b8               L554:
1130                     ; 167         GPIO_WriteHigh(GPIOE, pin); /* LED OFF */
1132  01b8 7b02          	ld	a,(OFST+0,sp)
1133  01ba 88            	push	a
1134  01bb ae5014        	ldw	x,#20500
1135  01be cd0000        	call	_GPIO_WriteHigh
1137  01c1               LC004:
1138  01c1 84            	pop	a
1139  01c2               L754:
1140                     ; 169 }
1143  01c2 5b03          	addw	sp,#3
1144  01c4 81            	ret	
1236                     ; 171 void blink_led(uint8_t led_number, uint8_t* data) {
1237                     	switch	.text
1238  01c5               _blink_led:
1240  01c5 88            	push	a
1241  01c6 5207          	subw	sp,#7
1242       00000007      OFST:	set	7
1245                     ; 173     uint8_t times = 0;
1247  01c8 0f01          	clr	(OFST-6,sp)
1249                     ; 174     uint8_t delay_val = 0;
1251  01ca 0f05          	clr	(OFST-2,sp)
1253                     ; 177     switch (led_number) {
1256                     ; 184         default:
1256                     ; 185             return;
1257  01cc 4a            	dec	a
1258  01cd 2705          	jreq	L164
1259  01cf 4a            	dec	a
1260  01d0 2705          	jreq	L364
1263  01d2 2068          	jra	L201
1264  01d4               L164:
1265                     ; 178         case 1:
1265                     ; 179             pin = GPIO_PIN_0;
1267  01d4 4c            	inc	a
1268                     ; 180             break;
1270  01d5 2002          	jra	L735
1271  01d7               L364:
1272                     ; 181         case 2:
1272                     ; 182             pin = GPIO_PIN_1;
1274  01d7 a602          	ld	a,#2
1275                     ; 183             break;
1277  01d9               L735:
1278  01d9 6b04          	ld	(OFST-3,sp),a
1280                     ; 188     if (data) {
1282  01db 1e0b          	ldw	x,(OFST+4,sp)
1283  01dd 2707          	jreq	L145
1284                     ; 189         times = data[0];
1286  01df f6            	ld	a,(x)
1287  01e0 6b01          	ld	(OFST-6,sp),a
1289                     ; 190         delay_val = data[1];
1291  01e2 e601          	ld	a,(1,x)
1292  01e4 6b05          	ld	(OFST-2,sp),a
1294  01e6               L145:
1295                     ; 193     for (i = 0; i < times; i++) {
1297  01e6 5f            	clrw	x
1299  01e7 2045          	jra	L745
1300  01e9               L345:
1301                     ; 194         GPIO_WriteLow(GPIOE, pin); /* ON */
1303  01e9 7b04          	ld	a,(OFST-3,sp)
1304  01eb 88            	push	a
1305  01ec ae5014        	ldw	x,#20500
1306  01ef cd0000        	call	_GPIO_WriteLow
1308  01f2 5f            	clrw	x
1309  01f3 84            	pop	a
1310                     ; 195         for(j = 0 ; j < delay_val * 1000 ; j++){
1312  01f4 2003          	jra	L755
1313  01f6               L355:
1317  01f6 1e06          	ldw	x,(OFST-1,sp)
1318  01f8 5c            	incw	x
1319  01f9               L755:
1321  01f9 1f06          	ldw	(OFST-1,sp),x
1325  01fb 5f            	clrw	x
1326  01fc 7b05          	ld	a,(OFST-2,sp)
1327  01fe 97            	ld	xl,a
1328  01ff 90ae03e8      	ldw	y,#1000
1329  0203 cd0000        	call	c_imul
1331  0206 1306          	cpw	x,(OFST-1,sp)
1332  0208 22ec          	jrugt	L355
1333                     ; 198         GPIO_WriteHigh(GPIOE, pin); /* OFF */
1335  020a 7b04          	ld	a,(OFST-3,sp)
1336  020c 88            	push	a
1337  020d ae5014        	ldw	x,#20500
1338  0210 cd0000        	call	_GPIO_WriteHigh
1340  0213 5f            	clrw	x
1341  0214 84            	pop	a
1342                     ; 199         for(j = 0 ; j < delay_val * 1000 ; j++){
1344  0215 2003          	jra	L765
1345  0217               L365:
1349  0217 1e06          	ldw	x,(OFST-1,sp)
1350  0219 5c            	incw	x
1351  021a               L765:
1353  021a 1f06          	ldw	(OFST-1,sp),x
1357  021c 5f            	clrw	x
1358  021d 7b05          	ld	a,(OFST-2,sp)
1359  021f 97            	ld	xl,a
1360  0220 90ae03e8      	ldw	y,#1000
1361  0224 cd0000        	call	c_imul
1363  0227 1306          	cpw	x,(OFST-1,sp)
1364  0229 22ec          	jrugt	L365
1365                     ; 193     for (i = 0; i < times; i++) {
1367  022b 1e02          	ldw	x,(OFST-5,sp)
1368  022d 5c            	incw	x
1369  022e               L745:
1370  022e 1f02          	ldw	(OFST-5,sp),x
1374  0230 5f            	clrw	x
1375  0231 7b01          	ld	a,(OFST-6,sp)
1376  0233 97            	ld	xl,a
1377  0234 bf00          	ldw	c_x,x
1378  0236 1e02          	ldw	x,(OFST-5,sp)
1379  0238 b300          	cpw	x,c_x
1380  023a 25ad          	jrult	L345
1381                     ; 203 }
1382  023c               L201:
1385  023c 5b08          	addw	sp,#8
1386  023e 81            	ret	
1421                     ; 205 void write_display(uint8_t* data) {
1422                     	switch	.text
1423  023f               _write_display:
1427                     ; 209 }
1430  023f 81            	ret	
1475                     	switch	.ubsct
1476  0000               _frame_TX:
1477  0000 000000000000  	ds.b	71
1478                     	xdef	_frame_TX
1479  0047               _frame_RX:
1480  0047 000000000000  	ds.b	71
1481                     	xdef	_frame_RX
1482  008e               _ucs_context:
1483  008e 000000000000  	ds.b	74
1484                     	xdef	_ucs_context
1485                     	xref	_memcpy
1486                     	xdef	_write_display
1487                     	xdef	_blink_led
1488                     	xdef	_set_led_state
1489                     	xdef	_read_button_status
1490                     	xdef	_command_handler
1491                     	xdef	_Process_Frame
1492                     	xdef	_UCS_Listener
1493                     	xdef	_UCS_Init
1494                     	xdef	_Context_Init
1495                     	xref	_UART2_GetFlagStatus
1496                     	xref	_UART2_ReceiveData8
1497                     	xref	_GPIO_WriteLow
1498                     	xref	_GPIO_WriteHigh
1499                     	xref.b	c_x
1519                     	xref	c_imul
1520                     	xref	c_lzmp
1521                     	xref	c_lgsbc
1522                     	end
