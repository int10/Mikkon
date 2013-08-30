;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Creat by int10@080304
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;use MK7A11P chip
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


#define USE_CHIP_MK7A11P
;#define USE_CHIP_MK6A11P


#include "mk7a11p.inc"

bit_ir_in			equ		PB2
bit_key_in		equ		PB0
bit_ir_out		equ		PB7
bit_shut_down	equ		PB5
bit_stb			equ		PA0
bit_reset		equ		PB6
bit_led			equ		PB1

#define	test_ir_in		PORTB,bit_ir_in
#define	test_key_in	PORTB,bit_key_in
#define	set_ir_out	PORTB,bit_ir_out
#define	test_shut_down	PORTB,bit_shut_down
#define	set_stb			PORTA,bit_stb
#define	set_reset			PORTB,bit_reset
#define	set_led			PORTB,bit_led


#define	iodir_porta		'00000110'
#define	iodir_portb		'11111111'


#define shut_down_counter			0xc8	;;;;.200 means 2s
#define custom_code				0x56

#define key_null					0x00
#define key_power					0x01
#define key_stop					0x02
#define key_funtion				0x03
#define key_up					0x04
#define key_down					0x05
#define key_left					0x06
#define key_right					0x07
#define key_enter					0x08
#define key_fun_hold				0x09
#define key_rec					0x0a
#define key_index					0x0b
#define key_pause					0x0c
#define key_k1					0x0d
#define key_k2					0x0e
#define key_k3					0x0f
#define key_tv_tft					0x10
#define key_volume_up				0x11
#define key_volume_down			0x12
#define key_hold					0x13
#define key_unhold				0x14
#define key_force_shut_down		0x15

#define key_usb_device_in			0x20
#define key_usb_device_out			0x21
#define key_usb_otg_in				0x22
#define key_usb_otg_out			0x23
#define key_rtc					0x24
#define key_ack_ok				0x25

#undefine key_power
#define key_power					0x0c

#define ir_in_pow_key				0x0c
#define ir_in_pow_key1				0x0b



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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;send a key
m_send_key macro custom,data
	movla custom
	movam custom_8l
	com custom_8l,a
	movam custom_8h
	movla data
	movam data_8l
	com data_8l,a
	movam data_8h
	lcall send_32_bit
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;change the power
pw_change macro
	local turn_on,turn_off,shut_down_check,shut_down_low,shut_down_high,turn_off_end,pw_change_end
	movla .1
	xor power_status,m		;;if it's on now ,turn off
	jz turn_off
turn_on
	;;;;;;turn on
	bs set_stb
	bc set_led
	m_delay_ms .100
	m_delay_ms .150
	bs set_reset
	movla .1
	movam power_status
	lgoto pw_change_end
	
turn_off
	;;;;turn off
	movla 0x40
	movam pw_off_counter

shut_down_check
	btsc test_shut_down
	lgoto shut_down_high

	movla .10
	movam shut_down_low_couter
shut_down_low
	m_delay_ms .50
	btsc test_shut_down		;if shut down is 1,go back to shut_down_check,must longer than 150ms can make the machine shut down
	lgoto shut_down_check
	decsz shut_down_low_couter,m
	lgoto turn_off_end
	lgoto shut_down_low
shut_down_high
	;;;avoid EM85xx don't receive the power key, so send power key to it always..
	m_send_key custom_code,key_power

	;wait 150ms
	m_delay_ms .150
	decsz pw_off_counter,m
	lgoto shut_down_check
turn_off_end				;change the stb...
	bc set_stb
	bs set_led
	bc set_reset
	movla .0
	movam power_status
pw_change_end
	endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;init the chip
;init_chip
init_chip macro
	;PortA端口方向及状态设定            
	movla      	b'00000110' ;pa0 is stb
	;movam temp_buf
	;bc temp_buf,bit_stb
	;mov temp_buf,a
	iodir         	porta 
	clr   		porta 
	clr          	pa_pdm 
	;------------------------------------------------------ 
	;PortB端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
	bc temp_buf,bit_reset
	bc temp_buf,bit_ir_out
	bc temp_buf,bit_led
	mov temp_buf,a
	iodir          	portb
	clr   		portb 
	clr          	pb_pod 
	clr          	pb_pdm 

	;;;;;;;;set pull up register
	movla b'11111111'
	bc temp_buf,bit_reset
	bc temp_buf,bit_ir_out
	bc temp_buf,bit_led
	mov temp_buf,a
	movam PB_PUP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;set ir_out pin set stb
	bc set_reset
	bs set_ir_out
	bc set_stb
	bs set_led

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
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan the ir			as a sample, use portb 0 as the ir in pin
;ir_scan					;it has only two stack level , so use macro instead function
ir_scan macro
	btsc test_ir_in		;;;;;;port b can use like this????????or must save it's status at a normal memery???
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
	movla .90			;avoid dead circle		high limit 90
	sub tm_counter_l,a
	jnc l_9ms
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
	movla .45			;avoid dead circle		high limit 45
	sub tm_counter_l,a
	jnc h_4ms
	lgoto ir_scan_end		;overflow
h_4ms_end
	movla .35			;low limit 35
	sub tm_counter_l,a
	jnc ir_scan_end

	;reset the data
	movla .0
	movam custom_8h
	movam custom_8l
	movam data_8h
	movam data_8l
	movam receive_data
	movla b'00000001'
	movam decode_mask
;	movla .4
;	movam byte_counter
	movla 0x33					;bsr point to custom_8l , after receive a byte , dec ,when it's 0x30,means receive done
	movam bsr


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
	movla .8					;avoid dead circle  high limit 8
	sub tm_counter_l,a
	jnc l_056ms
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
	movla .24				;avoid dead circle high limit 24
	sub tm_counter_l,a
	jnc h_1or0

	lgoto ir_scan_end			;overflow
h_1or0_end
	;receive a bit check the bit is 1 or 0
	movla .17				;>17 means receive 1 ...<17 means receive 0
	sub tm_counter_l,a
	jnc rec_a_bit

	mov decode_mask,a			;receive 1
	ior receive_data,m
	;receive 0 needn't any other operate
rec_a_bit
	;;;   *_*!!!!!     must clear status .c first...
	bc status,c
	rl decode_mask,m
	jc rec_a_byte
	lgoto data_code
rec_a_byte
	movla .1
	movam decode_mask

	mov receive_data,a
	movam indf
	clr receive_data
	
rec_a_byte_end
	mov bsr,a
	andla b'00111111'	;remove unuse bit
	xorla 0x30
	jz data_code_end
	dec bsr,m 
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
	bs ir_status,0
	
ir_scan_end
	;;;;;clear bsr
	clr bsr
endm
;	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;send ir repeat key		use temp_buf to save the pin status ...0means pin is low ,1 means pin is high
ir_repeat macro
	movla 0xa6		;timeout counter 150ms
	movam tm_counter_l
	movla 0x0e
	movam tm_counter_h
	movla .0
	movam temp_buf

ir_repeat_check
	btss test_ir_in
	lgoto ir_repeat_0
ir_repeat_1
	bs set_ir_out
	movla .1
	xor temp_buf,a
	jz ir_repeat_check_end

	movla .1
	movam temp_buf
	movla 0xa6		;timeout counter 150ms
	movam tm_counter_l
	movla 0x0e
	movam tm_counter_h
	lgoto ir_repeat_check_end
	
ir_repeat_0
	bc set_ir_out
	movla .0
	xor temp_buf,a
	jz ir_repeat_check_end

	movla .0
	movam temp_buf
	movla 0xa6		;timeout counter 150ms
	movam tm_counter_l
	movla 0x0e
	movam tm_counter_h
	lgoto ir_repeat_check_end
ir_repeat_check_end
	lcall delay_40us
	decsz tm_counter_l,m
	lgoto ir_repeat_check
	decsz tm_counter_h,m
	lgoto ir_repeat_check
	
ir_repeat_end
	endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;ir handle
ir_key_handle macro
	btss ir_status,0			;;have receive data or not..
	lgoto ir_key_handle_end
	clr ir_status
	movla ir_in_pow_key
	xor data_8l,a
	jz ir_pw_key
	movla ir_in_pow_key1
	xor data_8l,a
	jz ir_pw_key

	;;;;not power key
	lcall send_32_bit
	lgoto ir_start_repeat

ir_pw_key
	;;;power handle
	m_send_key custom_code,key_power
	pw_change
ir_start_repeat
	ir_repeat
ir_key_handle_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;shut down detect     detect the shut down pin......do it while power is on
shut_down_detect macro
	btss power_status,0
	lgoto shut_down_detect_end
	btsc test_shut_down
	lgoto shut_down_detect_end

	;lcall delay_10ms
	m_delay_ms .10

	btsc test_shut_down
	lgoto shut_down_detect_end
	
	movla .0
	movam tm_counter_l
shut_down_detect_count

	;lcall delay_10ms
	m_delay_ms .10
	btsc test_shut_down
	lgoto shut_down_detect_count_end
	inc tm_counter_l,m
	movla shut_down_counter
	sub tm_counter_l,a
	jc shut_down_time_out
	lgoto shut_down_detect_count
	
shut_down_detect_count_end
	movla .15					;150ms			>150ms   <2s send ack_ok
	sub tm_counter_l,a
	jnc shut_down_detect_end
	;;;;send key_ack_ok
	m_send_key custom_code,key_ack_ok
	lgoto shut_down_detect_end
	
	
shut_down_time_out			;time out ,shut down
	pw_change

shut_down_detect_end
	endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan key
;key_scan
key_scan macro
	btsc test_key_in
	lgoto key_scan_end
	;lcall delay_10ms
	m_delay_ms .80
	btsc test_key_in
	lgoto key_scan_end
	;;;;;;;;;;;;;;;;;;;;;;;;handle
	;;only handle the power key
	m_send_key custom_code,key_power
	pw_change
	lgoto wait_key_release
wait_key_release
	m_delay_ms .10
	btss test_key_in
	lgoto wait_key_release
	m_delay_ms .80
	btss test_key_in
	lgoto wait_key_release
key_scan_end
endm
;	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;send 32 bit data using philips order..		data place at custom_8h custom_8l data_8h data_8l
send_32_bit


	bc set_ir_out			;;;;;;;;;;;;;;;;;;;low 9ms
	m_delay_ms .9

	bs set_ir_out			;;;;;;;;;;;;;;;;;;;high 4ms
	m_delay_ms .4

	movla 0x33					;bsr point to 0x33, after send a byte ,dec ,when it's 0x30 ,means send done
	movam bsr
	
send_32_bit_prepare

	mov indf,a
	movam send_data

	;;;;;;start to send 8bit data
	movla .8
	movam bit_counter
send_a_bit
	rr send_data,m
	jc send_1
send_0
	bc set_ir_out
	lcall delay_560us
	bs set_ir_out
	lcall delay_560us
	lgoto send_a_bit_end
send_1
	bc set_ir_out
	lcall delay_560us
	bs set_ir_out
	lcall delay_1680us
send_a_bit_end
	decsz bit_counter,m
	lgoto send_a_bit
send_8_bit_end
	mov bsr,a
	andla b'00111111'	;remove unuse bit
	xorla 0x30
	jz send_32_bit_end
	dec bsr,m
	lgoto send_32_bit_prepare
	
send_32_bit_end
	;;;end
	;clear bsr
	clr bsr
	bc set_ir_out
	lcall delay_560us
	bs set_ir_out
	
	ret


ifdef USE_CHIP_MK7A11P
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 40us			4M..lcall and ret spent 4us,movla and movam spent 2us,clrwdt spent 0us,34us left...
;					ps when delay_counter=1,dec circle only spent 1us ,others (31~2) spent 3us
delay_40us
	clrwdt
	movla .12
	movam delay_counter
delay_40_us_loop
	decsz delay_counter,m
	lgoto delay_40_us_loop
delay_40us_end
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 100us			4M..lcall and ret spent 4us,movla and movam spent 2us,clrwdt spent 3us,91us left...
;					ps when delay_counter=1,dec circle only spent 1us ,others (31~2) spent 3us
delay_100us
	clrwdt
	movla .31
	movam delay_counter
delay_100_us_loop
	decsz delay_counter,m
	lgoto delay_100_us_loop
	clrwdt
	clrwdt
delay_100us_end
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 560us			4M..lcall and ret spent 4us,movla and movam spent 2us,clrwdt spent 0us,554us left...
;					ps when delay_counter=1,dec circle only spent 2us ,others (31~2) spent 4us
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
;;wait 1680us			4M..lcall and ret spent 4us,movla and movam spent 2us,clrwdt&nop spent 3us,1671us left...
;					ps when delay_counter=1,dec circle only spent 5us ,others (31~2) spent 7us
delay_1680us
	movla .239
	movam delay_counter	
delay_1680us_loop
	clrwdt
	nop
	nop
	nop
	decsz delay_counter,m
	lgoto delay_1680us_loop

	clrwdt
	nop
	nop
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 1ms			4M..lcall and ret spent 4us,movla and movam spent 2us,clrwdt&nop spent 0us,994us left...
;					ps when delay_counter=1,dec circle only spent 2us ,others (31~2) spent 4us
delay_1ms
	movla .249
	movam delay_counter
delay_1ms_loop
	clrwdt
	decsz delay_counter,m
	lgoto delay_1ms_loop
delay_1ms_end
	ret
endif		;USE_CHIP_MK7A11P


ifdef USE_CHIP_MK6A11P
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

endif			;USE_CHIP_MK6A11P

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;main function     it must write under the macro ,or it can't call the macro
main
	init_chip
main_loop
	clrwdt
	ir_scan
	ir_key_handle
	key_scan
	shut_down_detect

;	bs set_ir_out
;	lcall delay_1ms
;	nop
;	nop
;	bc set_ir_out
;	lcall delay_1ms
	
	lgoto main_loop
	ret

	
end





