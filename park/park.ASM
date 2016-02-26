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

#define VERSION	0.5

;#define USE_EMLUATOR
#define fun

#define PORTB PB_DAT
#define PORTA PA_DAT
#define PORTC PC_DAT
#define BSR FSR



bit_by_pass						equ PA0
bit_sensor1						equ PA3
bit_sensor2						equ PA2
bit_sensor3						equ PA1
bit_pw_down					equ PA4			;18pin
bit_pw_up						equ PA5			;17pin
bit_slow_down					equ PA7			;15pin

bit_key_down					equ PB3
bit_key_up						equ PB2



#define set_pw_down			PORTA,bit_pw_down
#define set_pw_up				PORTA,bit_pw_up
#define set_slow_down		PORTA,bit_slow_down
#define test_by_pass			PORTA,bit_by_pass
#define test_sensor1			PORTA,bit_sensor1
#define test_sensor2			PORTA,bit_sensor2
#define test_sensor3			PORTA,bit_sensor3
#define test_key_down		PORTB,bit_key_down
#define test_key_up			PORTB,bit_key_up

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;my_status bit define


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
	bc temp_buf,bit_pw_down
	bc temp_buf,bit_pw_up
	bc temp_buf,bit_slow_down
	mov temp_buf,a
	movam PA_DIR
	clr   		PORTA
	;------------------------------------------------------ 
	;PortB端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
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

	clr IRQF
	bs IRQM,INTM
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;slow down
slow_down macro
	bc set_pw_down
	bc set_pw_up
	bs set_slow_down
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200

;	m_delay_ms .200
;	m_delay_ms .200
;	m_delay_ms .100
	bc set_slow_down
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan key
key_scan macro
	btss test_key_down
	lgoto key_scan_down
	btss test_key_up
	lgoto key_scan_up
	lgoto key_scan_end

key_scan_down
	m_delay_ms .80
	btsc test_key_down
	lgoto key_scan_end
	bs set_pw_down
	;;;wait for key release
key_scan_down_release
	clrwdt
	btss test_key_down
	lgoto key_scan_down_release
	m_delay_ms .80
	btss test_key_down
	lgoto key_scan_down_release
	slow_down
	lgoto key_scan_end
	
key_scan_up
	m_delay_ms .80
	btsc test_key_up
	lgoto key_scan_end
	bs set_pw_up
	;;wait for key release
key_scan_up_release
	clrwdt
	btss test_key_up
	lgoto key_scan_up_release
	m_delay_ms .80
	btss test_key_up
	lgoto key_scan_up_release
	slow_down
	lgoto key_scan_end

key_scan_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;pins scan
pins_scan macro

	btsc test_sensor1
	lgoto pin_scan_sensor1_high
	lgoto pin_scan_sensor1_low
pin_scan_sensor1_high
	btss test_sensor2
	lgoto pins_scan_end
	;1h 2h do some thing
	bs set_pw_down
pin_scan_wait_sensor3_high
	clrwdt
	btss test_by_pass				;;if change to by pass , just end this check is ok..
	lgoto pins_scan_slow_down
	btss test_sensor3
	lgoto pin_scan_wait_sensor3_high
	lgoto pins_scan_slow_down

pin_scan_sensor1_low
	btss test_sensor3
	lgoto pins_scan_end
	;1l 3h do something
	bs set_pw_up
pin_scan_wait_sensor2_high
	clrwdt
	btss test_by_pass				;;if change to by pass , just end this check is ok..
	lgoto pins_scan_slow_down
	btss test_sensor2
	lgoto pin_scan_wait_sensor2_high
	lgoto pins_scan_slow_down
pins_scan_slow_down
	slow_down

pins_scan_end
endm


#include "..\intEntry.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;main function     it must write under the macro ,or it can't call the macro
main fun
	init_chip
main_loop
	clrwdt
	btss test_by_pass
	lgoto main_by_pass
	lgoto main_normal
main_by_pass
	key_scan
	lgoto main_loop
main_normal
	pins_scan
	lgoto main_loop
	ret


end


