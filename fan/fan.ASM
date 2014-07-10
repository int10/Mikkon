;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;creat by int10@100618
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;use mk7a25p	

#include  "mk7a25p.inc"  ;编译该文档需包含"mk7a21p.inc"文件



;配置寄存器设置说明（CONFIG） 
;1-----------FOSC=RC    ;LS,NS,HS,RC    
;2-----------INRC=ON    ;ON,OFF 
;3-----------CPT=ON    ;ON,OFF    
;4-----------WDTE=Enable   ;Enable,Disable 
;5-----------LV=Low Vol Reset ON  ;Low Vol Reset ON,Low Vol Reset OFF 
;6-----------RESET=...input...   ;...input...,...reset... 

;#define USE_EMLUATOR
#define fun


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;const for tm1,about 15 minutes to overflow
;;#define const_timeout_tm1_15min_h			0x1c
;;#define const_timeout_tm1_15min_l			0x20



#define PORTB PB_DAT
#define PORTA PA_DAT
#define PORTC PC_DAT
#define BSR FSR



bit_u1		equ	PB0
bit_u2		equ	PB1

bit_key_down equ PC2
bit_key_up	equ PC3



#define set_u1		PORTB,bit_u1
#define set_u2		PORTB,bit_u2

#define test_key_down		PORTC,bit_key_down
#define test_key_up		PORTC,bit_key_up


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;my_status bit define
tm1_overflow				equ 		0
test_mode_status			equ		1		;0:normal mode ,1:test mode

u1_status					equ		2
u2_status					equ		3

rx_int_status				equ		7


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;memery map			;;;;  0x40~0xbf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

a_buf					equ   		0x40   		;acc缓存器 
status_buf				equ   		0x41   		;status缓存器 
temp_buf				equ			0x42
delay_counter			equ			0x43
delay_ms_counter		equ			0x44
tm1_counter_h			equ			0x45
tm1_counter_l			equ			0x46

my_status				equ			0x48		;;;


audio_max_value		equ			0x50
audio_min_value		equ			0x51

adc_time_out_counter	equ			0x52

adc_value_h				equ			0x53
adc_value_l				equ			0x54
adc_merged_value		equ			0x55

audio_detect_cur_channel	equ		0x56		;0:Right     1:Left
audio_detect_counter		equ		0x57
adc_compare_resut 		equ			0x58

u1_preload_h				equ			0x60
u1_preload_l				equ			0x61
u2_preload_h				equ			0x62
u2_preload_l				equ			0x63

u1_counter					equ			0x64
u2_counter					equ			0x65

u1_level			equ				0x66
u2_level			equ				0x67







#include "..\util.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set main entery

org			0x000	
lgoto		main
org			0x004
lgoto		int_entry

org 			0x0010

#include "..\delay.asm"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;init the chip
init_chip macro

	;PortA端口方向及状态设定            
	movla      	0xff
	movam temp_buf
	mov temp_buf,a
	movam PA_DIR
	clr   		PORTA
	;------------------------------------------------------ 
	;PortB端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
	bc temp_buf,bit_u1
	bc temp_buf,bit_u2
	mov temp_buf,a
	movam PB_DIR
	clr   		PORTB
	;------------------------------------------------------

	;PortC端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
	mov temp_buf,a
	movam PC_DIR
	clr   		PORTC

	;;;;;;;;set pull up register
	movla b'11111111'
	movam temp_buf
	mov temp_buf,a
	movam PA_PLU
	movam PB_PLU
	movam PC_PLU
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;personal setting

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;init wtd
	movla b'10000111'
	movam WDT_CTL

	;;;;;;;;;;;;;;;;;;;;;;;;
	clr my_status
	clr u1_level
	clr u2_level

	clr IRQF
	bs IRQM,INTM
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
u1_set_level macro
	local u1_set_level_0,u1_set_level_1,u1_set_level_2,u1_set_level_3,u1_set_level_4,u1_set_level_5,u1_set_level_6,u1_set_level_7,u1_set_level_8,u1_set_level_9,u1_set_level_end
	ej u1_level,0,u1_set_level_0
	ej u1_level,1,u1_set_level_1
	ej u1_level,2,u1_set_level_2
	ej u1_level,3,u1_set_level_3
	ej u1_level,4,u1_set_level_4
	ej u1_level,5,u1_set_level_5
	ej u1_level,6,u1_set_level_6
	ej u1_level,7,u1_set_level_7
	ej u1_level,8,u1_set_level_8
	ej u1_level,9,u1_set_level_9
	clr u1_level
u1_set_level_0
	bc set_u1
	lgoto u1_set_level_end
u1_set_level_1
	movla 1
	movam u1_preload_h
	movla 9
	movam u1_preload_l
	lgoto u1_set_level_end
u1_set_level_2
	movla 2
	movam u1_preload_h
	movla 8
	movam u1_preload_l
	lgoto u1_set_level_end
u1_set_level_3
	movla 3
	movam u1_preload_h
	movla 7
	movam u1_preload_l
	lgoto u1_set_level_end
u1_set_level_4
	movla 4
	movam u1_preload_h
	movla 6
	movam u1_preload_l
	lgoto u1_set_level_end
u1_set_level_5
	movla 5
	movam u1_preload_h
	movla 5
	movam u1_preload_l
	lgoto u1_set_level_end
u1_set_level_6
	movla 6
	movam u1_preload_h
	movla 4
	movam u1_preload_l
	lgoto u1_set_level_end
u1_set_level_7
	movla 7
	movam u1_preload_h
	movla 3
	movam u1_preload_l
	lgoto u1_set_level_end
u1_set_level_8
	movla 8
	movam u1_preload_h
	movla 2
	movam u1_preload_l
	lgoto u1_set_level_end
u1_set_level_9
	bs set_u1
u1_set_level_end	

endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
u1_up_level macro
	ej u1_level,.9,u1_up_level_end
	bj u1_level,.9,u1_up_level_end
	inc u1_level,m
	u1_set_level
u1_up_level_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
u1_down_level macro
	ej u1_level,0,u1_down_level_end
	dec u1_level,m
	u1_set_level
u1_down_level_end
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
u2_set_level macro
	local u2_set_level_0,u2_set_level_1,u2_set_level_2,u2_set_level_3,u2_set_level_4,u2_set_level_5,u2_set_level_6,u2_set_level_7,u2_set_level_8,u2_set_level_9,u2_set_level_end
	ej u2_level,0,u2_set_level_0
	ej u2_level,1,u2_set_level_1
	ej u2_level,2,u2_set_level_2
	ej u2_level,3,u2_set_level_3
	ej u2_level,4,u2_set_level_4
	ej u2_level,5,u2_set_level_5
	ej u2_level,6,u2_set_level_6
	ej u2_level,7,u2_set_level_7
	ej u2_level,8,u2_set_level_8
	ej u2_level,9,u2_set_level_9
	clr u2_level
u2_set_level_0
	bc set_u2
	lgoto u2_set_level_end
u2_set_level_1
	movla 1
	movam u2_preload_h
	movla 9
	movam u2_preload_l
	lgoto u2_set_level_end
u2_set_level_2
	movla 2
	movam u2_preload_h
	movla 8
	movam u2_preload_l
	lgoto u2_set_level_end
u2_set_level_3
	movla 3
	movam u2_preload_h
	movla 7
	movam u2_preload_l
	lgoto u2_set_level_end
u2_set_level_4
	movla 4
	movam u2_preload_h
	movla 6
	movam u2_preload_l
	lgoto u2_set_level_end
u2_set_level_5
	movla 5
	movam u2_preload_h
	movla 5
	movam u2_preload_l
	lgoto u2_set_level_end
u2_set_level_6
	movla 6
	movam u2_preload_h
	movla 4
	movam u2_preload_l
	lgoto u2_set_level_end
u2_set_level_7
	movla 7
	movam u2_preload_h
	movla 3
	movam u2_preload_l
	lgoto u2_set_level_end
u2_set_level_8
	movla 8
	movam u2_preload_h
	movla 2
	movam u2_preload_l
	lgoto u2_set_level_end
u2_set_level_9
	bs set_u2
u2_set_level_end	

endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
u2_up_level macro
	ej u2_level,.9,u2_up_level_end
	bj u2_level,.9,u2_up_level_end
	inc u2_level,m
	u2_set_level
u2_up_level_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
u2_down_level macro
	ej u2_level,0,u2_down_level_end
	dec u2_level,m
	u2_set_level
u2_down_level_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
key_scan macro
	btsc test_key_down
	lgoto key_scan_check_down_end
	m_delay_ms .80
	btsc test_key_down
	lgoto key_scan_check_down_end
	u1_down_level
	u2_down_level
	lgoto key_scan_check_key_release
key_scan_check_down_end
	btsc test_key_up
	lgoto key_scan_end
	m_delay_ms .80
	btsc test_key_up
	lgoto key_scan_end
	u1_up_level
	u2_up_level
key_scan_check_key_release
	btss test_key_down
	lgoto key_scan_check_key_release
	btss test_key_up
	lgoto key_scan_check_key_release
	m_delay_ms .80
	btss test_key_down
	lgoto key_scan_check_key_release
	btss test_key_up
	lgoto key_scan_check_key_release
key_scan_end
endm



#include "..\tmDrv.asm"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;tm1 int
int_tm1 macro

	bc IRQF,TM1F
	;;;add the code below
	ej u1_level,0,int_tm1_u1_end
	ej u1_level,9,int_tm1_u1_end
	dec u1_counter,m
	jnz int_tm1_u1_end
	;;u1 time out
	btsc my_status,u1_status
	lgoto int_tm1_u1_h
	bs my_status,u1_status
	mov u1_preload_h,a
	movam u1_counter
	lgoto int_tm1_u1_end
int_tm1_u1_h
	bc my_status,u1_status
	mov u1_preload_l,a
	movam u1_counter
	lgoto int_tm1_u1_end
int_tm1_u1_end


	ej u2_level,0,int_tm1_end
	ej u2_level,9,int_tm1_end
	dec u2_counter,m
	jnz int_tm1_end
	;;u2 time out
	btsc my_status,u2_status
	lgoto int_tm1_u2_h
	bs my_status,u2_status
	mov u2_preload_h,a
	movam u2_counter
	lgoto int_tm1_end
int_tm1_u2_h
	bc my_status,u2_status
	mov u2_preload_l,a
	movam u2_counter
;	lgoto int_tm1_end
int_tm1_end
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;pa int
int_pa macro
	bc IRQF,PAF
	;test int from pa0 or pa1
	;btss test_rx
	lgoto int_pa_0
int_pa_1
	nop
	lgoto int_pa_end
int_pa_0
	nop
	bs my_status,rx_int_status
int_pa_end

endm



#include "..\intEntry.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;main function     it must write under the macro ,or it can't call the macro
main fun
	init_chip
	start_tm1 b'01100100',0x19,0x00			;TM1时钟源内部RC时钟,预分频1:16,溢出周期100us,IC's clock is faster tha emulate...fix it 
	;start_tm1 b'01100101',0x0d,0x3f
	
main_loop
	clrwdt
;	m_delay_ms .10
;	bc set_u1
;	bs set_u2
;	m_delay_ms .10
;	bs set_u1
;	bc set_u2
	key_scan
	
	lgoto main_loop
	
	ret



end


