;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Creat by int10@080304
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;use MK7A11P chip
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;it has only two level stack , had better reduce using lcall ,
;;so ,many function only call once at main function , 
;;I perfor macro to function...but pay attention:the macro 
;;must befor main function,or it can't be used...


;#include "mk7a11p.inc"

;配置寄存器设置说明（CONFIG） 
;1-----------FOSC=RC    ;LS,NS,HS,RC    
;2-----------INRC=ON    ;ON,OFF 
;3-----------CPT=ON    ;ON,OFF    
;4-----------WDTE=Enable   ;Enable,Disable 
;5-----------LV=Low Vol Reset ON  ;Low Vol Reset ON,Low Vol Reset OFF 
;6-----------RESET=...input...   ;...input...,...reset... 

;ps: the code is too big to place at 11p...so don't define USE_CHIP_MK7A11P  here....
#define USE_CHIP_MK7A21P

#define CHECK_SMS_BETWEEN_CALL
#define SEND_SMS

ifdef USE_CHIP_MK7A11P
#include "mk7a11p.inc"			;;;

endif
ifdef USE_CHIP_MK7A21P
#include "mk7a21p.inc"
endif



;;;;;;;;;;;;;;;;;;;;;CHANGE SOME KEY WORDS TO MK7A11P , FOR USE ONE CODE TO HANDLE THE TWO CHIP ;;;;;;;;;;;
ifdef USE_CHIP_MK7A21P
#define PORTB PB_DAT
#define PORTA PA_DAT
#define PORTC PC_DAT
#define BSR FSR
else				
endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;project
;#define ALARM_ANNUNCIATOR
#define PC_CONNECTER

#define custom_code				0x56
#define normal_alarm_id			0x00
#define key_stop					0xfe
#define key_idle_mode				0xfd
#define key_working_mode			0xfc

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

ifdef USE_CHIP_MK7A11P
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bit_tx 		equ 		PA1
bit_rx 		equ		PA0
bit_pwk		equ		PB2
bit_ir_out	equ		PB7
bit_ir_in		equ		PB5
;bit_sensor	equ		PB3
bit_low_pw	equ		PB4
;bit_alarm	equ		PB6
bit_led		equ		PB6
bit_sms		equ		PB1
bit_wdt		equ		PA2
bit_reset	equ		PB3

#define set_tx PORTA,bit_tx
#define test_rx PORTA,bit_rx
#define set_ir_out	PORTB,bit_ir_out
#define test_ir_in		PORTB,bit_ir_in
;#define test_sensor	PORTB,bit_sensor
#define test_low_pw	PORTB,bit_low_pw
;#define set_alarm	PORTB,bit_alarm
#define set_led		PORTB,bit_led
#define set_pwk		PORTB,bit_pwk
#define test_sms		PORTB,bit_sms
#define test_wdt		PORTA,bit_wdt
#define set_reset		PORTB,bit_reset
endif

ifdef USE_CHIP_MK7A21P
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int10int10
bit_tx 		equ 		PA3
bit_rx 		equ		PA4
;bit_tx 		equ		PA5
bit_pwk		equ		PC0
bit_ir_out	equ		PA2
bit_ir_in		equ		PB1
;bit_sensor	equ		PB3
bit_low_pw	equ		PB0
;bit_alarm	equ		PB6
bit_led		equ		PB3
bit_sms		equ		PC1
bit_wdt		equ		PA5
bit_reset	equ		PC3

#define set_tx PORTA,bit_tx
#define test_rx PORTA,bit_rx
#define set_ir_out	PORTA,bit_ir_out
#define test_ir_in		PORTB,bit_ir_in
;#define test_sensor	PORTB,bit_sensor
#define test_low_pw	PORTB,bit_low_pw
;#define set_alarm	PORTB,bit_alarm
#define set_led		PORTB,bit_led
#define set_pwk		PORTC,bit_pwk
#define test_sms		PORTC,bit_sms
#define test_wdt		PORTA,bit_wdt
#define set_reset		PORTC,bit_reset
endif

;alarm_status define
alarm_pin_status		equ	0
alarm_on_off			equ	1
alarm_sensor			equ	2
alarm_ir				equ	3
alarm_low_pw			equ	4
alarm_silent				equ	5
alarm_enable			equ	7

;my_status define 
ir_recevie_status		equ	0
ir_need_send			equ	1
my_wdt_overflow		equ	2
pin_wdt_status			equ	3
serial_receive_status	equ	4
serial_string_receive_status	equ 5
module_camera_status	equ 6


alarm_silent_const		equ	.40
alarm_alarming_const	equ	.20
my_wdt_overflow_const	equ	.255

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;memery map			;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ifdef USE_CHIP_MK7A11P

a_buf			equ   		0x20   		;acc缓存器 
status_buf		equ   		0x21   		;status缓存器 
irqm_buf		equ			0x22
pc_buf			equ			0x23
my_status		equ			0x24		;bit0:whether ir received a code...0:no received	1:received.....bit1:whether need send a ir code....bit2:my watchdog overflow,
										;nee reset module....bit3:save the extern wdt pin status....bit4:whether serial receive a byte data..bit5:whether serial receive a complete string
alarm_status	equ			0x25				;bit 0:status of pin alarm ...bit 1:status of alarm,0means no alarm ,1means alarming
														;bit 2~4 is alarm type ....bit2:sensor..bit3:ir..bit 4 low pw.....bit 5:whether alarming or being silent...bit 7is alarm enable
temp_buf		equ			0x26
delay_counter	equ			0x27
tm_counter_l 	equ 			0x28			;counter , use to get the time
tm_counter_h 	equ 			0x29


;alarm_counter1	equ			0x2a
;alarm_counter2	equ			0x2b
;alarm_counter3	equ			0x2c
alarm_overflow1	equ			0x2c
alarm_voerflow2	equ			0x2d

int_temp_buf	equ			0x2e


bit_counter				equ			0x30
delay_ms_counter		equ			0x31
decode_mask			equ			0x32

dial_out_num			equ			0x33
dial_out_counter			equ			0x34


custom_8h 		equ 			0x37;f						;custom code  ~custom
custom_8l 		equ 			0x38;f						;;;;;;custom data...
data_8h 		equ 			0x35			;7			;data code		~data
data_8l 			equ 			0x36		;d				;;;;;;data code
ir_send_data			equ			0x39
ir_send_38Khz_counter	equ			0x3a

receive_data			equ			0x3f
send_data				equ			0x3f
d2s_d_tmp				equ			0x3d
d2s_h_tmp				equ			0x3e
d2s_l_tmp				equ			0x3f
serial_buf_base			equ			0x35				;0x35~0x3f , 11bytes buf		ps:overlap with some ir memery..so ,release it as soon as possible after serial part use it
serial_buf_end			equ			0x3f					;serial buf end

endif
ifdef USE_CHIP_MK7A21P
a_buf			equ   		0x40   		;acc缓存器 
status_buf		equ   		0x41   		;status缓存器 
irqm_buf		equ			0x42
pc_buf			equ			0x43
my_status		equ			0x44		;bit0:whether ir received a code...0:no received	1:received.....bit1:whether need send a ir code....bit2:my watchdog overflow,
										;nee reset module....bit3:save the extern wdt pin status....bit4:whether serial receive a byte data..bit5: whether serial receive a byte
										;bit6:whether module camera is working
alarm_status	equ			0x45				;bit 0:status of pin alarm ...bit 1:status of alarm,0means no alarm ,1means alarming
														;bit 2~4 is alarm type ....bit2:sensor..bit3:ir..bit 4 low pw.....bit 5:whether alarming or being silent...bit 7is alarm enable
temp_buf		equ			0x46
delay_counter	equ			0x47
tm_counter_l 	equ 			0x48			;counter , use to get the time
tm_counter_h 	equ 			0x49


;alarm_counter1	equ			0x4a
;alarm_counter2	equ			0x4b
;alarm_counter3	equ			0x4c
alarm_overflow1	equ			0x4c
alarm_voerflow2	equ			0x4d

int_temp_buf	equ			0x4e
my_status_backup		equ	0x4f


bit_counter				equ			0x50
delay_ms_counter		equ			0x51
decode_mask			equ			0x52

dial_out_num			equ			0x53
dial_out_counter			equ			0x54


custom_8h 		equ 			0x57;f						;custom code  ~custom
custom_8l 		equ 			0x58;f						;;;;;;custom data...
data_8h 		equ 			0x55			;7			;data code		~data
data_8l 			equ 			0x56		;d				;;;;;;data code
ir_send_data			equ			0x59
ir_send_38Khz_counter	equ			0x5a

receive_data			equ			0x5f
send_data				equ			0x5f
d2s_d_tmp				equ			0x5d
d2s_h_tmp				equ			0x5e
d2s_l_tmp				equ			0x5f
serial_buf_base			equ			0x60				;0x60~0x6f , 16bytes buf		ps:overlap with some ir memery..so ,release it as soon as possible after serial part use it
serial_buf_end			equ			0x6f					;serial buf end

fun_result				equ			serial_buf_base
sensor_id				equ			data_8l



s0			equ	0x60
s1			equ	0x61
s2			equ	0x62
s3			equ	0x63
s4			equ	0x64
s5			equ	0x65
s6			equ	0x66
s7			equ	0x67
s8			equ	0x68
s9			equ	0x69
sa			equ	0x6a
sb			equ	0x6b
sc			equ	0x6c
sd			equ	0x6d
se			equ	0x6e
sf			equ	0x6f



endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;some macro
ifdef USE_CHIP_MK7A11P				;mk7a21p have jz jc already
;jz macro position
;	btsc STATUS,Z
;	lgoto position
;endm
;    *_*!!!...NND  sub instruction  0:have carry      1:no carry.........rl instruction 0:no carry 1:have carry   
;;;;so pay attention:sub instruction   jc means (M)>L then jmp   jnc means (M)<L then jmp
;jc macro position
;	btsc STATUS,C
;	lgoto position
;endm
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
;rrmc macro M
;	rr M,a
;	movam M
;endm
;rlmc macro M
;	rl M,a
;	movam M
;endm
endif
ifdef USE_CHIP_MK7A21P
rrmc macro M
	rrc M,a
	movam M
endm
rlmc macro M
	rlc M,a
	movam M
endm
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;for mk7a11p only have two level stack , so I use macro instread of lcall ..but now the code is too big to place in flash , had to optimize it ..
;;so use the two macro to reduce the code ....in fact , I hate it ....
ifdef USE_CHIP_MK7A11P
mycall macro function
	mov PC,a
	movam pc_buf
	movla .4
	add pc_buf,m
	lgoto function
endm

myret macro
	mov pc_buf,a
	movam pc
endm
endif

ifdef USE_CHIP_MK7A21P
mycall macro function
	lcall function
endm

myret macro
	ret
endm
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
en_int macro
	bs IRQM,INTM
endm

dis_int macro
	bc IRQM,INTM
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set main entery
ifdef USE_CHIP_MK7A11P
org			0x3fe
lgoto		int_entry
org			0x3ff				;mk7a11p的复位向量地址定义 
lgoto		main				;跳转到主程序入口   
org 			0x0000
else		;USE_CHIP_MK7A11P
org			0x000				;mk7a21p的复位向量地址定义 
lgoto		main
org			0x004
lgoto		int_entry
org 			0x0010
endif	;USE_CHIP_MK7A11P



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

ifdef USE_CHIP_MK7A11P
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;tm0 int
int_tm0 macro

	bc irqf,tm0f
	;;;add the code below

	;;;;my watchdog 
	dec alarm_overflow1,m			;if alarm_overflow1 init to 255 ,it's about 8S,then overflow...
	jnz int_tm0_end
	movla my_wdt_overflow_const
	movam alarm_overflow1
	bs my_status,my_wdt_overflow
	
int_tm0_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;pb0 int
int_p0 macro
	bc IRQF,PB0F
	;;add the code below
	
int_p0_end
endm
endif

ifdef USE_CHIP_MK7A21P
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;tm0 int
int_tm0 macro

	bc IRQF,TM1F
	;;;add the code below

	;;;;my watchdog 
	dec alarm_overflow1,m
	jnz int_tm0_end
	movla my_wdt_overflow_const
	movam alarm_overflow1
	bs my_status,my_wdt_overflow
	
int_tm0_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;pb0 int
int_p0 macro
	bc IRQF,PAF
	;;add the code below
	
int_p0_end
endm
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;int function
int_entry
	;;enter int ,save the register..
	movam a_buf 
	swap status,a 
	movam status_buf 

ifdef USE_CHIP_MK7A11P
	btsc irqf,tm0f  	;test int type
	lgoto int_tm0_entry  	;switch to right type int
	btsc IRQF,PB0F
	lgoto int_pb0_entry
endif
ifdef USE_CHIP_MK7A21P
	btsc IRQF,TM1F		;test int type
	lgoto int_tm0_entry  	;switch to right type int
	btsc IRQF,PAF
	lgoto int_pb0_entry

endif

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
;;init the chip
init_chip macro

ifdef USE_CHIP_MK7A11P
	;PortA端口方向及状态设定            
	movla      	b'00000111' 
	movam temp_buf
	bc temp_buf,bit_tx
	bc temp_buf,bit_pwk
	mov temp_buf,a
	iodir         	PORTA
	clr   		PORTA
	clr          	PA_PDM
	;------------------------------------------------------ 
	;PortB端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
	bc temp_buf,bit_ir_out
	;bc temp_buf,bit_alarm
	bc temp_buf,bit_led
	mov temp_buf,a
	iodir          	PORTB
	clr   		PORTB
	clr          	PB_POD
	clr          	PB_PDM

;	;;;;;;;;set pull up register
	movla b'11111111'
	movam temp_buf
	mov temp_buf,a
	movam PB_PUP


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;init wtd
	movla b'01001111'
	select
endif


ifdef USE_CHIP_MK7A21P
	;PortA端口方向及状态设定            
	movla      	0xff
	movam temp_buf
	bc temp_buf,bit_ir_out
	bc temp_buf,bit_tx
	mov temp_buf,a
	movam PA_DIR
	clr   		PORTA
	clr          	PA_PLU
	;------------------------------------------------------ 
	;PortB端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
	bc temp_buf,bit_led
	mov temp_buf,a
	movam PB_DIR
	clr   		PORTB
	;------------------------------------------------------

	;PortC端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
	;bc temp_buf,bit_pwk
;	bc temp_buf,bit_reset
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

	movla b'11111111'
	movam temp_buf
	bc temp_buf,bit_led
	mov temp_buf,a
	movam PB_PLU

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;init wtd
	movla b'10000111'
	movam WDT_CTL
endif

	;pull up tx..
	bs set_tx
	;;;;;;;;;;;;;;;;;;;;;;;
	;;init variable
	clr alarm_status
	clr my_status


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
	bs set_tx
	lgoto send_bit_end
send_0
	bc set_tx
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
	bc set_tx
	lcall delay_100us
	;;start to send 8bit data
	serial_send_8bit
	;;stop bit
	bs set_tx
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
	btss test_rx
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
;;serial receive 9600bps		after received ,place it at receive_data , if receive_data = 0 ;means receive no data
serial_receive macro
	local serial_receive_end,serial_receive_stop_bit_wait
	;;start bit 
	clr receive_data
	bc my_status,serial_receive_status
	btsc test_rx
	lgoto serial_receive_end
	btsc test_rx
	lgoto serial_receive_end

	;ps:make sure the sample timing is in the middle of the stable state,then I sample per 100us,avoid sampling at the changing edge or any other wrong time
	lcall delay_40us
	;;start to receive 8bit data
	serial_receive_8bit
	bs my_status,serial_receive_status
	;;stop bit .... after delay 100us ,wait about 65us to make sure receive the complete bit ...
	;;but if test_rx change to low ,means next byte is coming ,must quit and change to receive next byte immediately
	lcall delay_100us
	movla 17
	movam tm_counter_l
serial_receive_stop_bit_wait:
	btss test_rx
	lgoto serial_receive_end
	decsz tm_counter_l,m
	lgoto serial_receive_stop_bit_wait
	
serial_receive_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;send a string .... data place at serial_buf_base
serial_send_string macro
	local serial_send_string_next_byte,serial_send_string_end
	movla serial_buf_base
	movam BSR

serial_send_string_next_byte
	mov INDF,a
	movam send_data
	serial_send
	mov INDF,a
	movam send_data
	ej send_data,0x00,serial_send_string_end
	inc BSR,m
	lgoto serial_send_string_next_byte
	
serial_send_string_end
	clr BSR

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;receive a string ..... data place at serial_buf_base
serial_receive_string macro
	local serial_receive_string_next_byte,serial_receive_string_sucess,serial_receive_string_end
	movla serial_buf_base
	movam BSR
	bc my_status,serial_string_receive_status

serial_receive_string_next_byte
	serial_receive
	btss my_status,serial_receive_status
	lgoto serial_receive_string_end
	mov receive_data,a
	movam INDF
	ej receive_data,0x0a,serial_receive_string_sucess
	inc BSR,m
	ej BSR,serial_buf_end,serial_receive_string_end
	lgoto serial_receive_string_next_byte
serial_receive_string_sucess
	bs my_status,serial_string_receive_status
serial_receive_string_end
	clr BSR
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;receive a byte.....data place at receive_data .....time out is about time_out_counter*32mS
serial_receive_wait macro time_out_counter
	local serial_receive_wait_wait,serial_receive_wait_end
	movla time_out_counter
	movam alarm_overflow1
	bc my_status,my_wdt_overflow
serial_receive_wait_wait
	clrwdt
	serial_receive
	mov receive_data,a
	jnz serial_receive_wait_end
	btss my_status,my_wdt_overflow
	lgoto serial_receive_wait_wait
serial_receive_wait_end
	
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
ifdef USE_CHIP_MK7A21P
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
endif

	;17.53us low
	bc set_ir_out
ifdef USE_CHIP_MK7A11P
	movla .4
endif
ifdef USE_CHIP_MK7A21P
	movla .8
endif
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
	local ir_send_next_byte,ir_send_end
	;9ms 38khz carrier			;becouse counter is 8bit ,it can't bigger than 255..so divide 342 to 172*2 ,socall ir_send_38khz twice
	movla .171
	movam ir_send_38Khz_counter
	ir_send_38Khz
	movla .171
	movam ir_send_38Khz_counter
	ir_send_38Khz	
	
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
ifdef USE_CHIP_MK7A11P
	andla b'00111111'
endif

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
	;movla .90			;avoid dead circle		high limit 90
	sj tm_counter_l,.90,l_9ms
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
	nop
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
ifdef USE_CHIP_MK7A11P
	andla b'00111111'	;remove unuse bit
endif
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
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;ir handle
ir_key_handle macro
	btss my_status,ir_recevie_status		;;have receive data or not..
	lgoto ir_key_handle_end
	bc my_status,ir_recevie_status
	;;;;;;;;;;;add handle here..
	ir_send
	mov data_8l,a
	xorla key_stop
	jnz ir_key_handle_normal_alarm
	stop_alarm
	clr alarm_status
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;power on
pw_on macro
	bc set_pwk
	;;;;wait for return charset
pw_on_wait_ack
	serial_receive
	enj receive_data,'W',pw_on_wait_ack
	bs set_pwk
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;reset MTK module
reset_module macro
	local reset_module_wait
	bc set_reset
	;;;;;;;;wait about 2S
	movla .64
	movam alarm_overflow1
	bc my_status,my_wdt_overflow
reset_module_wait
	clrwdt
	btss my_status,my_wdt_overflow
	lgoto reset_module_wait
	bs set_reset
	;;;reset my watch dog
	movla my_wdt_overflow_const
	movam alarm_overflow1
	bc my_status,my_wdt_overflow
	
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;go into sleep mode
enter_sleep macro
ifdef HAVE_SLEEP_MODE
	;when it's alarming ,don't goto sleep
	btsc alarm_status,alarm_on_off
	lgoto enter_sleep_end
	;set all pin-b can wake up
	movla 0xff
	movam WAKE_UP
	;stop timer
	movla 0xff 
	movam TMR0
	;had better read portb once,though I don't know why , but datasheep suggest it...
	mov PORTB,a
	nop
	nop
	nop
	sleep 
	nop
	nop
	nop
enter_sleep_end
endif
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;send sensor id 
send_sensor_id macro
	local send_sensor_id_end
	btss my_status,ir_need_send
	lgoto send_sensor_id_end
	;;start to send id
	;;had better disable irq first...avoid disturbing at  send 38khz carrier..
	mov IRQM,a
	bc IRQM,INTM
	movam irqm_buf
	bc my_status,ir_need_send
	mov sensor_id,a
	movam data_8l
	com data_8l,a
	movam data_8h
	movla custom_code
	movam custom_8l
	com custom_8l,a
	movam custom_8h
	ir_send
	;;restore irqm
	mov irqm_buf,a
	movam IRQM
send_sensor_id_end

endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;sensor handle   such start alarm and make calls and send sms
sensor_handle macro

	start_alarm
	;;start camera&make picture

	;;;;make calls 

	;;;send sms
	

sensor_handle_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan sensor
sensor_scan macro
	btsc test_sensor
	lgoto sensor_scan_ok
;	btsc alarm_status,alarm_on_off
;	lgoto sensor_scan_end
	;;;;;;;;add code here
;	bs alarm_status,alarm_on_off
;	bs alarm_status,alarm_sensor
;	bs my_status,ir_need_send
;	send_sensor_id
;	start_alarm
;	lgoto sensor_scan_end

	sensor_handle
	
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
	movla .200
	movam alarm_counter1
	movla alarm_alarming_const
	movam alarm_counter2
;	movla .10
;	movam alarm_counter3

	movla b'11000110'
	select
	movla .1
	movam TMR0		;1*128= 128us
	;enable tmr0 int
	movla b'10000001' 
	movam irqm
	clr irqf

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

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;check wether receive sms and do some..
sms_scan macro
	btsc test_sms
	lgoto sms_scan_end
	
sms_scan_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start tm0		in fact , in 21p, it's tm1
start_tm0 macro
	;;init variable
;	movla .200
;	movam alarm_counter1
;	movla alarm_alarming_const
;	movam alarm_counter2
;	movla my_wdt_overflow_const
;	movam alarm_overflow1

ifdef USE_CHIP_MK7A11P
	movla b'11000110'
	select
	movla .255
	movam TMR0		;255*128= 32ms
	;enable tmr0 int
	movla b'10000001' 
	movam irqm
	clr irqf
endif
ifdef USE_CHIP_MK7A21P
	movla b'01100111'
	movam tm1_ctl1       	;TM1时钟源内部RC时钟,预分频1:128
	movla 0x12 
	movam tm1l_la 
	movla 0x7a
	movam tm1h_la  	;溢出周期1S
	
	movla b'10000010' 	;以下是中断设置 
	movam irqm
	clr irqf 
	bs tm1_ctl1,7
endif

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;stop tm0		in fat ,in 21p , it's tm1
stop_tm0 macro
ifdef USE_CHIP_MK7A11P
	movla b'01001111'
	select
	movla 0xff
	movam TMR0
	clr IRQM
	clr IRQF	
endif
ifdef USE_CHIP_MK7A21P
	bc TM1_CTL1,7
	clr IRQM
	clr IRQF
endif
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;data to string......change a data to string ..but pay a attention..it only support 2bit data..data place at d2s_d_tmp,string place at d2s_h_tmp,d2s_l_tmp
d2s macro
	local d2s_loop,d2s_end
	clr d2s_h_tmp
	clr d2s_l_tmp
	ej d2s_d_tmp, .0,d2s_end
	sj d2s_d_tmp,.10,d2s_end

d2s_loop
	movla .10
	sub d2s_d_tmp,m
	inc d2s_h_tmp,m
	sj d2s_d_tmp,10,d2s_end
	lgoto d2s_loop
	
d2s_end
	mov d2s_d_tmp,a
	movam d2s_l_tmp
	movla 0x30
	add d2s_h_tmp,m
	movla 0x30
	add d2s_l_tmp,m
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;send at+r to module for cmd
sint_getsms macro
	movla serial_buf_base
	movam BSR
	movla 0x61		;'a'
	movam INDF
	inc BSR,m
	movla 0x74		;'t'
	movam INDF
	inc BSR,m
	movla 0x2b		;'+'
	movam INDF
	inc BSR,m
	movla 0x72		;'r'
	movam INDF
	inc BSR,m

	movla 0x3d		;'='
	movam INDF
	inc BSR,m

	movla 0x31		;'1'
	movam INDF
	inc BSR,m
	

	movla 0x0d
	movam INDF
	inc BSR,m
	
;	clr INDF			;0
	clr BSR
	mycall fun_serial_send_string
	movla .5
	movam alarm_overflow1
	mycall fun_sint_get_result_wait

	;serial_send_string
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;after handle a cmd from module , send at+f to inform module
sint_sms_handle_finish macro
	movla serial_buf_base
	movam BSR
	movla 0x61		;'a'
	movam INDF
	inc BSR,m
	movla 0x74		;'t'
	movam INDF
	inc BSR,m
	movla 0x2b		;'+'
	movam INDF
	inc BSR,m
	movla 0x66		;'f'
	movam INDF
	inc BSR,m

	movla 0x0d
	movam INDF
	inc BSR,m
	
;	clr INDF			;0
	clr BSR
	mycall fun_serial_send_string
	movla .1
	movam alarm_overflow1
	mycall fun_sint_get_result_wait

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;sent at+a to module for open camera , purpose 1:for take a pic ,2:for record video
sint_enable_camera macro purpose
	movla serial_buf_base
	movam BSR
	movla 0x61		;'a'
	movam INDF
	inc BSR,m
	movla 0x74		;'t'
	movam INDF
	inc BSR,m
	movla 0x2b		;'+'
	movam INDF
	inc BSR,m
	movla 0x61		;'a'
	movam INDF
	inc BSR,m
	movla 0x3d		;'='
	movam INDF
	inc BSR,m

	movla 0x30		;purpose
	movam INDF
	movla purpose
	add INDF,m
	inc BSR,m

	movla 0x0d
	movam INDF
	inc BSR,m

	movla 0x0a
	movam INDF
	inc BSR,m

;	clr INDF			;0
	clr BSR
	mycall fun_serial_send_string
	;serial_send_string
	movla .5
	movam alarm_overflow1
	mycall fun_sint_get_result_wait
	bs my_status,module_camera_status

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;sent at+p<fun>,<index>to module for take a pic
sint_take_pic macro fun,index
	movla serial_buf_base
	movam BSR
	movla 0x61		;'a'
	movam INDF
	inc BSR,m
	movla 0x74		;'t'
	movam INDF
	inc BSR,m
	movla 0x2b		;'+'
	movam INDF
	inc BSR,m
	movla 0x70		;'p'
	movam INDF
	inc BSR,m
	movla 0x3d		;'='
	movam INDF
	inc BSR,m
	movla 0x31		;'1'
	movam INDF
	inc BSR,m
	movla 0x2c		;','
	movam INDF
	inc BSR,m

	movla .01		;;index ....
	movam d2s_d_tmp
	d2s
	mov d2s_h_tmp,a
	movam INDF
	inc BSR,m
	mov d2s_l_tmp,a
	movam INDF
	inc BSR,m

	movla 0x0d
	movam INDF
	inc BSR,m
	
;	clr INDF			;0
	clr BSR
;	serial_send_string	
	mycall fun_serial_send_string
	movla .5
	movam alarm_overflow1
	mycall fun_sint_get_result_wait

endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;sent at+v=<fun> to module for recording video
sint_record_video macro
	movla serial_buf_base
	movam BSR
	movla 0x61		;'a'
	movam INDF
	inc BSR,m
	movla 0x74		;'t'
	movam INDF
	inc BSR,m
	movla 0x2b		;'+'
	movam INDF
	inc BSR,m
	movla 0x76		;'v'
	movam INDF
	inc BSR,m
	movla 0x3d		;'='
	movam INDF
	inc BSR,m
	movla 0x31		;'1'
	movam INDF
	inc BSR,m

	movla 0x0d
	movam INDF
	inc BSR,m
	
;	clr INDF			;0
	clr BSR
;	serial_send_string	
	mycall fun_serial_send_string
	movla .20
	movam alarm_overflow1
	mycall fun_sint_get_result_wait

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;bulk sms 01~10	;int10int10 index have no use   it's sensor id
sint_send_sms macro number,index
	local sint_send_sms_end
	movla serial_buf_base
	movam BSR
	movla 0x61		;'a'
	movam INDF
	inc BSR,m
	movla 0x74		;'t'
	movam INDF
	inc BSR,m
	movla 0x2b		;'+'
	movam INDF
	inc BSR,m
	movla 0x73		;'s'
	movam INDF
	inc BSR,m
	movla 0x3d		;'='
	movam INDF
	inc BSR,m

	movla number		;number....
	movam d2s_d_tmp
	d2s
	mov d2s_h_tmp,a
	movam INDF
	inc BSR,m
	mov d2s_l_tmp,a
	movam INDF
	inc BSR,m

	movla 0x2c
	movam INDF
	inc BSR,m
;	movla index		;;index ....
	mov sensor_id,a
	movam d2s_d_tmp
	d2s
	mov d2s_h_tmp,a
	movam INDF
	inc BSR,m
	mov d2s_l_tmp,a
	movam INDF
	inc BSR,m

	movla 0x0d
	movam INDF
	inc BSR,m
	
;	clr INDF			;0
	clr BSR
;	serial_send_string		
	mycall fun_serial_send_string

	;receive command execute result....0:success ,1:fail...then receive sms send status,2:sucess 3:fail
	movla .255
	movam alarm_overflow1
	mycall fun_sint_get_result_wait

	enj fun_result,0x30,sint_send_sms_end
	movla .255
	movam alarm_overflow1
	mycall fun_sint_get_result_wait

sint_send_sms_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;bulk mms 01~10
sint_send_mms macro number,index
	local sint_send_mms_end
	movla serial_buf_base
	movam BSR
	movla 0x61		;'a'
	movam INDF
	inc BSR,m
	movla 0x74		;'t'
	movam INDF
	inc BSR,m
	movla 0x2b		;'+'
	movam INDF
	inc BSR,m
	movla 0x6d		;'m'
	movam INDF
	inc BSR,m
	movla 0x3d		;'='
	movam INDF
	inc BSR,m

	movla number		;number....
	movam d2s_d_tmp
	d2s
	mov d2s_h_tmp,a
	movam INDF
	inc BSR,m
	mov d2s_l_tmp,a
	movam INDF
	inc BSR,m

	movla 0x2c
	movam INDF
	inc BSR,m
	
	movla index		;;index ....
	movam d2s_d_tmp
	d2s
	mov d2s_h_tmp,a
	movam INDF
	inc BSR,m
	mov d2s_l_tmp,a
	movam INDF
	inc BSR,m

	movla 0x0d
	movam INDF
	inc BSR,m
	
;	clr INDF			;0
	clr BSR
	;serial_send_string
	mycall fun_serial_send_string

	;receive command execute result....0:success ,1:fail...then receive mms send status,2:sucess 3:fail
	movla .255
	movam alarm_overflow1
	mycall fun_sint_get_result_wait

	enj fun_result,0x30,sint_send_mms_end
	movla .255
	movam alarm_overflow1
	mycall fun_sint_get_result_wait

sint_send_mms_end	
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;dial out ,number place at dial_out_num
sint_dial_out macro
	local sint_dial_out_end,sint_dial_out_success,sint_dial_out_fail
	movla serial_buf_base
	movam BSR
	movla 0x61		;'a'
	movam INDF
	inc BSR,m
	movla 0x74		;'t'
	movam INDF
	inc BSR,m
	movla 0x2b		;'+'
	movam INDF
	inc BSR,m
	movla 0x64		;'d'
	movam INDF
	inc BSR,m
	movla 0x3d		;'='
	movam INDF
	inc BSR,m

	mov dial_out_num,a
	movam d2s_d_tmp
	d2s
	mov d2s_h_tmp,a
	movam INDF
	inc BSR,m
	mov d2s_l_tmp,a
	movam INDF
	inc BSR,m

	movla 0x2c
	movam INDF
	inc BSR,m
;	movla .1
	mov sensor_id,a
	movam d2s_d_tmp
	d2s
	mov d2s_h_tmp,a
	movam INDF
	inc BSR,m
	mov d2s_l_tmp,a
	movam INDF
	inc BSR,m

	movla 0x0d
	movam INDF
	
	
	;clr INDF			;0
	clr BSR
	;serial_send_string
	mycall fun_serial_send_string
	;ps:first ,it's command result..then communicate result

	movla .255
	movam alarm_overflow1
	mycall fun_sint_get_result_wait
	enj fun_result,0x30,sint_dial_out_fail
	movla .255
	movam alarm_overflow1
	mycall fun_sint_get_result_wait
	enj fun_result,0x33,sint_dial_out_fail

sint_dial_out_success
	movla 0x33
	movam fun_result
	lgoto sint_dial_out_end
sint_dial_out_fail
	movla 0x34
	movam fun_result
sint_dial_out_end
	
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;hang up
sint_hang_up macro 
	movla serial_buf_base
	movam BSR
	movla 0x61		;'a'
	movam INDF
	inc BSR,m
	movla 0x74		;'t'
	movam INDF
	inc BSR,m
	movla 0x2b		;'+'
	movam INDF
	inc BSR,m
	movla 0x68		;'h'
	movam INDF
	inc BSR,m

	movla 0x0d
	movam INDF
	inc BSR,m
	

;	clr INDF			;0
	clr BSR
	;serial_send_string
	mycall fun_serial_send_string

	movla .1
	movam alarm_overflow1
	mycall fun_sint_get_result_wait
	
endm

fun_init_stop_camera_par
	movla serial_buf_base
	movam BSR
	movla 0x61		;'a'
	movam INDF
	inc BSR,m
	movla 0x74		;'t'
	movam INDF
	inc BSR,m
	movla 0x2b		;'+'
	movam INDF
	inc BSR,m
	movla 0x6f		;'o'
	movam INDF
	inc BSR,m
	
	movla 0x0d
	movam INDF
	inc BSR,m

	clr BSR
	myret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;stop camera
sint_stop_camera macro 
	local sint_stop_camera_end
	btss my_status,module_camera_status
	lgoto sint_stop_camera_end

	mycall fun_init_stop_camera_par
	;serial_send_string
	mycall fun_serial_send_string

	movla .5
	movam alarm_overflow1
	mycall fun_sint_get_result_wait
	bc my_status,module_camera_status
sint_stop_camera_end
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get function result from module....timeout unit is S..
sint_get_result macro timeout

	movla timeout
	movam alarm_overflow1

	mycall fun_sint_get_result_wait
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;trigger_signal
trigger_signal macro
	;int10int10
	ir_scan
	btss my_status,ir_recevie_status
	lgoto trigger_signal_end
	bc my_status,ir_recevie_status
	;int10int10
;	movla .1
;	movam sensor_id

	;;;;;;;;;receive a trigger ......
	;enable camera and take a pic
	sint_stop_camera
	sint_enable_camera .1
	sint_take_pic .1,.01
	sint_stop_camera



	;bulk sms 00
ifdef SEND_SMS
	sint_send_sms .00,.01
endif
	
ifdef CHECK_SMS_BETWEEN_CALL
	;check whether receive sms
	btss test_sms
	lgoto trigger_signal_end
endif

	;bulk mms 00
	sint_send_mms .01,.01


	;;int10int10
	movla .10
	movam temp_buf
trigger_signal_dial_out_wait
	m_delay_ms .200
	decsz temp_buf,m
	lgoto trigger_signal_dial_out_wait



ifdef CHECK_SMS_BETWEEN_CALL
	;check whether receive sms
	btss test_sms
	lgoto trigger_signal_end
endif

	;;int10@090106   only when call end , start record..
	;sint_enable_camera .2
	;sint_record_video

	;dial out 01~02
	movla .03
	movam dial_out_counter

	;before dial out ,had better hand up first...
;	sint_hang_up
trigger_signal_dial_out_master
ifdef CHECK_SMS_BETWEEN_CALL
	btss test_sms
	lgoto trigger_signal_end
endif
	movla .1
	movam dial_out_num
	sint_dial_out
	ej fun_result,0x33,trigger_signal_end		;if receive 3, means somebody receive the call..



	
	sint_hang_up

ifdef CHECK_SMS_BETWEEN_CALL	
	btss test_sms
	lgoto trigger_signal_end
endif

	movla .2
	movam dial_out_num
	sint_dial_out
	ej fun_result,0x33,trigger_signal_end		;if receive 3, means somebody receive the call..

	sint_hang_up
	
	decsz dial_out_counter,m
	lgoto trigger_signal_dial_out_master
	
	
	;dial out 03~10
	movla .3
	movam dial_out_num
trigger_signal_dial_out_normal
ifdef CHECK_SMS_BETWEEN_CALL
	btss test_sms
	lgoto trigger_signal_end
endif
	sint_dial_out
	ej fun_result,0x33,trigger_signal_end		;if receive 3, means somebody receive the call..	
	sint_hang_up

	ej dial_out_num,.10,trigger_signal_end
	inc dial_out_num,m
	lgoto trigger_signal_dial_out_normal

	;;int10@090106
	sint_enable_camera .2
	sint_record_video
	
	
trigger_signal_end
nop
endm





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;check sms
sms_check macro
	btsc test_sms
	lgoto sms_check_end
	;;send atr
	sint_getsms
	;;;receive cmd
	;sint_get_result .3
	;nop

	;;;;cmd handle
	ej fun_result,0x23,sms_handle_jing
	ej fun_result,0x2a,sms_handle_xing
	ej fun_result,0x31,sms_handle_1
	ej fun_result,0x32,sms_handle_2
	lgoto sms_handle_end

	

sms_handle_0			;reset 
;	reset_module
	lgoto sms_handle_end
sms_handle_1 
	movla key_working_mode
	movam data_8l
	com data_8l,a
	movam data_8h
	movla custom_code
	movam custom_8l
	com custom_8l,a
	movam custom_8h
	nop
	;;need sendi ir about 10s
	movla .100
	movam alarm_overflow1
s1_ir_send_repeat
	ir_send
	m_delay_ms .30
	decsz alarm_overflow1,m
	lgoto s1_ir_send_repeat
	nop

	lgoto sms_handle_end

	
sms_handle_2
	movla key_idle_mode
	movam data_8l
	com data_8l,a
	movam data_8h
	movla custom_code
	movam custom_8l
	com custom_8l,a
	movam custom_8h
	nop
	;;need sendi ir about 10s
	movla .100
	movam alarm_overflow1
s2_ir_send_repeat
	ir_send
	m_delay_ms .30
	decsz alarm_overflow1,m
	lgoto s2_ir_send_repeat
	nop

	lgoto sms_handle_end
	
sms_handle_jing
	mov my_status,a
	movam my_status_backup
	sint_stop_camera
	sint_enable_camera .1
	sint_take_pic .1,.01
	sint_stop_camera

	sint_send_mms .01,.01

	;;int10int10
	movla .10
	movam temp_buf
sms_handle_jing_wait
	m_delay_ms .200
	decsz temp_buf,m
	lgoto sms_handle_jing_wait
	
	btss my_status_backup,module_camera_status
	lgoto sms_handle_end
	sint_enable_camera .2
	sint_record_video
	lgoto sms_handle_end
sms_handle_xing
	;;;stop alarm
	
	
	movla key_stop
	movam data_8l
	com data_8l,a
	movam data_8h
	movla custom_code
	movam custom_8l
	com custom_8l,a
	movam custom_8h	

	nop
	;;;need send ir about 10s
	movla .100
	movam alarm_overflow1
xing_ir_send_repeat
	ir_send
	m_delay_ms .30
	decsz alarm_overflow1,m
	lgoto xing_ir_send_repeat
	nop
	sint_stop_camera

	lgoto sms_handle_end
sms_handle_end
	sint_sms_handle_finish


sms_check_end

	;;;reset my watch dog
	movla my_wdt_overflow_const
	movam alarm_overflow1
	bc my_status,my_wdt_overflow
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;send string to module...
fun_serial_send_string
	movla serial_buf_base
	movam BSR

fun_serial_send_string_next_byte
	mov INDF,a
	movam send_data
	serial_send
	mov INDF,a
	movam send_data
	ej send_data,0x0d,fun_serial_send_string_end
	inc BSR,m
	lgoto fun_serial_send_string_next_byte
	
fun_serial_send_string_end
	clr BSR
	myret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;receive from module
fun_serial_receive_string
	;movla time_out_counter
	;movam alarm_overflow1
	;bc my_status,my_wdt_overflow
fun_serial_receive_wait_wait
	clrwdt
;	serial_receive
	serial_receive_string
;	mov receive_data,a
;	jnz fun_serial_receive_wait_end
	;btss my_status,serial_string_receive_status
	;lgoto fun_serial_receive_wait_wait
;	btsc my_status,serial_string_receive_status
;	lgoto fun_serial_receive_wait_end
;	btss my_status,my_wdt_overflow
;	lgoto fun_serial_receive_wait_wait
fun_serial_receive_wait_end
	myret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;receive a string from module
fun_sint_get_result_wait
	bc my_status,my_wdt_overflow
	start_tm0
fun_start_sint_get_result
	clrwdt
	serial_receive_string

	btsc my_status,my_wdt_overflow
	lgoto fun_sint_get_result_end
	btss my_status,serial_string_receive_status
	lgoto fun_start_sint_get_result

	;ps:an available result is only a byte data plus 0x0d 0x0a
	movla serial_buf_base
	movam BSR
	inc BSR,m
	enj	INDF,0x0d,fun_start_sint_get_result
	inc BSR,m
	enj INDF,0x0a,fun_start_sint_get_result


fun_sint_get_result_end
	stop_tm0
	myret




	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;delay function
;;the conter expresstion      (instruction_counter)*(instructions_per_circle) = (total_instruction)-4
;;ps:mk7a21p one instruction build by 2 system clock...  mk7a11p is 4 system clock

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 40us  
ifdef USE_CHIP_MK7A11P
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
	movla .139
	movam delay_counter	
delay_560us_loop
	clrwdt
	decsz delay_counter,m
	lgoto delay_560us_loop
delay_560us_end
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 1680us	 
delay_1680us
	movla .239
	movam delay_counter	
delay_1680us_loop
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	decsz delay_counter,m
	lgoto delay_1680us_loop
	clrwdt
	clrwdt
	clrwdt
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 1ms 
delay_1ms
	movla .249
	movam delay_counter
delay_1ms_loop
	clrwdt
	decsz delay_counter,m
	lgoto delay_1ms_loop
delay_1ms_end
	ret
endif


ifdef USE_CHIP_MK7A21P
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
	movla .186
	movam delay_counter	
delay_560us_loop
	clrwdt
	clrwdt
	clrwdt
	decsz delay_counter,m
	lgoto delay_560us_loop
delay_560us_end
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 1680us	 
delay_1680us
	movla .223
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
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 1ms 
delay_1ms
	movla .249
	movam delay_counter
delay_1ms_loop
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	decsz delay_counter,m
	lgoto delay_1ms_loop
delay_1ms_end
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	ret
endif


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;main function     it must write under the macro ,or it can't call the macro
main
	init_chip
	
	;receive 'w'
	sint_get_result .90




main_loop
	
	clrwdt
ifdef PC_CONNECTER
	;;;;trigger signal
;	trigger_signal
	;;;;check sms
	sms_check
endif



;	ir_scan
;	movla .2
;	movam dial_out_num
;	sint_dial_out
;	movla 0x61
;	movam send_data
;	serial_send
;	sint_at
;	serial_receive_string
;	serial_receive11
;	serial_send

	lgoto main_loop
	ret

end







