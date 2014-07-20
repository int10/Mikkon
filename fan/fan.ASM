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



bit_speaker	equ	PA0
bit_key_up		equ PA4
bit_key_standby	equ	PA5
bit_key_down	equ PA6
bit_ir_in		equ	PA7

bit_u1		equ	PB0
bit_u2		equ	PB1
bit_pwm		equ PB2

bit_red_led		equ	PC3
bit_green_led	equ	PC2



#define test_key_down		PORTA,bit_key_down
#define test_key_up			PORTA,bit_key_up
#define test_key_standby	PORTA,bit_key_standby
#define test_ir_in			PORTA,bit_ir_in
#define set_speaker			PORTA,bit_speaker

#define set_u1		PORTB,bit_u1
#define set_u2		PORTB,bit_u2
#define set_pwm		PORTB,bit_pwm

#define set_red_led			PORTC,bit_red_led
#define set_green_led		PORTC,bit_green_led




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;my_status bit define
u1u2_status					equ		0		
u1u2_working				equ		1		;0:idle		1:working
pwm_status					equ		2
ir_recevie_status			equ		3

power_status				equ		4		;0:power off,1:power on

green_led_flash_status		equ		5

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

tm_counter_l			equ			0x49
tm_counter_h			equ			0x4a


custom_8h 		equ 			0x52;f						;custom code  ~custom
custom_8l 		equ 			0x53;f						;;;;;;custom data...
data_8h 		equ 			0x50			;7			;data code		~data
data_8l 			equ 			0x51		;d				;;;;;;data code

value_mask			equ			0x54
receive_data			equ			0x55
send_data				equ			0x56
bit_counter				equ			0x57



int_tm1_10ms_counter		equ			0x58
int_tm1_1s_counter			equ			0x59
int_tm1_1m_counter			equ			0x5a


u1u2_preload_h				equ			0x60
u1u2_preload_l				equ			0x61

u1u2_counter					equ			0x62

pwm_preload_h			equ			0x64
pwm_preload_l			equ			0x65
pwm_counter				equ			0x66
pwm_level				equ			0x67

key_scan_counter		equ			0x68

green_led_flash_counter		equ			0x69

speak_flash_counter			equ			0x6b

system_timeout_counter		equ			0x6c
system_timeout_type			equ			0x6d		;0 disable	30:30min	60:60min	90:90min	120:120min





#include "..\util.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set main entery

org			0x000	
lgoto		main
org			0x004
lgoto		int_entry

org 			0x0010

#include "..\delay.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
turn_on_red_led macro
	bs set_red_led
endm
turn_off_red_led macro
	bc set_red_led
endm
turn_on_green_led macro
	bs my_status,green_led_flash_status
	bs set_green_led
endm
turn_off_green_led macro
	bc my_status,green_led_flash_status
	bc set_green_led
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan the ir			as a sample, use portb 0 as the ir in pin
;ir_scan					;it has only two stack level , so use macro instead function
ir_scan macro
	btsc test_ir_in
	lgoto ir_scan_end
	lcall delay_100us
	btsc test_ir_in
	lgoto ir_scan_end

	;;;;;;low 9ms
	movla .0
	movam tm_counter_l
	movam tm_counter_h
	
l_9ms
	btsc test_ir_in
	lgoto l_9ms_end
	lcall delay_100us
	inc tm_counter_l,m
	sj tm_counter_l,.100,l_9ms
	lgoto ir_scan_end		;it shouldn't come here....overflow
l_9ms_end
	movla .64			;low limit 64
	sub tm_counter_l,a
	jnc ir_scan_end

	dis_int				;disable int first....
	;;;;;;high 4.5ms
	movla .0
	movam tm_counter_l
	movam tm_counter_h
h_4ms
	btss test_ir_in
	lgoto h_4ms_end
	lcall delay_100us
	inc tm_counter_l,m
	;movla .45			;avoid dead circle		high limit 45
	;sub tm_counter_l,a
	;jnc h_4ms
	sj tm_counter_l,.50,h_4ms
	lgoto ir_scan_end		;overflow
h_4ms_end
	;movla .35			;low limit 35
	;sub tm_counter_l,a
	;jnc ir_scan_end
	sj tm_counter_l,.35,ir_scan_end

	;reset the data
	movla .0
	movam custom_8h
	movam custom_8l
	movam data_8h
	movam data_8l
	movam receive_data
	movla b'00000001'
	movam value_mask
;	movla .4
;	movam byte_counter
	movla custom_8l					;bsr point to custom_8l , after receive a byte , dec ,when it's 0x30,means receive done
	movam BSR


	;begin to receive data code	
data_code
	movla .0
	movam tm_counter_l
	movam tm_counter_h
l_056ms							;low 0.56ms
	btsc test_ir_in
	lgoto l_056ms_end
	lcall delay_100us
	inc tm_counter_l,m
	;movla .8					;avoid dead circle  high limit 8
	;sub tm_counter_l,a
	;jnc l_056ms
	sj tm_counter_l,.8,l_056ms
	lgoto ir_scan_end				;overflow
l_056ms_end

;	movla .0
;	movam tm_counter_l
;	movam tm_counter_h
h_1or0							;high voltage,1:2.25-0.56ms  0:1.25-0.56ms
	btss test_ir_in
	lgoto h_1or0_end
	lcall delay_100us
	inc tm_counter_l,m
	;movla .24				;avoid dead circle high limit 24
	;sub tm_counter_l,a
	;jnc h_1or0
	sj tm_counter_l,.24,h_1or0

	lgoto ir_scan_end			;overflow
h_1or0_end
	;receive a bit check the bit is 1 or 0
	;movla .17				;>17 means receive 1 ...<17 means receive 0
	;sub tm_counter_l,a
	;jnc rec_a_bit
	sj tm_counter_l,.17,rec_a_bit

	mov value_mask,a			;receive 1
	ior receive_data,m
	;receive 0 needn't any other operate
rec_a_bit
	;;;   *_*!!!!!     must clear status .c first...
	bc STATUS,C
	rlc value_mask,m
	jc rec_a_byte
	lgoto data_code
rec_a_byte
	movla .1
	movam value_mask

	mov receive_data,a
	movam INDF
	clr receive_data
	
rec_a_byte_end
	mov BSR,a
	xorla data_8h
	jz data_code_end
	dec BSR,m 
	lgoto data_code

	
;	decsz byte_counter,m
;	lgoto data_code


	;;;;;;;;;;;;receive data end
data_code_end
	mov custom_8h,a
	and custom_8l,a
	jnz ir_scan_end
	mov data_8h,a
	and data_8l,a
	jnz ir_scan_end

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;handle
	bs my_status,ir_recevie_status
	
ir_scan_end
	;;;;;clear bsr
	clr BSR
	en_int		;;open int
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
pwm_set_level macro
	local pwm_set_level_0,pwm_set_level_1,pwm_set_level_2,pwm_set_level_3,pwm_set_level_4,pwm_set_level_5,pwm_set_level_6,pwm_set_level_7,pwm_set_level_8,pwm_set_level_9,pwm_set_level_end
	ej pwm_level,0,pwm_set_level_0
	ej pwm_level,1,pwm_set_level_1
	ej pwm_level,2,pwm_set_level_2
	ej pwm_level,3,pwm_set_level_3
	ej pwm_level,4,pwm_set_level_4
	ej pwm_level,5,pwm_set_level_5
	ej pwm_level,6,pwm_set_level_6
	ej pwm_level,7,pwm_set_level_7
	ej pwm_level,8,pwm_set_level_8
	ej pwm_level,9,pwm_set_level_9
	clr pwm_level
pwm_set_level_0
	movla 1
	movam pwm_preload_h
	movla 9
	movam pwm_preload_l
	lgoto pwm_set_level_end
pwm_set_level_1
	movla 2
	movam pwm_preload_h
	movla 8
	movam pwm_preload_l
	lgoto pwm_set_level_end
pwm_set_level_2
	movla 3
	movam pwm_preload_h
	movla 7
	movam pwm_preload_l
	lgoto pwm_set_level_end
pwm_set_level_3
	movla 4
	movam pwm_preload_h
	movla 6
	movam pwm_preload_l
	lgoto pwm_set_level_end
pwm_set_level_4
	movla 5
	movam pwm_preload_h
	movla 5
	movam pwm_preload_l
	lgoto pwm_set_level_end
pwm_set_level_5
	movla 6
	movam pwm_preload_h
	movla 4
	movam pwm_preload_l
	lgoto pwm_set_level_end
pwm_set_level_6
	movla 7
	movam pwm_preload_h
	movla 3
	movam pwm_preload_l
	lgoto pwm_set_level_end
pwm_set_level_7
	movla 8
	movam pwm_preload_h
	movla 2
	movam pwm_preload_l
	lgoto pwm_set_level_end
pwm_set_level_8
	movla 9
	movam pwm_preload_h
	movla 1
	movam pwm_preload_l
	lgoto pwm_set_level_end
pwm_set_level_9
	bs set_pwm
pwm_set_level_end	
	mov pwm_preload_h,a
	movam pwm_counter
	bs my_status,pwm_status
	bs set_pwm
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
pwm_up_level macro
	ej pwm_level,.9,pwm_up_level_end
	inc pwm_level,m
	pwm_set_level
pwm_up_level_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
pwm_down_level macro
	ej pwm_level,0,pwm_down_level_end
	dec pwm_level,m
	pwm_set_level
pwm_down_level_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
switch_u1u2_working_status macro
	local switch_u1u2_working_status_turn_off,switch_u1u2_working_status_end
	btsc my_status,u1u2_working
	lgoto switch_u1u2_working_status_turn_off
	;;turn on
	turn_on_u1u2
	lgoto switch_u1u2_working_status_end
switch_u1u2_working_status_turn_off
	turn_off_u1u2
switch_u1u2_working_status_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
turn_on_u1u2 macro
	bs my_status,u1u2_working
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
turn_off_u1u2 macro
	bc my_status,u1u2_working
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
switch_power_status macro
	local switch_power_status_turn_off,switch_power_status_end
	btsc my_status,power_status
	lgoto switch_power_status_turn_off
	power_on_system
	lgoto switch_power_status_end
switch_power_status_turn_off
	power_off_system
switch_power_status_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
system_set_timeout macro L_type
	ej system_timeout_type,L_type,system_set_timeout_clear
	movla L_type
	movam system_timeout_type
	movam system_timeout_counter
	lgoto system_set_timeout_end
system_set_timeout_clear
	clr system_timeout_type
system_set_timeout_end	
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
power_on_system macro
	bs my_status,power_status
	turn_off_red_led
	turn_on_green_led
	movla .0
	movam pwm_level
	pwm_set_level
	turn_off_u1u2
	movla .50
	movam u1u2_preload_h
	movam u1u2_preload_l
	movam u1u2_counter
	bs my_status,u1u2_status
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
power_off_system macro
	bc my_status,power_status
	turn_on_red_led
	turn_off_green_led
	turn_off_u1u2
	clr system_timeout_type
	bc set_u1
	bc set_u2
	bc set_pwm
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
green_led_flash macro L_s
	turn_on_green_led
	movla L_s
	movam green_led_flash_counter
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
speak_flash macro L_s
	bs set_speaker
	movla L_s
	movam speak_flash_counter
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;init the chip
init_chip macro
	;PortA端口方向及状态设定            
	movla      	0xff
	movam temp_buf
	bc temp_buf,bit_speaker
	mov temp_buf,a
	movam PA_DIR
	clr   		PORTA
	;------------------------------------------------------ 
	;PortB端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
	bc temp_buf,bit_u1
	bc temp_buf,bit_u2
	bc temp_buf,bit_pwm
	mov temp_buf,a
	movam PB_DIR
	clr   		PORTB
	;------------------------------------------------------

	;PortC端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
	bc temp_buf,bit_red_led
	bc temp_buf,bit_green_led
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
	movla .50
	movam int_tm1_10ms_counter
	movla .100
	movam int_tm1_1s_counter
	movla .60
	movam int_tm1_1m_counter

	

	power_off_system

	
	clr IRQF
	bs IRQM,INTM
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
key_scan_key_down macro
	btsc test_key_down
	lgoto key_scan_key_down_end
	m_delay_ms .80
	btsc test_key_down
	lgoto key_scan_key_down_end
	pwm_down_level
	green_led_flash .2
	speak_flash .2
key_scan_key_down_release
	btss test_key_down
	lgoto key_scan_key_down_release
	m_delay_ms .80
	btss test_key_down
	lgoto key_scan_key_down_release
key_scan_key_down_end
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
key_scan_key_up macro
	btsc test_key_up
	lgoto key_scan_key_up_end
	m_delay_ms .80
	btsc test_key_up
	lgoto key_scan_key_up_end
	pwm_up_level
	green_led_flash .2
	speak_flash .2
key_scan_key_up_release
	btss test_key_up
	lgoto key_scan_key_up_release
	m_delay_ms .80
	btss test_key_up
	lgoto key_scan_key_up_release
key_scan_key_up_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
key_scan_key_standby macro
	btsc test_key_standby
	lgoto key_scan_key_standby_end
	m_delay_ms .80
	btsc test_key_standby
	lgoto key_scan_key_standby_end
	clr key_scan_counter
key_scan_key_standby_long_press_check
	inc key_scan_counter,m
	bj key_scan_counter,.15,key_scan_key_standby_long_pressed
	m_delay_ms .80
	btss test_key_standby
	lgoto key_scan_key_standby_long_press_check
	m_delay_ms .80
	btss test_key_standby
	lgoto key_scan_key_standby_long_press_check
	;;key released ,not long press
	switch_u1u2_working_status
	green_led_flash .2
	speak_flash .2
	lgoto key_scan_key_standby_end

key_scan_key_standby_long_pressed
	switch_power_status
key_scan_key_standby_release
	btss test_key_standby
	lgoto key_scan_key_standby_release
	m_delay_ms .80
	btss test_key_standby
	lgoto key_scan_key_standby_release
key_scan_key_standby_end
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
key_scan macro
	key_scan_key_down
	key_scan_key_up
	key_scan_key_standby
key_scan_end
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
ir_handle macro
	btss my_status,ir_recevie_status
	lgoto ir_handle_end
	bc my_status,ir_recevie_status
	
ir_handle_end
endm




#include "..\tmDrv.asm"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;tm1 int
int_tm1 macro

	bc IRQF,TM1F
	;;;add the code below
	btss my_status,power_status
	lgoto int_tm1_end
	
	ej pwm_level,9,int_tm1_pwm_end
	dec pwm_counter,m
	jnz int_tm1_pwm_end
	;;pwm time out
	btsc my_status,pwm_status
	lgoto int_tm1_pwm_h
	bs my_status,pwm_status
	bs set_pwm
	mov pwm_preload_h,a
	movam pwm_counter
	lgoto int_tm1_pwm_end
int_tm1_pwm_h
	bc my_status,pwm_status
	bc set_pwm
	mov pwm_preload_l,a
	movam pwm_counter
	lgoto int_tm1_pwm_end
int_tm1_pwm_end

int_tm1_u1u2
	btss my_status,u1u2_working
	lgoto int_tm1_u1u2_end
	dec u1u2_counter,m
	jnz int_tm1_u1u2_end
	;;;u1u2 time out
	btsc my_status,u1u2_status
	lgoto int_tm1_u1u2_h
	bs my_status,u1u2_status
	bs set_u1
	bc set_u2
	mov u1u2_preload_h,a
	movam u1u2_counter
	lgoto int_tm1_u1u2_end
int_tm1_u1u2_h
	bc my_status,u1u2_status
	bc set_u1
	bs set_u2
	mov u1u2_preload_l,a
	movam u1u2_counter
int_tm1_u1u2_end


	;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;10ms interrupt
	dec int_tm1_10ms_counter,m
	jnz int_tm1_end
	movla .50
	movam int_tm1_10ms_counter

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;1s interrupt
	dec int_tm1_1s_counter,m
	jnz int_tm1_end
	movla .100
	movam int_tm1_1s_counter
	
int_tm1_green_flash
	ej green_led_flash_counter,0,int_tm1_green_flash_off
	dec green_led_flash_counter,m
	btsc my_status,green_led_flash_status
	lgoto int_tm1_green_flash_off
	turn_on_green_led
	lgoto int_tm1_green_flash_end

int_tm1_green_flash_off
	
	turn_off_green_led
int_tm1_green_flash_end


int_tm1_speaker_flash
	ej speak_flash_counter,0,int_tm1_speaker_flash_end
	dec speak_flash_counter,m
	jnz int_tm1_speaker_flash_end
	bc set_speaker
int_tm1_speaker_flash_end


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;1min interrupt
	dec int_tm1_1m_counter,m
	jnz int_tm1_end
	movla .60
	movam int_tm1_1m_counter

	ej system_timeout_type,0,int_tm1_end
	dec system_timeout_counter,m
	jnz int_tm1_end
	power_off_system

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
	start_tm1 b'01100100',0x32,0x00			;TM1时钟源内部RC时钟,预分频1:16,溢出周期200us,IC's clock is faster tha emulate...fix it 
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
	ir_scan
	ir_handle
	lgoto main_loop
	
	ret



end


