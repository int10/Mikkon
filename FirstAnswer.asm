;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Creat by int10@080304
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;use MK6A12P chip
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;it has only two level stack , had better reduce using lcall ,
;;so ,many function only call once at main function , 
;;I perfor macro to function...but pay attention:the macro 
;;must befor main function,or it can't be used...


;配置寄存器设置说明（CONFIG） 
;1-----------FOSC=RC    ;LS,NS,HS,RC    
;2-----------INRC=ON    ;ON,OFF 
;3-----------CPT=ON    ;ON,OFF    
;4-----------WDTE=Enable   ;Enable,Disable 
;5-----------LV=Low Vol Reset ON  ;Low Vol Reset ON,Low Vol Reset OFF 
;6-----------RESET=...input...   ;...input...,...reset... 


;#define USE_CHIP_MK7A11P
#define USE_CHIP_MK6A11P


#include "mk7a11p.inc"

bit_answer_1		equ		PA0
bit_answer_2		equ		PA1
bit_answer_3		equ		PA2
bit_answer_4		equ		PA3
bit_led_a1			equ		PB0
bit_led_a2			equ		PB1
bit_led_a3			equ		PB2
bit_led_a4			equ		PB4



#define test_answer_1 PORTA,bit_answer_1
#define test_answer_2 PORTA,bit_answer_2
#define test_answer_3 PORTA,bit_answer_3
#define test_answer_4 PORTA,bit_answer_4

#define set_led_a1		PORTB,bit_led_a1
#define set_led_a2		PORTB,bit_led_a2
#define set_led_a3		PORTB,bit_led_a3
#define set_led_a4		PORTB,bit_led_a4


#define	iodir_porta		b'11111111'
#define	iodir_portb		b'11101000'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;memery map			;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
a_buf			equ   		0x20   		;acc缓存器 
status_buf		equ   		0x21   		;status缓存器 
temp_buf		equ			0x22
delay_counter	equ			0x23
tm_counter_l 	equ 			0x24			;counter , use to get the time
tm_counter_h 	equ 			0x25
pin_ir_in_status	equ			0x26

custom_8h 		equ 			0x32;f						;custom code  ~custom
custom_8l 		equ 			0x33;f						;;;;;;custom data...
data_8h 		equ 			0x30			;7			;data code		~data
data_8l 			equ 			0x31		;d				;;;;;;data code

decode_mask			equ			0x34
;byte_counter			equ			0x35
ir_status				equ			0x35				;0:no received			1:have received
receive_data			equ			0x36
power_status			equ			0x37			;state of power...0:power off			1:power on
send_data				equ			0x38
bit_counter				equ			0x39
pw_off_counter			equ			0x3a
shut_down_low_couter	equ			0x3b
delay_ms_counter		equ			0x3c



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;some macro
jz macro position
	btsc status,z
	lgoto position
endm

jnz macro position
	btss status,z
	lgoto position
endm

;    *_*!!!...NND  sub instruction  0:have carry      1:no carry.........rl instruction 0:no carry 1:have carry   
;;;;so pay attention:sub instruction   jc means (M)>L then jmp   jnc means (M)<L then jmp
jc macro position
	btsc status,c
	lgoto position
endm

jnc macro position
	btss status,c
	lgoto position
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set main entery
org			0x3ff				;mk7a11p的复位向量地址定义 
lgoto		main				;跳转到主程序入口   

org 			0x0000


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;delay x ms ,x<255
m_delay_ms macro ms
	local delay_ms_loop

	movla ms
	movam delay_ms_counter
delay_ms_loop
	lcall delay_1ms
	decsz delay_ms_counter,m
	lgoto delay_ms_loop
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;init the chip
;init_chip
init_chip macro 
	movla      	iodir_porta
	iodir         	porta 
	clr   		porta 
	clr          	pa_pdm 
	;------------------------------------------------------ 
	;PortB端口方向及状态设定  
	movla        	iodir_portb
	iodir          	portb
	clr   		portb 
	clr          	pb_pod 
	clr          	pb_pdm 

	;;;;;;;;set pull up register
	movla b'11111111'
	movam PB_PUP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;set ir_out pin set stb
	bc set_led_a1
	bc set_led_a2
	bc set_led_a3
	bc set_led_a4

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;init wtd
	movla b'01001111'
	select
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;init some variable
	clr power_status
	clr ir_status
endm
;	ret
	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan key
;key_scan
key_scan macro
	btsc test_answer_1
	lgoto key_scan_answer_1
	btsc test_answer_2
	lgoto key_scan_answer_2
	btsc test_answer_3
	lgoto key_scan_answer_3
	btsc test_answer_4
	lgoto key_scan_answer_4

key_scan_answer_1
	m_delay_ms .80
	btss test_answer_1
	lgoto key_scan_end

	m_delay_ms .200
	m_delay_ms .200
;	m_delay_ms .100

	bs set_led_a1
	lgoto wait_key_release
key_scan_answer_2
	m_delay_ms .80
	btss test_answer_2
	lgoto key_scan_end
	
	m_delay_ms .200
	m_delay_ms .200
;	m_delay_ms .100

	bs set_led_a2
	lgoto wait_key_release
key_scan_answer_3
	m_delay_ms .80
	btss test_answer_3
	lgoto key_scan_end
	
	m_delay_ms .200
	m_delay_ms .200
;	m_delay_ms .100
	
	bs set_led_a3
	lgoto wait_key_release
key_scan_answer_4
	m_delay_ms .80
	btss test_answer_4
	lgoto key_scan_end
	
	m_delay_ms .200
	m_delay_ms .200
;	m_delay_ms .100
	
	bs set_led_a4
	lgoto wait_key_release

wait_key_release
	m_delay_ms .10
	btsc test_answer_1
	lgoto wait_key_release
	btsc test_answer_2
	lgoto wait_key_release
	btsc test_answer_3
	lgoto wait_key_release
	btsc test_answer_4
	lgoto wait_key_release
	m_delay_ms .80
	btsc test_answer_1
	lgoto wait_key_release
	btsc test_answer_2
	lgoto wait_key_release
	btsc test_answer_3
	lgoto wait_key_release
	btsc test_answer_4
	lgoto wait_key_release
key_scan_end
	bc set_led_a1
	bc set_led_a2
	bc set_led_a3
	bc set_led_a4
;	m_delay_ms .200
;	m_delay_ms .200
;	m_delay_ms .100
endm
;	ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 40us
;
delay_40us
	clrwdt
	movla .12
	movam delay_counter
delay_40_us_loop
	decsz delay_counter,m
	lgoto delay_40_us_loop
	clrwdt
delay_40us_end
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 100us	
;
delay_100us
	clrwdt
	movla .25
	movam delay_counter
delay_100_us_loop
	clrwdt
	decsz delay_counter,m
	lgoto delay_100_us_loop
	clrwdt
;	clrwdt
delay_100us_end
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 560us
;
delay_560us
	movla .147
	movam delay_counter	
delay_560us_loop
	clrwdt
	decsz delay_counter,m
	lgoto delay_560us_loop
	clrwdt
	clrwdt
	clrwdt
delay_560us_end
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 1680us
;
delay_1680us
	movla .197
	movam delay_counter	
delay_1680us_loop
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	decsz delay_counter,m
	lgoto delay_1680us_loop
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 1ms
;			
delay_1ms
	movla .211
	movam delay_counter
delay_1ms_loop
	clrwdt
	clrwdt
	decsz delay_counter,m
	lgoto delay_1ms_loop
	clrwdt
	clrwdt
	clrwdt
delay_1ms_end
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;main function     it must write under the macro ,or it can't call the macro
main
	init_chip
main_loop
	clrwdt
	key_scan
	lgoto main_loop
	ret

	
end






