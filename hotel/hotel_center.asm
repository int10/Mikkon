;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Creat by int10@110111
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;use MK7A25P chip

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CHIPSET;;;;;;;;;;;;;;;;;;;;;;

;#define USE_CHIP_MK7A21P
#define USE_CHIP_MK7A25P
;#define USE_EMULATOR
#include "mk7a21p.inc"

#define fun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROJECT;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;CHANGE SOME KEY WORDS TO MK7A11P , FOR USE ONE CODE TO HANDLE THE TWO CHIP ;;;;;;;;;;;
#define PORTB PB_DAT
#define PORTA PA_DAT
#define PORTC PC_DAT
#define BSR FSR


bit_ir_in				equ		PA2
bit_txd				equ		PA3
bit_rxd				equ		PA4
bit_led_pwm_1		equ		PC0
bit_caution_fin		equ		PC2
bit_caution_rin		equ		PC3


#define test_ir_in			PORTA,bit_ir_in
#define set_tx				PORTA,bit_txd
#define test_rx			PORTA,bit_rxd
#define set_led_pwm_1	PORTC,bit_led_pwm_1
#define set_ir_out			0xbf,7
#define set_caution_fin		PORTC,bit_caution_fin
#define set_caution_rin	PORTC,bit_caution_rin

pa_dir_value			equ b'11110111'
pb_dir_value			equ b'11111111'
pc_dir_value			equ b'11110010'
pa_plu_value			equ b'11111111'
pb_plu_value			equ b'11110111'
pc_plu_value			equ b'11111111'




#define ch_vcc_bat			0x00

ifdef USE_EMULATOR
else
endif

#define pwm_500hz_per			0x3e
#define pwm_500hz_10_duty		0x06
#define pwm_500hz_20_duty		0x0c
#define pwm_500hz_30_duty		0x12
#define pwm_500hz_40_duty		0x19
#define pwm_500hz_50_duty		0x1f
#define pwm_500hz_60_duty		0x25
#define pwm_500hz_70_duty		0x2b
#define pwm_500hz_80_duty		0x32
#define pwm_500hz_90_duty		0x38

#define ir_key_up			0x0a
#define ir_key_down		0x1e


;my_status define 
ir_recevie_status			equ	0
key_long_press_status		equ	1
charge_en					equ	2
iphone_in					equ	3
serial_receive_status		equ	4
tm1_running					equ	5
tm1_overflow				equ	6
serial_string_receive_status		equ 7


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;delay const

#define const_delay_40us		.19
#define const_delay_100us		.49
#define const_delay_560us		.111
#define const_delay_1680us		.167
#define const_delay_1ms		.199

#define dev_type_light				0
#define dev_type_caution			1
#define dev_type_unkonwn		2


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;memery map			;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

a_buf			equ   		0x40   		;acc缓存器 
status_buf		equ   		0x41   		;status缓存器 
temp_buf		equ			0x42
delay_counter	equ			0x43
tm_counter_l 	equ 			0x44			;counter , use to get the time
tm_counter_h 	equ 			0x45
my_status		equ			0x46
adc_tmp_value1	equ			0x47
adc_tmp_value2	equ			0x48
adc_tmp_value3	equ			0x49
adc_tmp_value4	equ			0x4a
adc_tmp_value5	equ			0x4b
tm1_counter_h	equ			0x4c
tm1_counter_l	equ			0x4d
enc_scan_status	equ			0x4e			;0:idle    1:enc a touch		2:enc b touch



custom_8h 		equ 			0x52;f						;custom code  ~custom
custom_8l 		equ 			0x53;f						;;;;;;custom data...
data_8h 		equ 			0x50			;7			;data code		~data
data_8l 			equ 			0x51		;d				;;;;;;data code

value_mask			equ			0x54
receive_data			equ			0x55
send_data				equ			0x56
bit_counter				equ			0x57

eeprom_byte_counter	equ			0x58
eeprom_operate_addr_h	equ			0x59
eeprom_operate_addr_l	equ			0x5a



delay_ms_counter		equ			0x5c
adc_long_press_value	equ			0x5d
adc_long_press_counter	equ			0x5e
adc_value				equ			0x5f
adc_key					equ			0x60
adc_save_key			equ			0x61
tab_offset				equ			0x62
key_loop_counter		equ			0x63
pw_key_delay_counter	equ			0x64
key_repeat_result		equ			0x65			;0:key can't repeat ,such as power  ,1:key can repeat ,such as up..
key_repeat_counter		equ			0x66
c595_data_h			equ			0x67
c595_data_l				equ			0x68
c595_mask_h			equ			0x69
c595_mask_l			equ			0x6a
c595_save_key			equ			0x6b
c595_tm1_counter_h		equ			0x6c
c595_tm1_counter_l		equ			0x6d
pt2314_trans_value		equ			0x6e
volume_value			equ			0x6f
pt2314_channel			equ			0x70
cs8416_oper_addr		equ			0x71
cs8416_value			equ			0x72
cs485xx_byte_counter	equ			0x73

i2c_buf					equ			0x75
i2c_ack_counter			equ			0x76
i2c_status				equ			0x77

ir_custom_code			equ			0x78
cur_light_level			equ			0x79
pwm_period				equ			0x7a
pwm_duty				equ			0x7b
dev_id					equ			0x7c
dev_type				equ			0x7d


serial_buf_start			equ			0xa0
serial_buf_end			equ			0xaf
dsp_down_start_addr_h		equ			0xa0
dsp_down_start_addr_l		equ			0xa1
dsp_block_size_h		equ			0xa2
dsp_block_size_l		equ			0xa3
cmd_value			equ			0xa0






tttt1			equ 0xa0
tttt2			equ 0xa1
tttt3			equ 0xa2
tttt4			equ 0xa3
tttt5			equ 0xa4
tttt6			equ 0xa5
tttt7			equ 0xa6
tttt8			equ 0xa7


memery_end			equ			0xbf				;it's the end of memery...don't use 0xbf,it use to do anything unuse set....



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set main entery
org			0x000				;mk7a21p的复位向量地址定义 
lgoto		main				;跳转到主程序入口   
org			0x004
lgoto		int_entry				;int entry
org 			0x0010


#include "util.asm"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start tm1
start_tm1 macro
	local start_tm1_end
	btsc my_status,tm1_running
	lgoto start_tm1_end
	;;init variable
	movla b'01100111'
	movam tm1_ctl1       	;TM1时钟源内部RC时钟,预分频1:128
	movla 0x09 
	movam tm1l_la 
	movla 0x3d
	movam tm1h_la  	;溢出周期500ms
	
	;movla b'10000010' 	;以下是中断设置 
	;movam irqm
	bs IRQM,TM1M
	en_int
	;clr irqf 
	bc IRQF,TM1F
	bs tm1_ctl1,7
	bs my_status,tm1_running
start_tm1_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;stop tm1
stop_tm1 macro
	bc TM1_CTL1,7
	bc IRQM,TM1M
	;clr IRQF
	bc IRQF,TM1F
	bc my_status,tm1_running
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;tm1 int
int_tm1 macro

	bc IRQF,TM1F
	;;;add the code below

;	dec tm1_counter_l,m
;	jnz int_tm1_end
;	ej tm1_counter_h,0x00,int_tm1_overflow
;	dec tm1_counter_h,m
;	lgoto int_tm1_end
int_tm1_overflow
	bs my_status,tm1_overflow
	led_center
int_tm1_end
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;pa int
int_pa macro
	bc IRQF,PAF
int_pa_end

endm




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;stop pwm output
stop_pwm macro
	clr TM2_CTL1
	clr TM2_CTL2
	clr TM3_CTL
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start pwm output , TM2 prescaler rate is 1:128,and PWM prescaler is 1:1..TM3 prescaler rate is 1:128.......L_period=time/((1/4)*128)	time is us level  L_duty=L_period*duty/100
start_pwm macro 
	;stop_pwm
	movla b'01100111'
	movam TM2_CTL1
	movla b'10000000'
	movam TM2_CTL2
	movla b'11100111'
	movam TM3_CTL
	;movla 0x9c        	;设置PWM的周期 
	mov pwm_period,a
	movam TM2_LA
	;movla 0x2f         	;设置PWM的占空比 
	mov pwm_duty,a
	movam TM3_LA
	bs TM2_CTL1,TM2_EN
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start pwm ouput ,default TM2 prescaler rate is 1:128,and PWM prescaler is 1:1..TM3 prescaler rate is 1:128.......L_period=time/((1/4)*128)		time is us level  L_duty=
start_pwm_ex macro L_period,L_duty
	movla L_period
	movam pwm_period
	movla L_duty
	movam pwm_duty
	start_pwm
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;enable pa int
enable_pa_int macro
	dis_int
	bs INTM,PAM
	;bs PA_INTE,bit_i_det
	;bs PA_INTE,bit_key_in
	bs PA_INTE,bit_ir_in
	bc IRQF,PAF
	en_int
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get pwm data accounding to cur_light_level
bright_get_pwm_data macro
	local bright_get_pwm_data_0,bright_get_pwm_data_1,bright_get_pwm_data_2,bright_get_pwm_data_3,bright_get_pwm_data_4,bright_get_pwm_data_5
	local bright_get_pwm_data_6,bright_get_pwm_data_7,bright_get_pwm_data_8,bright_get_pwm_data_9,bright_get_pwm_data_10,bright_get_pwm_data_end
 
	movla pwm_500hz_per
	movam pwm_period
	ej cur_light_level,.0,bright_get_pwm_data_0
	ej cur_light_level,.1,bright_get_pwm_data_1
	ej cur_light_level,.2,bright_get_pwm_data_2
	ej cur_light_level,.3,bright_get_pwm_data_3
	ej cur_light_level,.4,bright_get_pwm_data_4
	ej cur_light_level,.5,bright_get_pwm_data_5
	ej cur_light_level,.6,bright_get_pwm_data_6
	ej cur_light_level,.7,bright_get_pwm_data_7
	ej cur_light_level,.8,bright_get_pwm_data_8
	ej cur_light_level,.9,bright_get_pwm_data_9
	ej cur_light_level,.10,bright_get_pwm_data_10
	movla 0
	movam cur_light_level
bright_get_pwm_data_0
	movla 0
	movam pwm_duty
	lgoto bright_get_pwm_data_end
bright_get_pwm_data_1
	movla pwm_500hz_10_duty
	movam pwm_duty
	lgoto bright_get_pwm_data_end
bright_get_pwm_data_2
	movla pwm_500hz_20_duty
	movam pwm_duty
	lgoto bright_get_pwm_data_end
bright_get_pwm_data_3
	movla pwm_500hz_30_duty
	movam pwm_duty
	lgoto bright_get_pwm_data_end
bright_get_pwm_data_4
	movla pwm_500hz_40_duty
	movam pwm_duty
	lgoto bright_get_pwm_data_end
bright_get_pwm_data_5
	movla pwm_500hz_50_duty
	movam pwm_duty
	lgoto bright_get_pwm_data_end
bright_get_pwm_data_6
	movla pwm_500hz_60_duty
	movam pwm_duty
	lgoto bright_get_pwm_data_end
bright_get_pwm_data_7
	movla pwm_500hz_70_duty
	movam pwm_duty
	lgoto bright_get_pwm_data_end
bright_get_pwm_data_8
	movla pwm_500hz_80_duty
	movam pwm_duty
	lgoto bright_get_pwm_data_end
bright_get_pwm_data_9
	movla pwm_500hz_90_duty
	movam pwm_duty
	lgoto bright_get_pwm_data_end
bright_get_pwm_data_10
	movla 0xff
	movam pwm_duty
	lgoto bright_get_pwm_data_end

bright_get_pwm_data_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set led info
start_led_show macro
	local start_led_show_dark,start_led_show_br,start_led_show_normal,start_led_show_end
	stop_pwm
	ej pwm_duty,0,start_led_show_dark
	ej pwm_duty,0xff,start_led_show_br
	lgoto start_led_show_normal
start_led_show_dark
	bc set_led_pwm_1
	lgoto start_led_show_end
start_led_show_br
	bs set_led_pwm_1
	lgoto start_led_show_end
start_led_show_normal
	start_pwm
start_led_show_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;led brightness down....
bright_down macro
	ej cur_light_level,0,bright_down_end
	dec cur_light_level,m
	bright_get_pwm_data
	start_led_show
bright_down_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;led brightness up.....
bright_up macro
	ej cur_light_level,.10,bright_up_end
	inc cur_light_level,m
	bright_get_pwm_data
	start_led_show
bright_up_end
endm

#include "irDrv.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;handle down key
key_handle_down macro
	ej dev_type,dev_type_light,key_handle_down_light
	ej dev_type,dev_type_caution,key_handle_down_caution
	lgoto key_handle_down_end
key_handle_down_light
	bright_down
	lgoto key_handle_down_end
key_handle_down_caution
	bc set_caution_fin
	bs set_caution_rin
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	bc set_caution_fin
	bc set_caution_rin
	lgoto key_handle_down_end

key_handle_down_end
	
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;handle up key
key_handle_up macro
	ej dev_type,dev_type_light,key_handle_up_light
	ej dev_type,dev_type_caution,key_handle_up_caution
	lgoto key_handle_up_end
key_handle_up_light
	bright_up
	lgoto key_handle_up_end
key_handle_up_caution
	bs set_caution_fin
	bc set_caution_rin
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	bc set_caution_fin
	bc set_caution_rin
	lgoto key_handle_up_end

key_handle_up_end
endm

ir_key_handle macro
	local ir_key_handle_br_down,ir_key_handle_br_up
	btss my_status,ir_recevie_status		;;have receive data or not..
	lgoto ir_key_handle_end

	mov custom_8l,a
	movam send_data
	serial_send
	mov data_8l,a
	movam send_data
	serial_send

	
	bc my_status,ir_recevie_status
	ej dev_type,dev_type_unkonwn,ir_key_handle_end

	mov ir_custom_code,a
	xor custom_8l,a
	jnz ir_key_handle_end
	ej data_8l,ir_key_down,ir_key_handle_down
	ej data_8l,ir_key_up,ir_key_handle_up
	lgoto ir_key_handle_end
	
ir_key_handle_down
	key_handle_down
	lgoto ir_key_handle_end
ir_key_handle_up
	key_handle_up
	lgoto ir_key_handle_end
ir_key_handle_end

endm

#include "adcDrv.asm"
#include "serialDrv.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;change the adc value to device value	,place the id at dev_id
adc_2_dev_id macro
	local adc_2_dev_id_next,adc_2_dev_id_not_match,adc_2_dev_id_match,adc_2_dev_id_end
	movla .7
	movam TAB_BNK
	movla 0x50
	movam tab_offset

adc_2_dev_id_next
	tabrdl tab_offset
	sub adc_value,a
	jc adc_2_dev_id_not_match
	
	tabrdh tab_offset
	xorla .0						;;;;    all number(0x00~0xff) - 0, C = 0,don't know why.....but ,fuck,and only mk7a21p have this bug,11&11bp doesn't
	jz adc_2_dev_id_match

	sub adc_value,a
	jc adc_2_dev_id_match
adc_2_dev_id_not_match
	movla .2
	add tab_offset,m
	lgoto adc_2_dev_id_next
	
adc_2_dev_id_match
	inc tab_offset,m
	tabrdl tab_offset
	movam dev_id
adc_2_dev_id_end
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get dev id 
get_dev_type macro
	local get_dev_type_unkown,get_dev_type_caution,get_dev_type_light,get_dev_type_end
	read_adc_5times 0x00
	adc_2_dev_id
	mov dev_id,a
	movam send_data
	serial_send
	
	ej dev_id,0,get_dev_type_unkown
	bj dev_id,0x40,get_dev_type_caution
	lgoto get_dev_type_light
get_dev_type_unkown
	movla dev_type_unkonwn
	movam dev_type
	lgoto get_dev_type_end	
get_dev_type_caution
	movla dev_type_caution
	movam dev_type
	lgoto get_dev_type_end
get_dev_type_light
	movla dev_type_light
	movam dev_type
	lgoto get_dev_type_end
get_dev_type_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;init the chip
init_chip macro

	;PortA端口方向及状态设定            
	movla pa_dir_value
	movam PA_DIR
	clr   		PORTA
	;------------------------------------------------------ 
	;PortB端口方向及状态设定  
	movla pb_dir_value
	movam PB_DIR
	clr   		PORTB
	;------------------------------------------------------

	;PortC端口方向及状态设定  
	movla pc_dir_value
	movam PC_DIR
	clr   		PORTC

	;;;;;;;;set pull up register
	movla pa_plu_value
	movam PA_PLU
	movla pb_plu_value
	movam PB_PLU
	movla pc_plu_value
	movam PC_PLU


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;init wtd
	movla b'10000111'
	movam WDT_CTL
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;start_tm1
;	enable_pa_int
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;sleep mode will use it 
;	btsc STATUS,TO		;not reset by wdt
;	lgoto init_chip_end
;	btsc STATUS,PD		;not from sleep mode
;	lgoto init_chip_end

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;personal setting

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;init some variable
	clr my_status
	clr enc_scan_status
	movla .32
	movam key_loop_counter
	bs set_tx
	m_delay_ms .200


 	;bc PWM_OPT,7
 	clr PWM_OPT
	movla .2
	movam tm1_counter_l
	clr tm1_counter_h
	clr c595_save_key
	movla .0
	movam cur_light_level
	get_dev_type
	mov dev_id,a
	movam ir_custom_code
	enj dev_type,dev_type_light,init_chip_end
	bright_get_pwm_data
	start_led_show
	
init_chip_end
endm
;	ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;goto sleep
goto_sleep macro
	stop_pwm
	stop_tm1
	bc set_led_v1
	bc set_led_v2
	bc set_led_v3
	bc set_led_v4
	bc set_led_iphone
	bc my_status,charge_en
	bc WDT_CTL,WDTEN			;;;stop watch dog
	sleep
	nop		;;add nop to wait sleep state..
	nop
	nop
	bs WDT_CTL,WDTEN			;;;restart watch dog
endm


 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;goto sleep if it can 
try_goto_sleep macro
	btsc my_status,charge_en
	lgoto try_goto_sleep_end
	btsc led_status,led_pwm_using
	lgoto try_goto_sleep_end
	btsc led_status,led_v1_using
	lgoto try_goto_sleep_end
	btsc led_status,led_iphone_using
	lgoto try_goto_sleep_end
	btsc led_status,led_battery_indicat
	lgoto try_goto_sleep_end
	enj backup_bat_charge_status,0,try_goto_sleep_end
	goto_sleep
try_goto_sleep_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;int function
int_entry
	;;enter int ,save the register..
	movam a_buf 
	swap status,a 
	movam status_buf 

	btsc IRQF,TM1F		;test int type
	lgoto int_tm1_entry  	;switch to right type int
	btsc IRQF,PAF
	lgoto int_pa_entry


int_tm1_entry
	int_tm1
	lgoto int_entry_end
int_pa_entry
	int_pa
	lgoto int_entry_end
int_entry_end
	;quit int ,restore the register
	swap   		status_buf,a 
	movam  		status 
	swap   		a_buf,m
	swap   		a_buf,a	
	reti

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;main function     it must write under the macro ,or it can't call the macro
main fun
	init_chip
main_loop
	clrwdt


;	movla 0xff
;	movam PORTA
;	m_delay_ms .200
;	movla 0
;	movam PORTA
;	m_delay_ms .200



	ir_scan
	ir_key_handle
	lgoto main_loop
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;dev id map
org 0x750
dw 0x0008
dw 0x04
dw 0x0910
dw 0x0c
dw 0x1118
dw 0x14
dw 0x1920
dw 0x1c
dw 0x2128
dw 0x24
dw 0x2930
dw 0x2c
dw 0x3138
dw 0x34
dw 0x3940
dw 0x3c
dw 0x4148
dw 0x44
dw 0x4950
dw 0x4c
dw 0x5158
dw 0x54
dw 0x00ff
dw 0x00







end












