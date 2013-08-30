;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Creat by int10@080304
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;use MK7A11P chip
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;it has only two level stack , had better reduce using lcall ,
;;so ,many function only call once at main function , 
;;I perfor macro to function...but pay attention:the macro 
;;must befor main function,or it can't be used...

;;ic bug...
; all number(0x00~0xff) - 0, C = 0  only mk7a21p have this bug....

#include "config.inc"

;配置寄存器设置说明（CONFIG） 
;1-----------FOSC=RC    ;LS,NS,HS,RC    
;2-----------INRC=ON    ;ON,OFF 
;3-----------CPT=ON    ;ON,OFF    
;4-----------WDTE=Enable   ;Enable,Disable 
;5-----------LV=Low Vol Reset ON  ;Low Vol Reset ON,Low Vol Reset OFF 
;6-----------RESET=...input...   ;...input...,...reset... 

#define fun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;memery map			;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


a_buf			equ   		0x40   		;acc缓存器 
status_buf		equ   		0x41   		;status缓存器 
temp_buf		equ			0x42
delay_counter	equ			0x43
tm_counter_l 	equ 			0x44			;counter , use to get the time
tm_counter_h 	equ 			0x45
pin_ir_in_status	equ			0x46

adc_tmp_value1	equ			0x47
adc_tmp_value2	equ			0x48
adc_tmp_value3	equ			0x49
adc_tmp_value4	equ			0x4a
adc_tmp_value5	equ			0x4b



custom_8h 		equ 			0x52;f						;custom code  ~custom
custom_8l 		equ 			0x53;f						;;;;;;custom data...
data_8h 		equ 			0x50			;7			;data code		~data
data_8l 			equ 			0x51		;d				;;;;;;data code

decode_mask			equ			0x54
ir_status				equ			0x55				;0:no received			1:have received
receive_data			equ			0x56
power_status			equ			0x57			;state of power...0:power off			1:power on
send_data				equ			0x58
bit_counter				equ			0x59
pw_off_counter			equ			0x5a
shut_down_low_couter	equ			0x5b
delay_ms_counter		equ			0x5c
usb_device_in			equ			0x5d
usb_device_out			equ			0x5e
adc_value				equ			0x5f
adc_key					equ			0x60
adc_save_key			equ			0x61
tab_offset				equ			0x62
key_loop_counter		equ			0x63
pw_key_delay_counter	equ			0x64
key_repeat_result		equ			0x65			;0:key can't repeat ,such as power  ,1:key can repeat ,such as up..
key_repeat_counter		equ			0x66
wdt_counter_h			equ			0x67
wdt_counter_l			equ			0x68
wdt_loop_counter		equ			0x69
wdt_status				equ			0x6a			;save the status of pin shut down
handshake_status		equ			0x6b


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;some macro
jnz macro position
	btss STATUS,Z
	lgoto position
endm


jnc macro position
	btss STATUS,C
	lgoto position
endm

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
;;;;;
mycall macro function
	lcall function
endm

myret macro
	ret
endm





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set main entery
org			0x000				;mk7a21p的复位向量地址定义 
lgoto		main				;跳转到主程序入口   
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
set_pins_following_standby macro horl
	local horl_0,set_pins_following_standby_end

	clra
	xorla horl
	jz horl_0
ifdef HenYu_PMP
	bs set_mute
endif ;HenYu_PMP
ifdef HY_LN041B
	bs set_mute
endif ;HY_LN041B
ifdef Matsunichi_PMP
	bs set_mute
endif

	lgoto set_pins_following_standby_end

horl_0
ifdef HenYu_PMP
	bc set_mute
endif ;HenYu_PMP
ifdef HY_LN041B
	bc set_mute
endif ;HY_LN041B
ifdef Matsunichi_PMP
	bc set_mute
endif


set_pins_following_standby_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;hand shake when start up				;;;;;;;;;;;
start_up_handshake macro
ifdef HAVE_START_UP_HANDSHAKE
	local handshake_wait_shutdown_to_low,handshake_low_count,handshake_fail,handshake_sucess,start_up_handshake_end,handshake_wait_shutdown_to_low_check
	clr tm_counter_l
	clr tm_counter_h
	
handshake_wait_shutdown_to_low
	m_delay_ms .10
	incsz tm_counter_l,m
	lgoto handshake_wait_shutdown_to_low_check
	inc tm_counter_h,m
	bj tm_counter_h,.24,handshake_fail			;if pin shutdown don't change to low in 1Min,means handshake fail..


handshake_wait_shutdown_to_low_check
	btsc test_shut_down
	lgoto handshake_wait_shutdown_to_low

	clr tm_counter_l
handshake_low_count
	m_delay_ms .10
	inc tm_counter_l,m
	bj tm_counter_l,.14,handshake_fail		;if pin shutdown stay low for longer than 140ms ,means handshake fail...
	btss test_shut_down
	lgoto handshake_low_count

	sj tm_counter_l,.03,handshake_fail		;if pin shutdown can't stay low for longer than 30ms ,means handshake fail...
	
	lgoto handshake_sucess

handshake_fail
	movla .1
	movam handshake_status
	lgoto start_up_handshake_end
handshake_sucess
	movla .0
	movam handshake_status

ifdef HY_LN041B			;HY_LN041B need send a key to 85XX/86XX ,differ from old version MCU
	m_send_key custom_code,key_wdt
endif


start_up_handshake_end
endif	;HAVE_START_UP_HANDSHAKE
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;init the chip
init_chip macro
	;PortA端口方向及状态设定            
	movla      	0xff
	movam temp_buf
	bc temp_buf,bit_stb
	bc temp_buf,bit_reset
	mov temp_buf,a
	movam PA_DIR
	clr   		PORTA
	clr          	PA_PLU
	;------------------------------------------------------ 
	;PortB端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
ifdef Umicore_LN090				;this project exchange ir in and ir out.
	bc temp_buf,bit_ir_out
endif
	mov temp_buf,a
	movam PB_DIR
	clr   		PORTB
	;------------------------------------------------------

	;PortC端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
ifndef Umicore_LN090				;this project exchange ir in and ir out.
	bc temp_buf,bit_ir_out
endif
	bc temp_buf,bit_mute
	mov temp_buf,a
	movam PC_DIR
	clr   		PORTC

	;;;;;;;;set pull up register
	movla b'11111111'
	movam temp_buf
;	bc temp_buf,bit_reset
;	bc temp_buf,bit_ir_out
	mov temp_buf,a
	movam PA_PLU
	movam PB_PLU
	movam PC_PLU
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;personal setting
ifdef Newage_DMB
	bc PA_DIR,PA2			;tv_bypass
	bc PORTA,PA2
endif

ifdef Matsunichi_PMP
	;;;;usb vbus needn't pull up
	movla b'11111111'
	movam temp_buf
	bc temp_buf,bit_usb_vbus
	mov temp_buf,a
	movam PA_PLU
endif

ifdef IPSTB_LN090
	;;;stb1,stb2
	bc PA_DIR,PA2
	bs set_stb1
	bc PB_DIR,PB3
	bs set_stb2
endif

ifdef Umicore_LN090
	;;;stb1,stb2
	bc PA_DIR,PA2
	bc set_stb1
	bc PB_DIR,PB3
	bc set_stb2
endif

ifdef INNOHILL_LN047NH_00		;much difference,had better write it independently...
	movla 0xff
	movam PA_DIR
	movam PB_DIR
	movam PC_DIR
	bc PC_DIR,bit_ir_out
	bc PA_DIR,bit_tx
	bc PB_DIR,bit_stb
	bc PA_DIR,bit_rst_per
	bc PA_DIR,bit_rst_sys
	clr PORTA
	clr PORTB
	clr PORTC
 
endif
ifdef INNOHILL_LN054IH10_010
	movla pa_dir_value
	movam PA_DIR
	movla pb_dir_value
	movam PB_DIR
	movla pc_dir_value
	movam PC_DIR
	clr PORTA
	clr PORTB
	clr PORTC
endif


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;set ir_out pin set stb
	bc set_reset
	bs set_ir_out
	bc set_stb
	;bs set_led
	set_pins_following_standby .0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;init wtd

	movla b'10000111'
	movam WDT_CTL

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;init some variable
	clr power_status
	clr ir_status
	clr usb_device_in
	clr usb_device_out
	clr handshake_status
	movla .32
	movam key_loop_counter
	movla .64
	movam wdt_loop_counter
	movla .6
	movam pw_off_counter

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;init soft wdt
	xor wdt_status,m
	;movla soft_wdt_idle_counter_const_l
	;movam wdt_counter_l
	;movla soft_wdt_idle_counter_const_h
	;movam wdt_counter_h
	clr wdt_counter_l
	clr wdt_counter_h

ifdef PowerUpAtStart

ifdef INNOHILL_LN054IH10_010
	;;;;set pwm period is about 2ms ,duty is 1:4
	movla b'01100111'
	movam TM2_CTL1
	movla b'10000000'
	movam TM2_CTL2
	movla b'11100111'
	movam TM3_CTL
	;movla 0ch        	;设置PWM的周期 
	movla 0x3f
	movam TM2_LA
	;movla 05h         	;设置PWM的占空比 
	movla 0xf
	movam TM3_LA
	bs TM2_CTL1,TM2_EN

	bs set_bm2
	adc_get_key
	enj adc_key,key_power,init_chip_pw_noral_on
	bc set_bm2			;;;power key is pushed.....
init_chip_pw_noral_on
endif	;INNOHILL_LN054IH10_010

	m_delay_ms .100
	mycall pw_change

ifdef INNOHILL_LN054IH10_010			;;;;;wait key_power release...
init_chip_wait_key_release
	m_delay_ms .80
	adc_get_key
	ej adc_key,key_power,init_chip_wait_key_release

endif	;INNOHILL_LN054IH10_010
endif	;PowerUpAtStart

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
	;movla .90			;avoid dead circle		high limit 90
	;sub tm_counter_l,a
	;jnc l_9ms
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
	;movla .45			;avoid dead circle		high limit 45
	;sub tm_counter_l,a
	;jnc h_4ms
	sj tm_counter_l,.45,h_4ms
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
	movam decode_mask
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

	mov decode_mask,a			;receive 1
	ior receive_data,m
	;receive 0 needn't any other operate
rec_a_bit
	;;;   *_*!!!!!     must clear status .c first...
	bc STATUS,C
ifdef USE_CHIP_MK7A21P
	rlc decode_mask,m
else
	rl decode_mask,m
endif
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
	bs ir_status,0
	
ir_scan_end
	;;;;;clear bsr
	clr BSR
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

ifdef HAVE_IR_PW_ON
	movla ir_in_pow_key
	xor data_8l,a
	jz ir_pw_key
	movla ir_in_pow_key1
	xor data_8l,a
	jz ir_pw_key
endif

	;;;;not power key
	lcall send_32_bit
	lgoto ir_start_repeat

ir_pw_key
	;;;power handle
	m_send_key custom_code,key_power
	;pw_change
	mycall pw_change
ir_start_repeat
	ir_repeat
ir_key_handle_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;shut down detect     detect the shut down pin......do it while power is on, and needn't do it every loop...do it per 64 loop
shut_down_detect macro
ifdef HAVE_SHUT_DOWN_DETECT
ifdef HAVE_SOFT_WDT
	btss power_status,0
	lgoto shut_down_detect_end
	decsz wdt_loop_counter,m
	lgoto shut_down_detect_end
	movla .64
	movam wdt_loop_counter
	
	btsc test_shut_down
	lgoto shut_down_h
	lgoto shut_down_l

shut_down_h
	;m_delay_ms .10
	;lcall delay_100us
	;btss test_shut_down
	;lgoto shut_down_detect_end
	
	btss wdt_status,0
	lgoto shut_down_detect_change
	;decsz wdt_counter_l,m
	;lgoto shut_down_detect_end
	;decsz wdt_counter_h,m
	;lgoto shut_down_detect_end

	incsz wdt_counter_l,m
	lgoto shut_down_detect_end
	inc wdt_counter_h,m
	;;;;time out , need reset machine
	ej wdt_counter_h,.8,shut_down_time_out
	lgoto shut_down_detect_end
	
	
	;lgoto shut_down_time_out
	
shut_down_l
	;m_delay_ms .10
	;lcall delay_100us
	;btsc test_shut_down
	;lgoto shut_down_detect_end
	
	btsc wdt_status,0
	lgoto shut_down_detect_change
	;decsz wdt_counter_l,m
	;lgoto shut_down_detect_end
	;decsz wdt_counter_h,m
	;lgoto shut_down_detect_end
	incsz wdt_counter_l,m
	lgoto shut_down_detect_end
	inc wdt_counter_h,m
	;;;;time out , need reset machine
	ej wdt_counter_h,.8,shut_down_time_out
	lgoto shut_down_detect_end

	;lgoto shut_down_time_out

shut_down_detect_change
	movla .1
	xor wdt_status,m
	;movla soft_wdt_idle_counter_const_l
	;movam wdt_counter_l
	;movla soft_wdt_idle_counter_const_h
	;movam wdt_counter_h

	enj wdt_counter_h,.0,not_pw_off_signal
	decsz pw_off_counter,m
	lgoto clear_wdt

	mycall pw_change
	lgoto shut_down_detect_end

not_pw_off_signal
	movla .6
	movam pw_off_counter
clear_wdt
	clr wdt_counter_l
	clr wdt_counter_h
	lgoto shut_down_detect_end

shut_down_time_out
	;;;;;;;;;before reset the machine ....clear wdt first..
	;movla soft_wdt_idle_counter_const_l
	;movam wdt_counter_l
	;movla soft_wdt_idle_counter_const_h
	;movam wdt_counter_h	
	clr wdt_counter_h
	clr wdt_counter_l
	reset_machine


else	;if not define HAVE_SOFT_WDT
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
	bj tm_counter_l,shut_down_counter,shut_down_time_out
	lgoto shut_down_detect_count
	
shut_down_detect_count_end
	lgoto shut_down_detect_end
	
shut_down_time_out			;time out ,shut down
	;pw_change
	mycall pw_change
endif	;HAVE_SOFT_WDT
shut_down_detect_end
endif
	endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;sort data		tm_counter_h contain compare rounds  , tm_counter_l contain compare times per round
sort_data macro start_pos,size
	local sort_data_next_time,sort_data_a_time_end,sort_data_end

	;;;;;;;;;;;;;;;;;;;;;;;;size must >0
	
	movla size
	xorla .0
	jz sort_data_end
	
	;;;;;init some var
	movla size
	movam tm_counter_h			;;;;;compare size-1 times

	movla start_pos
	movam BSR
	dec tm_counter_h,m
	mov tm_counter_h,a
	movam tm_counter_l

sort_data_next_time
	mov INDF,a
	inc BSR,m
	sub INDF,a
	jnc sort_data_a_time_end
	;;;swap the data
	mov INDF,a
	movam a_buf
	dec BSR,m
	mov INDF,a
	movam temp_buf
	mov a_buf,a
	movam INDF
	inc BSR,m
	mov temp_buf,a
	movam INDF

sort_data_a_time_end
	decsz tm_counter_l,m
	lgoto sort_data_next_time
	movla start_pos
	movam BSR
	dec tm_counter_h,m
	ej tm_counter_h,.0,sort_data_end
	mov tm_counter_h,a
	movam tm_counter_l
	lgoto sort_data_next_time
	
sort_data_end
	clr BSR
endm

ifdef USE_CHIP_MK7A21P		;only mk7a21p have adc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;read adc and return the value at adc_value
adc_get_value macro channel
	local adc_check_complete,adc_get_value_end,adc_get_value_delay
	movla 0xff
	movam adc_value
	clra
	xorla channel
	movam AD_CTL1

	movla .3			;;;;;System clock X128
	movam AD_CTL2
	
	movla b'00000001'			;;;;;;Bit3-0:PB0-3复用管脚的选择,做ADC用 
	movam AD_CTL3	

	clr AD_DAT
	bs AD_CTL1,EN

	movla .17
	movam tm_counter_l
adc_check_complete
	clrwdt
	lcall delay_40us
	btss AD_CTL1,7
	lgoto adc_get_value_end
	decsz tm_counter_l,m
	lgoto adc_check_complete
adc_get_value_end
	mov AD_DAT,a
	movam adc_value


	movla .4			;had better have 16 instruction nop before it go to next adc_get_value
	movam tm_counter_l
adc_get_value_delay
	decsz tm_counter_l,m
	lgoto adc_get_value_delay
	
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;after read adc 5 times ,use this function to get the best value...
adc_get_best_value macro
	local adc_get_best_value_loop,adc_get_best_value_next_compare,adc_get_best_value_not_equ,adc_get_best_value_next_compare_end
	local adc_get_best_value_error,adc_get_best_value_end
	movla adc_tmp_value1
	;movam BSR
	movam tm_counter_h	; save the start position , every time compare start here..
	clr tm_counter_l		;save the times of the value appear..

	mov tm_counter_h,a
	movam BSR
	inc tm_counter_h,m		;start with bsr+1...
adc_get_best_value_loop
	mov INDF,a			;;;save key value
	movam temp_buf		;;;
;	inc tm_counter_h		;;;set start position
	mov tm_counter_h,a
	movam BSR

adc_get_best_value_next_compare
	mov INDF,a
	xor temp_buf,a
	jnz adc_get_best_value_not_equ
	inc tm_counter_l,m		;;;;if equ
	movla .2
	xor tm_counter_l,a
	jz adc_get_best_value_end
adc_get_best_value_not_equ
	movla adc_tmp_value5
	xor BSR,a
	jz adc_get_best_value_next_compare_end
	inc BSR,m
	lgoto adc_get_best_value_next_compare

adc_get_best_value_next_compare_end
	movla adc_tmp_value4
	xor tm_counter_h,a
	jz adc_get_best_value_error
	mov tm_counter_h,a
	movam BSR
	inc tm_counter_h,m
	lgoto adc_get_best_value_loop

adc_get_best_value_error			;;no value is the best
	movla 0xff
	movam temp_buf
adc_get_best_value_end
	clr BSR
	mov temp_buf,a
	movam adc_value

endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;read adc 5 times and return the middle value at adc_value		
read_adc_5times macro channel
	local read_adc_5times_loop,read_adc_5times_read_end,read_adc_5times_end
	movla adc_tmp_value1
	movam BSR

read_adc_5times_loop
	adc_get_value channel
	mov adc_value,a
	movam INDF
	ej BSR,adc_tmp_value5,read_adc_5times_read_end
	inc BSR,m
	lgoto read_adc_5times_loop
	
read_adc_5times_read_end
	clr BSR
	adc_get_best_value

read_adc_5times_end
	clr BSR

endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;change the adc value to key value	,place the key at adc_key
adc_2_key macro
	local adc_2_key_next,adc_2_key_not_match,adc_2_key_match,adc_2_key_end
	movla .7
	movam TAB_BNK
	movla 0x50
	movam tab_offset

adc_2_key_next
	tabrdl tab_offset
	sub adc_value,a
	jc adc_2_key_not_match
	
	tabrdh tab_offset
	xorla .0						;;;;    all number(0x00~0xff) - 0, C = 0,don't know why.....but ,fuck,and only mk7a21p have this bug,11&11bp doesn't
	jz adc_2_key_match

	sub adc_value,a
	jc adc_2_key_match
adc_2_key_not_match
	movla .2
	add tab_offset,m
	lgoto adc_2_key_next
	
adc_2_key_match
	inc tab_offset,m
	tabrdl tab_offset
	movam adc_key
adc_2_key_end
endm

endif		;;;USE_CHIP_MK7A21P

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get a key	read from adc and change to key value ,result at adc_key
adc_get_key macro
	local adc_check_valid_data,adc_get_valid_data,adc_get_key_end

	movla key_null
	movam adc_key
	adc_get_value ch_adc_key


	ej adc_value,0xff,adc_get_key_end
	;;int10@080708   it seems the adc module is unstable,it always read error data..so had better read it twice to improve it ..
	adc_get_value ch_adc_key
	ej adc_value,0xff,adc_get_key_end
	m_delay_ms .80
	read_adc_5times ch_adc_key
	ej adc_value,0xff,adc_get_key_end


adc_get_valid_data					;now get the exact value
	adc_2_key

adc_get_key_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;power key handle
adc_power_key_handle macro
	local adc_power_key_handle_loop,adc_power_key_handle_false,adc_power_key_handle_true,adc_power_key_handle_end
	local adc_power_key_handle_release,adc_power_key_handle_check_double_kick,adc_power_key_handle_double_kick
	bs set_stb
	set_pins_following_standby .1

ifdef HAVE_POWER_KEY_DELAY
	movla .5
	movam pw_key_delay_counter
adc_power_key_handle_loop
	adc_get_key
	enj adc_key,key_power,adc_power_key_handle_false
	m_delay_ms .100
	decsz pw_key_delay_counter,m
	lgoto adc_power_key_handle_loop
	lgoto adc_power_key_handle_true

	
adc_power_key_handle_false		;it's not a true power key
	btsc power_status,0
	lgoto adc_power_key_handle_end
	bc set_stb
	set_pins_following_standby .0
	lgoto adc_power_key_handle_end
adc_power_key_handle_true
endif
ifdef HAVE_FORCE_PW_DOWN
	btss power_status,0
	lgoto adc_power_key_handle_true
	movla .50
	movam pw_key_delay_counter
adc_power_key_handle_loop
	adc_get_key
	enj adc_key,key_power,adc_power_key_handle_true
	m_delay_ms .100
	decsz pw_key_delay_counter,m
	lgoto adc_power_key_handle_loop
	bc set_stb
	set_pins_following_standby .0
	bc set_reset
	movla .0
	movam power_status	
	lgoto adc_power_key_handle_end
adc_power_key_handle_true
endif

ifdef INNOHILL_LN054IH10_010
;Single kick when STB mode to power on
;Double kick in one second to RESET
;Long push over three seconds to Standby
	btss power_status,0
	lgoto adc_power_key_handle_true
	movla .30
	movam pw_key_delay_counter
adc_power_key_handle_loop
	adc_get_key
	enj adc_key,key_power,adc_power_key_handle_release
	m_delay_ms .100
	decsz pw_key_delay_counter,m
	lgoto adc_power_key_handle_loop
	bc set_stb
	set_pins_following_standby .0
	bc set_reset
	movla .0
	movam power_status
	lgoto adc_power_key_handle_end

adc_power_key_handle_release
	movla .100
	movam pw_key_delay_counter
adc_power_key_handle_check_double_kick
	adc_get_key
	ej adc_key,key_power,adc_power_key_handle_double_kick
	enj adc_key,key_null,adc_power_key_handle_end
	m_delay_ms .10
	decsz pw_key_delay_counter,m
	lgoto adc_power_key_handle_check_double_kick	
	lgoto adc_power_key_handle_end

adc_power_key_handle_double_kick		;;;do some reset..
	bc set_reset
	m_delay_ms .50
	bs set_reset
	lgoto adc_power_key_handle_end



adc_power_key_handle_true

endif

	m_send_key custom_code,key_power
	;pw_change
	mycall pw_change
adc_power_key_handle_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;adc key mapping
adc_key_mapping macro
	local adc_power_key,adc_key_mapping_end
	ej adc_key,key_null,adc_key_mapping_end
	ej adc_key,key_power,adc_power_key

	;;not power key
	movla custom_code
	movam custom_8l
	com custom_8l,a
	movam custom_8h
	mov adc_key,a
	movam data_8l
	com data_8l,a
	movam data_8h
	lcall send_32_bit
	lgoto adc_key_mapping_end
adc_power_key
	adc_power_key_handle
	lgoto adc_key_mapping_end
adc_key_mapping_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;check whether the key can repeat , the key place at adc_key , result place at key_repeat_result
key_check_repeat macro
ifdef HAVE_PANEL_REPEAT
	local key_check_repeat_next,key_check_repeat_found,key_check_repeat_end
	clr key_repeat_result
	movla 0x07
	movam TAB_BNK
	movla 0x80
	movam tab_offset

key_check_repeat_next
	tabrdl tab_offset
	xorla key_null
	jz key_check_repeat_end
	
	tabrdl tab_offset
	xor adc_key,a
	jz key_check_repeat_found
	inc tab_offset,m
	lgoto key_check_repeat_next
	
key_check_repeat_found
	bs key_repeat_result,0
key_check_repeat_end
endif
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan key
key_scan macro

ifdef HAVE_KEY_HOLP
	btss test_key_holp
	lgoto key_scan_end
endif
	;because adc convert spent almost 660us one time , it seem a little too long to do it every loop , so had better do it one time per 32 loop..
	
	decsz key_loop_counter,m
	lgoto key_scan_end
	movla .32
	movam key_loop_counter
	adc_get_key
	adc_key_mapping

	mov adc_key,a
	movam adc_save_key

	mov adc_key,a
	xorla key_null
	jz key_scan_end
	
	movla .10
	movam key_repeat_counter
wait_key_release
	adc_get_key
	mov adc_key,a
	xor adc_save_key,a
	jnz key_scan_end
	key_check_repeat
	btss key_repeat_result,0
	lgoto wait_key_release
	mov key_repeat_counter,a
	xorla .0
	jz key_scan_repeat
	dec key_repeat_counter,m
	lgoto wait_key_release
key_scan_repeat	
	adc_key_mapping
	lgoto wait_key_release

key_scan_end

endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;detect the usb
usb_detect macro
ifdef HAVE_USB_DETECT
ifdef USB_IR_MESSAGE
	btss power_status,0		;do it while power is on
	lgoto usb_detect_end
	btsc test_usb_vbus
	lgoto usb_in
usb_out

	bj usb_device_out,.3,usb_detect_end
	movla 0x0f
	movam tm_counter_l
	
usb_out_count
	btsc test_usb_vbus
	lgoto usb_detect_end
	m_delay_ms .20
	decsz tm_counter_l,m
	lgoto usb_out_count
	m_send_key custom_code,key_usb_device_out
	inc usb_device_out,m
	clr usb_device_in
	lgoto usb_detect_end

usb_in

	bj usb_device_in,.3,usb_detect_end
	movla 0x0f
	movam tm_counter_l
	
usb_in_count
	btss test_usb_vbus
	lgoto usb_detect_end
	m_delay_ms .20
	decsz tm_counter_l,m
	lgoto usb_in_count
	m_send_key custom_code,key_usb_device_in
	inc usb_device_in,m
	clr usb_device_out
usb_detect_end	
endif			;USB_IR_MESSAGE
endif			;HAVE_USB_DETECT

endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;detect alarm power on pin
alarm_on_detect macro
ifdef HAVE_RTC_AUTO_PW_ON
	btsc power_status,0		;do it while power is off
	lgoto alarm_on_detect_end
	btsc test_alarm
	lgoto alarm_on_detect_end
	;pw_change
	mycall pw_change
alarm_on_detect_end
endif
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;reset 85XX/86XX...
reset_machine macro
	bc set_stb
	set_pins_following_standby .0
	bc set_reset
	m_delay_ms .200
	
	bs set_stb
	set_pins_following_standby .1
	m_delay_ms .100
	m_delay_ms .150
	bs set_reset

	start_up_handshake

	btss handshake_status,0
	lgoto reset_machine_end
	;;;;;;;;;hand shake fail,power off
	bc set_stb
	set_pins_following_standby .0
	bc set_reset
	movla .0
	movam power_status
	

reset_machine_end
endm


rst_ice_detect macro
ifdef INNOHILL_LN047NH_00
	btss power_status,0		;do it while power is on
	lgoto rst_ice_detect_end
	btsc test_rst_ice
	lgoto rst_ice_detect_end
	lcall delay_100us
	btsc test_rst_ice
	lgoto rst_ice_detect_end
	bc set_rst_sys
	m_delay_ms .80
	bs set_rst_sys
rst_ice_detect_end
endif

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;change the power
pw_change fun
	;local turn_on,turn_off,shut_down_check,shut_down_low,shut_down_high,turn_off_end,pw_change_end,shut_down_change
	movla .1
	xor power_status,m		;;if it's on now ,turn off
	jz turn_off
turn_on
	;;;;;;turn on
	bs set_stb
ifdef IPSTB_LN090
	m_delay_ms .80
	bc set_stb1
	m_delay_ms .80
	bc set_stb2
endif

ifdef Umicore_LN090
	m_delay_ms .80
	bs set_stb1
	m_delay_ms .80
	bs set_stb2
endif

	set_pins_following_standby .1
	m_delay_ms .250
	bs set_reset
	
ifdef INNOHILL_LN047NH_00
	m_delay_ms .80
	bs set_rst_per
endif

	start_up_handshake
	ej handshake_status,1,turn_off_end		;hand shake fail ,turn off machine...
	
	movla .1
	movam power_status
	lgoto pw_change_end
	
turn_off
ifdef HY_LN041B
	;;;;turn off
	movla 0x06
	movam pw_off_counter
	clr tm_counter_l

shut_down_check
	btsc test_shut_down
	lgoto shut_down_high
	lgoto shut_down_low
shut_down_low
	lcall delay_100us
	btsc test_shut_down
	lgoto shut_down_check
	btsc wdt_status,0
	lgoto shut_down_change
	inc tm_counter_l,m
	m_delay_ms .50
	bj tm_counter_l,.200,turn_off_end
	lgoto shut_down_check
	

shut_down_high
	lcall delay_100us
	btss test_shut_down
	lgoto shut_down_check
	btss wdt_status,0
	lgoto shut_down_change
	inc tm_counter_l,m
	m_delay_ms .50
	bj tm_counter_l,.200,turn_off_end
	lgoto shut_down_check

shut_down_change
	ej tm_counter_l,0,shut_down_check
	clr tm_counter_l
	decsz pw_off_counter,m
	lgoto shut_down_check
	lgoto turn_off_end
else
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
endif
turn_off_end				;change the stb...
	bc set_stb
ifdef IPSTB_LN090
	bs set_stb1
	bs set_stb2
endif

ifdef Umicore_LN090
	bc set_stb1
	bc set_stb2
endif

ifdef INNOHILL_LN047NH_00
	bc set_rst_per
endif

	;bs set_led
	set_pins_following_standby .0
	bc set_reset
	movla .0
	movam power_status
pw_change_end
	myret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;send 32 bit data using philips order..		data place at custom_8h custom_8l data_8h data_8l
send_32_bit fun


	bc set_ir_out			;;;;;;;;;;;;;;;;;;;low 9ms
	m_delay_ms .9

	bs set_ir_out			;;;;;;;;;;;;;;;;;;;high 4ms
	m_delay_ms .4

	movla custom_8l		;bsr point to 0x33, after send a byte ,dec ,when it's 0x30 ,means send done
	movam BSR
	
send_32_bit_prepare

	mov INDF,a
	movam send_data

	;;;;;;start to send 8bit data
	movla .8
	movam bit_counter
send_a_bit
ifdef USE_CHIP_MK7A21P
	rrc send_data,m
else
	rr send_data,m
endif
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
	mov BSR,a
	xorla data_8h
	jz send_32_bit_end
	dec BSR,m
	lgoto send_32_bit_prepare
	
send_32_bit_end
	;;;end
	;clear bsr
	clr BSR
	bc set_ir_out
	lcall delay_560us
	bs set_ir_out
	
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;delay function
;;the conter expresstion      (instruction_counter)*(instructions_per_circle) = (total_instruction)-4
;;ps:mk7a21p one instruction build by 2 system clock...  mk7a11p is 4 system clock

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 40us  
delay_40us
;	clrwdt
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
;	clrwdt
	movla const_delay_100us
	movam delay_counter
delay_100_us_loop
	clrwdt
	decsz delay_counter,m
	lgoto delay_100_us_loop
;	clrwdt
;	clrwdt
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
main_loop
	clrwdt
	ir_scan
	ir_key_handle
	key_scan
	usb_detect
	shut_down_detect
	alarm_on_detect
	rst_ice_detect

	
	lgoto main_loop
	ret

ifdef USE_EMULATER
;org 0x0700
;dw			0x0005
;dw			key_power
;dw			0x9aa4
;dw			key_stop
;dw			0xf6fc
;dw			key_up
;dw			0xe2ec
;dw			key_down
;dw			0xd1db
;dw			key_left
;dw			0xc2cc
;dw			key_right
;dw			0xacb6
;dw			key_enter
;dw			0x00ff			;all data match...
;dw			key_null			;end .......
else		;USE_EMULATER
org 0x0750
;dw			0x0005
;dw			key_power
;dw			0x959f
;dw			key_stop
;dw			0xebf5
;dw			key_up
;dw			0xdbe5
;dw			key_down
;dw			0xcbd5
;dw			key_left
;dw			0xbbc5
;dw			key_right
;dw			0xa7b1
;dw			key_enter

ifdef Matsunichi_PMP
dw			0x0001
dw			key_power
dw			0x5862
dw			key_stop
dw			0x0105
dw			key_up
dw			0x131d
dw			key_down
dw			0x242e
dw			key_left
dw			0x343e
dw			key_right
dw			0x4a54
dw			key_enter
dw			0x6a74
dw			key_menu
dw			0x838d
dw			key_fun1
dw			0x97a1
dw			key_fun2
dw			0xa5af
dw			key_fun3
dw			0xb6c0
dw			key_fun4
dw			0xc9d3
dw			key_fun5
dw			0xd9e3
dw			key_fun6
dw			0xebf5
dw			key_fun7
dw			0xf9fe
dw			key_fun8			
dw			0x00ff			;all data match...
dw			key_null			;end .......
else
dw			0x0005
dw			key_power
dw			0x959f
dw			key_stop
dw			0xebf5
dw			key_up
dw			0xdbe5
dw			key_down
dw			0xcbd5
dw			key_left
dw			0xbbc5
dw			key_right
dw			0xa7b1
dw			key_enter
dw			0x00ff			;all data match...
dw			key_null			;end .......
endif
endif	;USE_EMULATER

ifdef HAVE_PANEL_REPEAT
org 0x780
dw			key_up
dw			key_down
dw			key_right
dw			key_left
dw			key_null
else
org 0x780
dw			key_null			;end.....
endif
	
end





