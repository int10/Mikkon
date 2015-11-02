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

#define PORTB PB_DAT
#define PORTA PA_DAT
#define PORTC PC_DAT
#define BSR FSR



bit_light_group_1				equ	PB1
bit_light_group_2				equ	PC2
bit_light							equ	PC3
bit_key_scan					equ	PB2


#define set_light_group_1		PORTB,bit_light_group_1
#define set_light_group_2		PORTC,bit_light_group_2
#define set_light					PORTC,bit_light
#define test_key_scan			PORTB,bit_key_scan


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;my_status bit define
pw_status					equ 		0		;0:power off 1:power on
work_status					equ		1		;0: light on  1:group light on

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
key_scan_long_count	equ			0x49



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
	bc temp_buf,bit_light_group_1
	mov temp_buf,a
	movam PB_DIR
	clr   		PORTB
	;------------------------------------------------------

	;PortC端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
	bc temp_buf,bit_light
	bc temp_buf,bit_light_group_2
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;repaint light
repaint_light macro
	local repain_light_work_status0,repaint_light_off,repaint_light_end
	local repaint_light_off,repaint_light_end
	btss my_status,pw_status
	lgoto repaint_light_off

	btss my_status,work_status
	lgoto repain_light_work_status0
	;status 1 ,light off ,group on
	bc set_light
	bs set_light_group_1
	bs set_light_group_2
	
	lgoto repaint_light_end
repain_light_work_status0
	;status 0 , light on , group off
	bs set_light
	bc set_light_group_1
	bc set_light_group_2
	lgoto repaint_light_end

repaint_light_off
	bc set_light
	bc set_light_group_1
	bc set_light_group_2
repaint_light_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;power on
pw_on macro
	bs my_status,pw_status
	bc my_status,work_status
	repaint_light
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;power off
pw_off macro
	bc my_status,pw_status
	repaint_light
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;switch pw
switch_pw macro
	btss my_status,pw_status
	lgoto switch_pw_on
	pw_off
	lgoto switch_pw_end
switch_pw_on
	pw_on
switch_pw_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;switch work status
switch_work_status macro
	btss my_status,work_status
	lgoto switch_work_status_1
	bc my_status,work_status
	lgoto switch_work_status_end
switch_work_status_1
	bs my_status,work_status
switch_work_status_end
	repaint_light
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;key short press handle
key_handle macro
	btss my_status,pw_status
	lgoto key_handle_pw_on
	switch_work_status
	lgoto key_handle_end
key_handle_pw_on
	pw_on
key_handle_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan key
key_scan macro
	btsc test_key_scan
	lgoto key_scan_end
	m_delay_ms .80
	btsc test_key_scan
	lgoto key_scan_end

	key_handle

	movla .25
	movam key_scan_long_count	
	
key_scan_long_loop
	m_delay_ms .100
	dec key_scan_long_count,m
	ej key_scan_long_count,0,key_scan_long_press
	
	
	btss test_key_scan
	lgoto key_scan_long_loop
	m_delay_ms .80
	btss test_key_scan
	lgoto key_scan_long_loop
	

;key_scan_not_long_press
;	key_handle
	lgoto key_scan_end


key_scan_long_press
	pw_off
key_scan_wait_release
	btss test_key_scan
	lgoto key_scan_wait_release
	m_delay_ms .100
	btss test_key_scan
	lgoto key_scan_wait_release
key_scan_end
endm



#include "..\intEntry.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;main function     it must write under the macro ,or it can't call the macro
main fun
	init_chip
	pw_on
main_loop
	clrwdt
	key_scan
	lgoto main_loop
	ret


end


