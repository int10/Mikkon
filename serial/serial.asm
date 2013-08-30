;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Creat by int10@080304
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;use MK7A11P chip
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;it has only two level stack , had better reduce using lcall ,
;;so ,many function only call once at main function , 
;;I perfor macro to function...but pay attention:the macro 
;;must befor main function,or it can't be used...


;ps ...the speaker alarming flow is : beep 100ms , silence about 1s...for I want to send ir during it's silence , I disable int before I send ir ,and after I send ir 16 times (about 1S)
;enable int and reset tm0(for beep 100ms) ,  and after send ir 160 times(about 10S) , send ir is no longer needed....then silence time will be handled by tm0 ...

;#include "mk7a11p.inc"

;配置寄存器设置说明（CONFIG） 
;1-----------FOSC=RC    ;LS,NS,HS,RC    
;2-----------INRC=ON    ;ON,OFF 
;3-----------CPT=ON    ;ON,OFF    
;4-----------WDTE=Enable   ;Enable,Disable 
;5-----------LV=Low Vol Reset ON  ;Low Vol Reset ON,Low Vol Reset OFF 
;6-----------RESET=...input...   ;...input...,...reset... 

#define USE_CHIP_MK7A11P

ifdef USE_CHIP_MK7A11P
#include "mk7a11p.inc"			;;;

endif
ifdef USE_CHIP_MK7A21P
#include "mk7a21p.inc"
endif


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;project
#define ALARM_ANNUNCIATOR


#define custom_code				0x56
#define normal_alarm_id			0x00
#define key_stop					0xfe
#define key_idle_mode				0xfd
#define key_working_mode			0xfc
#define id_danger_level				0x06


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;feature
#define HAVE_SLEEP_MODE				;so strange..after the chip go into sleep mode ,watch dog still running,and then overlow,reset following..so had better pay attention
									;at the program flow....

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;delay const
ifdef USE_CHIP_MK7A11P
#define const_delay_40us		.9
#define const_delay_100us		.24
#define const_delay_560us		.55
#define const_delay_1680us		.83
#define const_delay_1ms		.99
else
#define const_delay_40us		.19
#define const_delay_100us		.49
#define const_delay_560us		.111
#define const_delay_1680us		.167
#define const_delay_1ms		.199
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bit_tx 		equ 		PA2
bit_rx 		equ		PA1
bit_pwk		equ		PA0
bit_ir_out	equ		PB7
bit_ir_in		equ		PB5
bit_sensor	equ		PB3
bit_low_pw	equ		PB2
bit_alarm	equ		PB6
bit_ir_power	equ		PB4

#define set_tx PORTA,bit_tx
#define test_rx PORTA,bit_rx
#define set_ir_out	PORTB,bit_ir_out
#define test_ir_in		PORTB,bit_ir_in
#define test_sensor	PORTB,bit_sensor
#define test_low_pw	PORTB,bit_low_pw
#define set_alarm	PORTB,bit_alarm
#define set_pwk		PORTA,bit_pwk
#define set_ir_power	PORTB,bit_ir_power


;alarm_status
alarm_pin_status		equ	0
alarm_on_off			equ	1
alarm_sensor			equ	2
alarm_ir				equ	3
alarm_low_pw			equ	4
alarm_silent				equ	5
alarm_enable			equ	7

;my_status
ir_recevie_status		equ	1
ir_need_send			equ	2
ir_can_sleep			equ	3
sys_work_status			equ	4		;0:working , 1:idle


alarm_silent_const		equ	.40
alarm_alarming_const	equ	.4
alarm_send_ir_period	equ	.20

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
irqm_buf		equ			0x27
alarm_counter1	equ			0x28
alarm_counter2	equ			0x29
alarm_counter3	equ			0x2a
int_temp_buf	equ			0x2b
loop_counter	equ			0x2c
loop_counter1	equ			0x2d
send_id_counter	equ			0x2e



custom_8h 		equ 			0x32;f						;custom code  ~custom
custom_8l 		equ 			0x33;f						;;;;;;custom data...
data_8h 		equ 			0x30			;7			;data code		~data
data_8l 			equ 			0x31		;d				;;;;;;data code

send_data				equ			0x34
receive_data			equ			0x35
bit_counter				equ			0x36
delay_ms_counter		equ			0x37
decode_mask			equ			0x38
ir_send_data			equ			0x39
ir_send_38Khz_counter	equ			0x3a
my_status				equ			0x3b				;bit0:whether ir received a code...0:no received	1:received.....bit1:whether ir need send a code ,
														;bit 2:whether can send ir
alarm_status			equ			0x3c					;bit 0:status of pin alarm ...bit 1:status of alarm,0means no alarm ,1means alarming
														;bit 2~4 is alarm type ....bit2:sensor..bit3:ir..bit 4 low pw.....bit 5:whether alarming or being silent...bit 7is alarm enable
sensor_id				equ			0x3d
ir_send_counter			equ			0x3e


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;some macro
ifdef USE_CHIP_MK7A11P				;mk7a21p have jz jc already
jz macro position
	btsc STATUS,Z
	lgoto position
endm
;    *_*!!!...NND  sub instruction  0:have carry      1:no carry.........rl instruction 0:no carry 1:have carry   
;;;;so pay attention:sub instruction   jc means (M)>L then jmp   jnc means (M)<L then jmp
jc macro position
	btsc STATUS,C
	lgoto position
endm
endif ;USE_CHIP_MK7A11P

jnz macro position
	btss STATUS,Z
	lgoto position
endm


jnc macro position
	btss STATUS,C
 	lgoto position
endm

;;for key word rr&rl have different between 11p&21p , so use it to replace rr&rl.....and in fact ,rr M,m have no use,after compile ,instruction change to rr M,a
ifdef USE_CHIP_MK7A11P
rrmc macro M
	rr M,a
	movam M
endm
rlmc macro M
	rl M,a
	movam M
endm
endif
ifdef USE_CHIP_MK7A21P
;rrmc macro M
;	rrc M,a
;	movam M
;endm
;rlmc macro M
;	rlc M,a
;	movam M
;endm
endif



;if M>L then jump to position		M:memory data			L:literal
bj macro M,L,position
	movla L
	sub M,a
	jc position
endm

;if M<L then jump to position		M:memory data			L:literal
sj macro M,L,position
	movla L
	sub M,a
	jnc position
endm

;if M==L then jump to position		M:memory data			L:literal
ej macro M,L,position
	movla L
	xor M,a
	jz position
endm

;if M!=L then jump to position		M:memory data			L:literal
enj macro M,L,position
	movla L
	xor M,a
	jnz position
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set main entery
ifdef USE_CHIP_MK7A11P
org			0x3fe
lgoto		int_entry
org			0x3ff				;mk7a11p的复位向量地址定义 
lgoto		main				;跳转到主程序入口   
else		;USE_CHIP_MK7A11P
org			0x000				;mk7a21p的复位向量地址定义 
lgoto		main
endif	;USE_CHIP_MK7A11P

org 			0x0010

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
;;tm0 int
int_tm0 macro

	bc irqf,tm0f
	;;;add the code below

	btss alarm_status,alarm_on_off
	lgoto int_set_pin_end
	btsc alarm_status,alarm_silent
	lgoto int_set_pin_end
	btsc alarm_status,alarm_pin_status
	lgoto alarm_2_low
	bs alarm_status,alarm_pin_status

	bs set_alarm

	lgoto int_set_pin_end
alarm_2_low
	bc alarm_status,alarm_pin_status
	bc set_alarm
int_set_pin_end
	dec alarm_counter1,m
	jnz int_tm0_end
	;mov alarm_counter1,.200
	movla .200
	movam alarm_counter1
	dec alarm_counter2,m
	jnz int_tm0_end
	;;;;after 4000times int ,if tm0 rate is 128,it's about 0.5s..,change the status of alarm_status

	clr int_temp_buf
	bs int_temp_buf,alarm_silent
	mov int_temp_buf,a
	xor alarm_status,m
	;;;had better pull down alarm pin
	bc alarm_status,alarm_pin_status
	bc set_alarm
	
	;mov alarm_counter2,.20
	;movla .40
	btsc alarm_status,alarm_silent
	lgoto alarm_counter2_restore_silent_const
	movla alarm_alarming_const
	movam alarm_counter2
	lgoto alarm_counter2_restore_end
alarm_counter2_restore_silent_const
	movla alarm_silent_const
	movam alarm_counter2
alarm_counter2_restore_end

	;;if it's alarming ,after 10s ,stop alarm ...
;	dec alarm_counter3,m
;	jnz int_tm0_end
;	movla alarm_send_ir_period
;	movam alarm_counter3
;	btss alarm_status,alarm_sensor
;	lgoto int_tm0_end	
;	bs my_status,ir_need_send
;	bs my_status,sys_can_sleep
	
;	btss my_status,ir_need_send
;	lgoto int_tm0_end
;	bc my_status,ir_need_send
	
int_tm0_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;pb0 int
int_p0 macro
	bc IRQF,PB0F
	;;add the code below
	
int_p0_end
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;int function
int_entry
	;;enter int ,save the register..
	movam a_buf 
	swap status,a 
	movam status_buf 
	btsc irqf,tm0f  	;test int type
	lgoto int_tm0_entry  	;switch to right type int
	btsc IRQF,PB0F
	lgoto int_pb0_entry
int_tm0_entry
	int_tm0
	lgoto int_entry_end
int_pb0_entry
	int_p0
	lgoto int_entry_end
int_entry_end
	;quit int ,restore the register
	swap   		status_buf,a 
	movam  		status 
	swap   		a_buf,m
	swap   		a_buf,a	
	reti


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;enter wake up mode
enter_wake_up macro
	bs set_ir_power


	clr loop_counter
	clr loop_counter1

	;;init tm0 ,after 0.5ms, enter sleep mode
	;;init variable
;	clr IRQM
;	movla .200
;	movam alarm_counter1
;	movla alarm_alarming_const
;	movam alarm_counter2
;	movla alarm_send_ir_period
;	movam alarm_counter3

;	movla b'11000110'
;	select
;	movla .1
;	movam TMR0		;1*128= 128us
	;enable tmr0 int
;	movla b'10000001' 
;	movam irqm
;	clr irqf
	
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;init the chip
init_chip macro

ifdef ALARM_ANNUNCIATOR
	;PortA端口方向及状态设定            
	movla      	b'00000111' 
	movam temp_buf
	mov temp_buf,a
	iodir         	PORTA
	clr   		PORTA

;	clr          	PA_PDM

	;------------------------------------------------------ 
	;PortB端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
	bc temp_buf,bit_ir_out
	bc temp_buf,bit_alarm
	bc temp_buf,bit_ir_power
	mov temp_buf,a
	iodir          	PORTB
	clr   		PORTB
	clr          	PB_POD

;	clr          	PB_PDM

	;;Porta pull down register
	movla b'00001111'
	movam PA_PDM
;	;;;;;;;;set pull up register
	movla b'11111100'
	movam temp_buf
	mov temp_buf,a
	movam PB_PUP
	movla b'00000011'
	movam PB_PDM
endif

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;init wtd
	movla b'01001111'
	select

	btsc status,to 
	lgoto ram_init	;not wake up from wdt ..
	btsc status,pd 
	lgoto ram_init	;not wake up from wdt...
	lgoto wake_up_from_wdt		;wake up from wdt...
	

	;;;;;;;;;;;;;;;;;;;;;;;
	;;init variable
ram_init
	clr alarm_status
	clr my_status

	mov PORTA,a
	movam a_buf
	movla b'00001111'
	and a_buf,m
	mov PORTB,a
	movam temp_buf
	movla b'00000011'
	and temp_buf,m
	bc STATUS,C
	rlmc temp_buf
	rlmc temp_buf
	rlmc temp_buf
	rlmc temp_buf
	mov temp_buf,a
	xor a_buf,a
	movam sensor_id
wake_up_from_wdt
	;bs set_ir_power
	enter_wake_up

init_chip_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;serial send 8bit data 9600bps 		data place at send_data
serial_send_8bit macro
	local send_next_bit,send_1,send_0,send_bit_end,send_8bit_end
	movla .8
	movam bit_counter
send_next_bit
	;rr send_data,m
	rrmc send_data
	jnc send_0
send_1
	bc set_tx
	lgoto send_bit_end
send_0
	bs set_tx
send_bit_end
	lcall delay_100us
	decsz bit_counter,m
	lgoto send_next_bit
send_8bit_end

endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;serial send	9600bps		data place at send_data
serial_send macro
	;;start bit 
	bs set_tx
	lcall delay_100us
	;;start to send 8bit data
	serial_send_8bit
	;;stop bit
	bc set_tx
	lcall delay_100us
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;serial receive 8bit data 9600bps 			after receive,place it at receive_data
serial_receive_8bit macro
	local receive_next_bit,receive_1,receive_0,receive_bit_end,receive_8bit_end
	;init variable
	clr receive_data
	movla .1
	movam decode_mask

receive_next_bit
	lcall delay_100us
	btsc test_rx
	lgoto receive_0
receive_1
	mov decode_mask,a
	ior receive_data,m
receive_0
receive_bit_end
	bc STATUS,C
	;rl decode_mask,m
	rlmc decode_mask
	jc receive_8bit_end
	lgoto receive_next_bit
receive_8bit_end
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;serial receive 9600bps		after received ,place it at receive_data
serial_receive macro
	;;start bit 
	btss test_rx
	lgoto serial_receive_end
	
	;ps:make sure the sample timing is in the middle of the stable state,then I sample per 100us,avoid sampling at the changing edge or any other wrong time
	lcall delay_40us
	;;start to receive 8bit data
	serial_receive_8bit
	;;stop bit ....in fact ,it's not necessary to receive it ...
	nop
	
serial_receive_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;ir send 38Khz carrier,counter place at ir_send_38khz_counter
ir_send_38Khz macro
	local ir_send_38Khz_next,ir_send_38Khz_low_delay
ir_send_38Khz_next
	;8.77us high 
	bs set_ir_out
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	;17.53us low
	bc set_ir_out
	movla .4
	movam tm_counter_l
ir_send_38Khz_low_delay
	decsz tm_counter_l,m
	lgoto ir_send_38Khz_low_delay
	decsz ir_send_38Khz_counter,m
	lgoto ir_send_38Khz_next
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;ir send 8bit ...send data according to the ir protocol ..data place at ir_send_data
ir_send_8bit macro
	local ir_send_next_bit,ir_send_1,ir_send_0,ir_send_bit_end
	movla .8
	movam bit_counter
ir_send_next_bit
	;0.56ms 38khz carrier
	movla .21
	movam ir_send_38Khz_counter
	ir_send_38khz
	;rr ir_send_data,m
	rrmc ir_send_data
	jnc ir_send_0
ir_send_1
	;1.68ms low
	lcall delay_1680us
	lgoto ir_send_bit_end
ir_send_0
	;0.56ms low
	lcall delay_560us
ir_send_bit_end
	decsz bit_counter,m
	lgoto ir_send_next_bit
	
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;ir send data...data place at custom_8h custom_8l data_8h data_8l
ir_send macro
	local ir_send_next_byte,ir_send_end,ir_send_9ms_carrier
	;;standard is 9ms ...change it to 72ms... change back again(081107)
	;72ms 38khz carrier			;;26*27*100~72000us
	;9ms 28khz carrier				;26*2*173~9000us

	clr ir_send_counter

ir_send_9ms_carrier
	;movla .100
	movla .173
	movam ir_send_38Khz_counter
	ir_send_38Khz
	inc ir_send_counter,m
	;sj ir_send_counter,.27,ir_send_9ms_carrier
	sj ir_send_counter,.2,ir_send_9ms_carrier
	

	
	;4.5ms low
	m_delay_ms .4
	;send 32 bit data
	movla custom_8l
	movam BSR
ir_send_next_byte
	mov INDF,a
	movam ir_send_data
	ir_send_8bit
	mov BSR,a
	andla b'00111111'

	xorla data_8h
	jz ir_send_end
	dec BSR,m
	lgoto ir_send_next_byte
ir_send_end
	;;;;;stop bit   0.56ms 38khz carrier
	movla .21
	movam ir_send_38Khz_counter
	ir_send_38Khz
	
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan the ir
;ir_scan					;it has only two stack level , so use macro instead function
ir_scan macro
	;save irqm first , it will be restored at the end of ir_scan
	mov IRQM,a
	movam irqm_buf

	btsc test_ir_in		;;;;;;port b can use like this????????or must save it's status at a normal memery???
	lgoto ir_scan_end
	lcall delay_100us
	btsc test_ir_in
	lgoto ir_scan_end

	bc IRQM,INTM
	;;;;;;low 72ms		72ms..not 9ms
	movla .0
	movam tm_counter_l
	movam tm_counter_h
	
l_9ms
	btsc test_ir_in
	lgoto l_9ms_end
	lcall delay_100us
	inc tm_counter_l,m
	movla .90			;avoid dead circle		high limit 9ms
	;movla .90			;avoid dead circle		high limit 9*10ms
	sj tm_counter_l,.90,l_9ms
	;;;;;different from standard protocol , low is 90ms to avoid the wake up from sleep mode ,the port can't read
	;clr tm_counter_l
	;inc tm_counter_h,m
	;sj tm_counter_h,.10,l_9ms
	
	lgoto ir_scan_end		;it shouldn't come here....overflow
l_9ms_end
	movla .64			;low limit 64
	sub tm_counter_l,a
	jnc ir_scan_end

	;;;;;;high 4.5ms
	movla .0
	movam tm_counter_l
	movam tm_counter_h
h_4ms
	btss test_ir_in
	lgoto h_4ms_end
	lcall delay_100us
	inc tm_counter_l,m
	;avoid dead circle		high limit 45
	sj tm_counter_l,.45,h_4ms
	lgoto ir_scan_end		;overflow
h_4ms_end
	;low limit 35
	sj tm_counter_l,.35,ir_scan_end

	;reset the data
	movla .0
	movam custom_8h
	movam custom_8l
	movam data_8h
	movam data_8l
	movam receive_data
	movla b'00000001'
	movam decode_mask
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
	;avoid dead circle  high limit 8
	sj tm_counter_l,.8,l_056ms
	lgoto ir_scan_end				;overflow
l_056ms_end

h_1or0							;high voltage,1:2.25-0.56ms  0:1.25-0.56ms
	btss test_ir_in
	lgoto h_1or0_end
	lcall delay_100us
	inc tm_counter_l,m
	;avoid dead circle high limit 24
	sj tm_counter_l,.24,h_1or0

	lgoto ir_scan_end			;overflow
h_1or0_end
	;receive a bit check the bit is 1 or 0
	;>17 means receive 1 ...<17 means receive 0
	sj tm_counter_l,.17,rec_a_bit

	mov decode_mask,a			;receive 1
	ior receive_data,m
	;receive 0 needn't any other operate
rec_a_bit
	;;;   *_*!!!!!     must clear status .c first...
	bc STATUS,C
	;rl decode_mask,m
	rlmc decode_mask
	jc rec_a_byte
	lgoto data_code
rec_a_byte
	movla .1
	movam decode_mask

	mov receive_data,a
	movam INDF
	clr receive_data
	
rec_a_byte_end
	mov BSR,a
	andla b'00111111'	;remove unuse bit
	xorla data_8h
	jz data_code_end
	dec BSR,m 
	lgoto data_code

	
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
	mov irqm_buf,a
	movam IRQM
;	bs IRQM,INTM
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;ir handle
ir_key_handle macro
	btss my_status,ir_recevie_status		;;have receive data or not..
	lgoto ir_key_handle_end
	bc my_status,ir_recevie_status
	
	;save irqm first , it will be restored after send ir
	mov IRQM,a
	movam irqm_buf

	;;;;;;;;;;;add handle here..
	ir_send
	
	mov irqm_buf,a
	movam IRQM
	
;	mov data_8l,a
;	xorla key_stop
;	jnz ir_key_handle_normal_alarm
;	stop_alarm
;	
;	clr alarm_status
	
;	lgoto ir_key_handle_end

	ej data_8l,key_stop,ir_key_handle_stop
	ej data_8l,key_idle_mode,ir_key_handle_idle_mode
	ej data_8l,key_working_mode,ir_key_handle_working_mode
	lgoto ir_key_handle_normal_alarm

ir_key_handle_working_mode
ir_key_handle_stop
	stop_alarm
	clr alarm_status
	bc my_status,sys_work_status
	lgoto ir_key_handle_end
	
ir_key_handle_idle_mode
	;;int10@0980106			;if id <id_danger_level , it sholdn't go to idle mode
	sj sensor_id,id_danger_level,ir_key_handle_end
	stop_alarm
	clr alarm_status
	bs my_status,sys_work_status
	lgoto ir_key_handle_end

ir_key_handle_normal_alarm
	mov sensor_id,a
	xorla normal_alarm_id
	jnz ir_key_handle_end
	btsc alarm_status,alarm_on_off
	lgoto ir_key_handle_end
	start_alarm
	bs alarm_status,alarm_on_off
	bs alarm_status,alarm_ir

ir_key_handle_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;go into sleep mode
enter_sleep macro
ifdef HAVE_SLEEP_MODE
	;when it's alarming ,don't goto sleep
	btsc alarm_status,alarm_on_off
	lgoto enter_sleep_end
	;int10int10
	;enj loop_counter,.28,enter_sleep_end
	enj loop_counter1,.62,enter_sleep_end


	;pull down ir_power
	bc set_ir_power
	;set all pin-b can wake up
	;;int10int10
;	movla 0xff
	movla b'00001000'
	movam WAKE_UP
	;stop timer
	movla 0xff 
	movam TMR0

	;;set wdt
	movla b'01001111'		;it's about 3s to wake up
	select
	
	;had better read portb once,though I don't know why , but datasheep suggest it...
	mov PORTB,a
	nop
	nop
	nop
	sleep 
	nop
	nop
	nop
	;;;;;;wake up by port b
	enter_wake_up
enter_sleep_end
endif
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;send sensor id   before send ir ,must disable alarm , and after send ir 16 times(about 1s) , enable alarm again...it's stupid ,but I can't find a better way to assign the time between 
;;send ir and alarm ....
send_sensor_id macro
	local send_sensor_id_end,send_sensor_id_restore
	btss my_status,ir_need_send
	lgoto send_sensor_id_end

	;;;;;;;;; send sensor id per 5 loops
;	inc loop_counter,m
	;int10int10
;	enj loop_counter,.5,send_sensor_id_end
	enj loop_counter,.5,send_sensor_id_end
	clr loop_counter
	

	btss alarm_status,alarm_silent		;;don't send ir when the alarm is beeping..
	lgoto send_sensor_id_end
	
	;;start to send id
	;;had better disable irq first...avoid disturbing at  send 38khz carrier..and it will be enable after sended 16 times ir....
;	mov IRQM,a
	bc IRQM,INTM
;	movam irqm_buf

	
	;;;;;;;;;;;;;;;;;;;;;;;;  stop alarmer first...
	bc set_alarm
	bc alarm_status,alarm_pin_status
	;bc my_status,ir_need_send
	mov sensor_id,a
	movam data_8l
	com data_8l,a
	movam data_8h
	movla custom_code
	movam custom_8l
	com custom_8l,a
	movam custom_8h
	ir_send


	;;;;;send 160 times only , it almost spend >10S..
	inc send_id_counter,m
	mov send_id_counter,a
	andla b'00001111'
	jnz send_sensor_id_end
	;start_alarm

	;;start alarm per 16times...about 1s..
	movla .200
	movam alarm_counter1
	movla alarm_alarming_const
	movam alarm_counter2
	movla alarm_send_ir_period
	movam alarm_counter3
	movla b'10000001' 
	movam irqm
	clr irqf
	bc alarm_status,alarm_silent

	

	sj send_id_counter,.160,send_sensor_id_end
	;enj send_id_counter,.160,send_sensor_id_restore
	bc my_status,ir_need_send

;send_sensor_id_restore
;	;;restore irqm
;	mov irqm_buf,a
;	movam IRQM
	
send_sensor_id_end

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan sensor
sensor_scan macro
	;if it's idle mode ,needn't check it
	btsc my_status,sys_work_status
	lgoto sensor_scan_end
	btsc test_sensor
	lgoto sensor_scan_ok
	btsc alarm_status,alarm_on_off
	lgoto sensor_scan_end
	;;;;;;;;add code here
	bs alarm_status,alarm_on_off
	bs alarm_status,alarm_sensor
	bs my_status,ir_need_send
	send_sensor_id
	start_alarm
	lgoto sensor_scan_end
	
sensor_scan_ok
;	btss alarm_status,alarm_on_off
;	lgoto sensor_scan_end
;	btss alarm_status,alarm_sensor
;	lgoto sensor_scan_end
;	stop_alarm
;	bc alarm_status,alarm_on_off
;	bc alarm_status,alarm_sensor
sensor_scan_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan low power
low_pw_scan macro
	btsc test_low_pw
	lgoto low_pw_scan_ok
	btsc alarm_status,alarm_on_off
	lgoto low_pw_scan_end
	;;add code here
	start_alarm
	bs alarm_status,alarm_on_off
	bs alarm_status,alarm_low_pw
	lgoto low_pw_scan_end
	
low_pw_scan_ok
	btss alarm_status,alarm_on_off
	lgoto low_pw_scan_end
	btss alarm_status,alarm_low_pw
	lgoto low_pw_scan_end
	stop_alarm
	bc alarm_status,alarm_on_off
	bc alarm_status,alarm_low_pw
	
low_pw_scan_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start alarm
start_alarm macro
	;;init variable
	clr IRQM
		
	movla .200
	movam alarm_counter1
	movla alarm_alarming_const
	movam alarm_counter2
	movla alarm_send_ir_period
	movam alarm_counter3

	movla b'11000110'
	select
	movla .1
	movam TMR0		;1*128= 128us
	;enable tmr0 int
	movla b'10000001' 
	movam irqm
	clr irqf

	;;;;init some var
	bc alarm_status,alarm_silent
	clr loop_counter
	bs my_status,ir_need_send
	clr send_id_counter

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;stop alarm
stop_alarm macro
	movla b'01001111'
	select
	movla 0xff
	movam TMR0
	clr IRQM
	clr IRQF
	bc set_alarm
	clr alarm_status
	enter_wake_up

	;;;;
	clr loop_counter
	bc my_status,ir_need_send
	
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;delay function
;;the conter expresstion      (instruction_counter)*(instructions_per_circle) = (total_instruction)-4
;;ps:mk7a21p one instruction build by 2 system clock...  mk7a11p is 4 system clock

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 40us  
delay_40us
	movla const_delay_40us
	movam delay_counter
delay_40_us_loop
	clrwdt
	decsz delay_counter,m
	lgoto delay_40_us_loop
delay_40us_end
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 100us 
delay_100us
	movla const_delay_100us
	movam delay_counter
delay_100_us_loop
	clrwdt
	decsz delay_counter,m
	lgoto delay_100_us_loop
delay_100us_end
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 560us 
delay_560us
	movla const_delay_560us
	movam delay_counter	
delay_560us_loop
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	decsz delay_counter,m
	lgoto delay_560us_loop
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
delay_560us_end
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 1680us	 
delay_1680us
	movla const_delay_1680us
	movam delay_counter	
delay_1680us_loop
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
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
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt

	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 1ms 
delay_1ms
	movla const_delay_1ms
	movam delay_counter
delay_1ms_loop
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	decsz delay_counter,m
	lgoto delay_1ms_loop
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
delay_1ms_end
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;main function     it must write under the macro ,or it can't call the macro
main
	init_chip

	nop	
main_loop
	clrwdt

ifdef ALARM_ANNUNCIATOR
	sensor_scan
	ir_scan
	ir_key_handle
	low_pw_scan
	send_sensor_id
	enter_sleep
	inc loop_counter,m
	jnz main_loop
	inc loop_counter1,m
	
endif
ifdef PC_CONNECTER


endif
	
	lgoto main_loop
	ret

end






