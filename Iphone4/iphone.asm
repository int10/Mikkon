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
#define IPhone4_LN055JLY10_010
#define IPhone4_LN055JLY10_020		;OPEN IPhone4_LN055JLY10_010 WITH IT


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FEATURE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#define HAVE_74VHC595_DRV			PS:Open HAVE_I2C_DRV with it
;#define HAVE_ENC_SCAN_FUNCTION		
;#define HAVE_PT2314_DRV				PS:Open HAVE_I2C_DRV with it
;#define HAVE_CS8416_DRV			PS:Open HAVE_I2C_DRV with it
;#define HAVE_CS_485XX_DRV			PS:Open HAVE_I2C_DRV with it
;#define HAVE_EEPROM_DRV			PS:Open HAVE_I2C_DRV with it
;#define HAVE_IR_FUNCTION
;#define HAVE_KEY_SCAN_FUNCTION		PS:Open HAVE_ADC_DRV with it
;#define HAVE_SERIAL_CMD_FUNCTION
;#define HAVE_I2C_DRV
;#define HAVE_ADC_DRV



;;;;;;;;;;;;;;;;;;;;;CHANGE SOME KEY WORDS TO MK7A11P , FOR USE ONE CODE TO HANDLE THE TWO CHIP ;;;;;;;;;;;
#define PORTB PB_DAT
#define PORTA PA_DAT
#define PORTC PC_DAT
#define BSR FSR

ifdef IPhone4_LN055JLY10_010
bit_key_in			equ PA2
bit_i_det			equ PA3
bit_led_v4			equ PB1
bit_led_v3			equ PA5
bit_chr_en			equ PB3
bit_led_iphone		equ PC0
bit_led_v1			equ PC2
bit_led_v2			equ PC3

ifdef IPhone4_LN055JLY10_020
bit_chr_chg			equ PB2
bit_chr_pg			equ PA4
#define test_chr_chg			PORTB,bit_chr_chg
#define test_chr_pg			PORTA,bit_chr_pg
endif

#define test_key_in		PORTA,bit_key_in
#define test_i_det			PORTA,bit_i_det
#define set_led_v4			PORTB,bit_led_v4
#define set_led_v3			PORTA,bit_led_v3
#define set_chr_en			PORTB,bit_chr_en
#define set_led_iphone		PORTC,bit_led_iphone
#define set_led_v1			PORTC,bit_led_v1
#define set_led_v2			PORTC,bit_led_v2
#define set_tx				PORTA,bit_led_v4
#define test_rx				PORTC,PC1


pa_dir_value			equ b'11011111'
pb_dir_value			equ b'11110101'
pc_dir_value			equ b'11110010'
pa_plu_value			equ b'11111111'
pb_plu_value			equ b'11110111'
pc_plu_value			equ b'11111111'

endif



#define ch_vcc_bat			0x00

ifdef USE_EMULATOR
#define vcc_bat_2v			0xb2
#define vcc_bat_1_8v		0x9f
#define vcc_bat_1_4v		0x80
#define vcc_bat_1_5v		0x87
#define vcc_bat_1_25v		0x71
else
#define vcc_bat_2v			.204
#define vcc_bat_1_8v		.183
#define vcc_bat_1_4v		.143
#define vcc_bat_1_5v		.153
#define vcc_bat_1_25v		.128
endif

#define pwm_5ms_per		0x9c
#define pwm_5ms_30_duty		0x2f
#define pwm_5ms_60_duty		0x5d


;my_status define 
ir_recevie_status			equ	0
key_long_press_status		equ	1
charge_en					equ	2
iphone_in					equ	3			;0:no iphone 1:iphone in
serial_receive_status		equ	4
tm1_running					equ	5
tm1_overflow				equ	6
;serial_string_receive_status		equ 7
;iphone_in_save				equ 7

;;;i2c_status define
i2c_fun_switch			equ 0			;;;;1:eeprom is using i2c....0:other device		;;before eeprom use it ,set it to 1,and remember set it to 0 as soon as eeprom oper end...
i2c_sda_status			equ 1			;;;;save sda pin status

;;;;;led_status define
led_v1_using			equ	0
led_iphone_using		equ	1
led_v1_pin_status		equ	2
led_iphone_pin_status	equ	3
led_battery_indicat		equ	4
led_pwm_using			equ	5
led_backup_bat_changing	equ	6

;;;;;;;;;;;;;;;;;low power level
LOW_POWER_NOT_LOW	equ	0
LOW_POWER_14_15		equ	1
LOW_POWER_125_14		equ	2
LOW_POWER_LOW_125	equ	3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;delay const

#define const_delay_40us		.19
#define const_delay_100us		.49
#define const_delay_560us		.111
#define const_delay_1680us		.167
#define const_delay_1ms		.199




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

dsp_trans_size_h		equ			0x78
dsp_trans_size_l			equ			0x79
serial_byte_counter		equ			0x7a

dsp_down_size_h		equ			0x80
dsp_down_size_l			equ			0x81
dsp_cur_oper_size		equ			0x82



osused					equ 			0x83
mpmused				equ 			0x84
vpmused				equ 			0x85
ppmused				equ 			0x86
dai_dao_cfg_index		equ 			0x87
pcm_cfg_index			equ 			0x88
os_cfg_index			equ 			0x89
mpm_cfg_index			equ 			0x8a
vpm_cfg_index			equ 			0x8b
tone_cfg_index			equ 			0x8c
bm_cfg_index			equ 			0x8d
delay_cfg_index			equ 			0x8e
am_cfg_index			equ 			0x8f
tshd_output_index		equ 			0x90
dvs2_output_index		equ 			0x91
input_type				equ 			0x92
source_type				equ 			0x93
configIndex				equ			0x94

led_status				equ			0x95
led_v1_counter			equ			0x96			;if = 0xff ,means don't use counter
led_iphone_counter		equ			0x97			;if = 0xff ,means don't use counter
led_v1_pre_counter		equ			0x98			;frequency counter...when it dec to 0,change pin status
led_v1_pre_save_counter	equ		0x99			;frequency counter saver
led_iphone_pre_counter		equ		0x9a			;frequency counter...when it dec to 0,change pin status
led_iphone_pre_save_counter	equ	0x9b			;frequency counter saver
led_battery_indicat_counter	equ		0x9c
low_power_level			equ			0x9d

backup_bat_charge_status		equ	0x9e			;0:not charging 1:charging 2:full
led_backup_bat_status			equ	0x9f				;0:all off...1:v1 on...2:v2on.............





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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start pwm ouput ,default TM2 prescaler rate is 1:128,and PWM prescaler is 1:1..TM3 prescaler rate is 1:128.......L_period=time/((1/4)*128)		time is us level  L_duty=
start_pwm macro L_period,L_duty
	bc led_status,led_iphone_using			;;led_iphone is gpio pc0 and pwm pin..so before start pwm ,stop timer to control it ...
	movla b'01100111'
	movam TM2_CTL1
	movla b'10000000'
	movam TM2_CTL2
	movla b'11100111'
	movam TM3_CTL
	;movla 0x9c        	;设置PWM的周期 
	movla L_period
	movam TM2_LA
	;movla 0x2f         	;设置PWM的占空比 
	movla L_duty
	movam TM3_LA
	bs TM2_CTL1,TM2_EN
	bs led_status,led_pwm_using
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;stop pwm output
stop_pwm macro
	clr TM2_CTL1
	clr TM2_CTL2
	clr TM3_CTL
	bc led_status,led_pwm_using
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;enable pa int
enable_pa_int macro
	dis_int
	bs INTM,PAM
	bs PA_INTE,bit_i_det
	bs PA_INTE,bit_key_in
	bc IRQF,PAF
	en_int
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
	;dis_int
	bs IRQM,PAM
	bs PA_INTE,bit_i_det
	bs PA_INTE,bit_key_in
ifdef IPhone4_LN055JLY10_020
	bs PA_INTE,bit_chr_pg
endif
	bs IRQM,INTM
	;en_int
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;init some variable
	clr my_status
	clr enc_scan_status
	movla .32
	movam key_loop_counter
	clr led_status
	clr low_power_level

	movla .2
	movam tm1_counter_l
	clr tm1_counter_h
	clr c595_save_key
	clr backup_bat_charge_status
	
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

;ifdef HAVE_ADC_DRV
#include "adcDrv.asm"
;endif


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start led_v1 flash		,L_fre is one cycle time in seconds..., L_last is flash time in seconds ...all in seconds....if L_last = 0xff,flash all the time
start_led_v1_flash macro L_fre,L_last
	bc led_status,led_v1_using
	bc led_status,led_battery_indicat
	bc set_led_v1
	bc set_led_v2
	bc set_led_v3
	bc set_led_v4
	movla L_fre
	movam led_v1_pre_counter
	movam led_v1_pre_save_counter
	movla L_last
	movam led_v1_counter
	bs set_led_v1
	bs led_status,led_v1_pin_status
	bs led_status,led_v1_using
	start_tm1
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start led_iphone flash		,L_fre is one cycle time in seconds..., L_last is flash time in seconds ...all in seconds..if L_last = 0xff,flash all the time
start_led_iphone_flash macro L_fre,L_last
	stop_pwm					;;pc0 is gpio and pwm pin ,when it use as gpio ,stop pwm first
	bc led_status,led_iphone_using			;;;;avoid effort of timer..
	movla L_fre
	movam led_iphone_pre_counter
	movam led_iphone_pre_save_counter
	movla L_last
	movam led_iphone_counter
	bs set_led_iphone
	bs led_status,led_iphone_pin_status
	bs led_status,led_iphone_using
	start_tm1
endm

ifdef IPhone4_LN055JLY10_020
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start backup  
start_led_backup_bat_charge macro
	clr led_backup_bat_status
	bc led_status,led_v1_using
	bc led_status,led_battery_indicat
	bs led_status,led_backup_bat_changing
	bc set_led_v1
	bc set_led_v2
	bc set_led_v3
	bc set_led_v4
	start_tm1
endm
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get battery VCC value  ....the value place at adc_value
battery_get_value macro
	read_adc_5times ch_vcc_bat
	adc_get_best_value
	
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;battery indication
battery_indicat macro
	;battery_get_value
	;;;
ifdef IPhone4_LN055JLY10_020
	btsc led_status,led_backup_bat_changing
	lgoto battery_indicat_end
endif

	bc set_led_v1
	bc set_led_v2
	bc set_led_v3
	bc set_led_v4

	;;;;;;;;;;;;if charging mode and vcc <= 1.5,led 1 is flashing ,no need to show it
;	btss my_status,charge_en
;	lgoto battery_indicat_show
;	bj adc_value,vcc_bat_1_5v,battery_indicat_show
;	lgoto battery_indicat_end
;	
;	 
;battery_indicat_show
	bj adc_value,vcc_bat_2v,battery_indicat_2v
	bj adc_value,vcc_bat_1_8v,battery_indicat_1_8v
	bj adc_value,vcc_bat_1_5v,battery_indicat_1_5v
	bj adc_value,vcc_bat_1_4v,battery_indicat_1_4v
	bj adc_value,vcc_bat_1_25v,battery_indicat_1_25v
	lgoto battery_indicat_too_low

battery_indicat_2v
	bs set_led_v1
	bs set_led_v2
	bs set_led_v3
	bs set_led_v4
	lgoto battery_indicat_ok
battery_indicat_1_8v
	bs set_led_v1
	bs set_led_v2
	bs set_led_v3
	lgoto battery_indicat_ok
battery_indicat_1_5v
	bs set_led_v1
	bs set_led_v2
	lgoto battery_indicat_ok
battery_indicat_1_4v
	btsc my_status,charge_en
	lgoto battery_indicat_end
	bs set_led_v1
	bs set_led_v2
	lgoto battery_indicat_ok
battery_indicat_1_25v
	bs set_led_v1
	lgoto battery_indicat_ok
battery_indicat_too_low
	start_led_iphone_flash 4,30
	lgoto battery_indicat_end
	
battery_indicat_ok
	movla .12
	movam led_battery_indicat_counter
	bc led_status,led_v1_using
	bs led_status,led_battery_indicat
	start_tm1
battery_indicat_end

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
start_charge macro 
ifdef IPhone4_LN055JLY10_020
	enj backup_bat_charge_status,0,start_charge_sucess	;;means backup battery is charging ...
endif
	;battery_get_value
	sj adc_value,vcc_bat_1_4v,start_charge_fail
start_charge_sucess
	;bs set_chr_en
	bs PB_DIR,bit_chr_en
	bs my_status,charge_en

	;int10@110616
	;start_led_iphone_flash .2,0xff
	start_led_iphone_flash .4,0xff
	lgoto start_charge_end
start_charge_fail
	;;;flash led_v1 fast 60S   int10int10
	start_led_v1_flash 1,.60
start_charge_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;switch charge mode ,assume iphone detected
switch_charge_mode macro
	btsc my_status,charge_en
	lgoto switch_charge_mode_dis
	lgoto switch_charge_mode_en
	
switch_charge_mode_en
	start_charge
	lgoto switch_charge_mode_end
switch_charge_mode_dis
	bc set_led_v1
	bc set_led_v2
	bc set_led_v3
	bc set_led_v4

	;int10@110616
	;start_pwm pwm_5ms_per,pwm_5ms_30_duty
	start_led_iphone_flash .1,.5
	bc PB_DIR,bit_chr_en
	bc set_chr_en
	bc my_status,charge_en
	lgoto switch_charge_mode_end
	
switch_charge_mode_end	
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan key
key_scan macro
	local key_scan_battery_can_work,key_scan_loop,key_short_press,key_long_press,key_long_press_no_iphone,key_wait_release,key_scan_end
	btsc test_key_in
	lgoto key_scan_end
	m_delay_ms .80
	btsc test_key_in
	lgoto key_scan_end

;	battery_get_value
;	bj adc_value,LOW_POWER_LOW_125,key_scan_battery_can_work
;	;;lower than 1.25V ,only show led
;	start_led_iphone_flash .4,.30
	
;key_scan_battery_can_work

	movla .20
	movam tm_counter_l
key_scan_loop
	btsc test_key_in
	lgoto key_short_press
	m_delay_ms .100
	decsz tm_counter_l,m
	lgoto key_scan_loop
	lgoto key_long_press
	
key_short_press
	;;;;battery indication
	battery_indicat
	lgoto key_scan_end

key_long_press
	btsc test_i_det
	lgoto key_long_press_no_iphone
	switch_charge_mode
	lgoto key_wait_release
key_long_press_no_iphone
	;;;;;;;led_iphone on/off 50% 1S for 5S		;;int10int10
	start_led_iphone_flash .1,.5

key_wait_release
	btss test_key_in
	lgoto key_wait_release
	m_delay_ms .80
	btss test_key_in
	lgoto key_wait_release

key_scan_end

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;detect iphone
iphone_detect macro 
	btsc test_i_det
	lgoto iphone_detect_no
	;;;;in
	btsc my_status,iphone_in
	lgoto iphone_detect_in
	m_delay_ms .80
	btsc test_i_det					;;;;button de-jitter
	lgoto iphone_detect_end

iphone_detect_in
	btsc my_status,iphone_in		;;;iphone alread in
	lgoto iphone_detect_end

	bs my_status,iphone_in
	
	btsc my_status,charge_en
	lgoto iphone_detect_end
	sj adc_value,vcc_bat_1_4v,iphone_detect_vcc_low			;;if vcc<1.4 , needn't start pwm
	;btsc led_status,led_pwm_using							;;if vcc >1.4 and pwm is running ,needn't start pwm
	;lgoto iphone_detect_end
	;start_pwm pwm_5ms_per,pwm_5ms_30_duty
	start_led_iphone_flash .1,.5
	lgoto iphone_detect_end

iphone_detect_vcc_low
	;stop_pwm
	lgoto iphone_detect_end
iphone_detect_no			;;out
	btss my_status,iphone_in
	lgoto iphone_detect_end
	m_delay_ms .80
	btss test_i_det					;;;;button de-jitter
	lgoto iphone_detect_end
	
	bc my_status,iphone_in
	bc my_status,charge_en
	bc PB_DIR,bit_chr_en
	bc set_chr_en
	stop_pwm
	bc led_status,led_iphone_using
	bc set_led_iphone
	start_led_iphone_flash .1,.5
	btss led_status,led_v1_using
	lgoto iphone_detect_end
	bc led_status,led_v1_using
	bc set_led_v1
	;goto_sleep
	
iphone_detect_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;battery low power detect  .....only do it at charging
low_power_detect macro
ifdef IPhone4_LN055JLY10_020
	enj backup_bat_charge_status,0,low_power_detect_no_need
	lgoto low_power_detect_start
low_power_detect_no_need
	movla LOW_POWER_NOT_LOW
	movam low_power_level
low_power_detect_start
endif
	btss my_status,charge_en
	lgoto low_power_detect_end
	;battery_get_value
	bj adc_value,vcc_bat_1_5v,low_power_detect_not_low
	bj adc_value,vcc_bat_1_4v,low_power_level_14_15
	bj adc_value,vcc_bat_1_25v,low_power_level_125_14
	lgoto low_power_level_lower_125

low_power_detect_not_low
	ej low_power_level,LOW_POWER_NOT_LOW,low_power_detect_end
	movla LOW_POWER_NOT_LOW
	movam low_power_level
	btss led_status,led_v1_using
	lgoto low_power_detect_end
	bc led_status,led_v1_using
	bc set_led_v1
	lgoto low_power_detect_end
low_power_level_14_15
	ej low_power_level,LOW_POWER_14_15,low_power_detect_end
	movla LOW_POWER_14_15
	movam low_power_level
	start_led_v1_flash 4,0xff
	lgoto low_power_detect_end
low_power_level_125_14
	ej low_power_level,LOW_POWER_125_14,low_power_detect_end
	movla LOW_POWER_125_14
	movam low_power_level
	bc my_status,charge_en
	bc set_chr_en
	bc set_led_iphone
	bc led_status,led_iphone_using
	start_led_v1_flash 1,.60
	lgoto low_power_detect_end
low_power_level_lower_125
	ej low_power_level,LOW_POWER_LOW_125,low_power_detect_end
	movla LOW_POWER_LOW_125
	movam low_power_level
	;goto_sleep
		
low_power_detect_end
endm

ifdef IPhone4_LN055JLY10_020
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;detect backup bat is charging or not
backup_bat_charge_detect macro
	btsc test_chr_pg
	lgoto backup_bat_not_charge
	btsc test_chr_chg
	lgoto backup_bat_charge_full
	lgoto backup_bat_charging
backup_bat_not_charge
	ej backup_bat_charge_status,0,backup_bat_charge_detect_end
	movla 0
	movam backup_bat_charge_status
	bc led_status,led_backup_bat_changing
	bc set_led_v1
	bc set_led_v2
	bc set_led_v3
	bc set_led_v4
	lgoto backup_bat_charge_detect_end
backup_bat_charge_full
	ej backup_bat_charge_status,2,backup_bat_charge_detect_end
	movla .2
	movam backup_bat_charge_status
	start_led_backup_bat_charge
	
	lgoto backup_bat_charge_detect_end
backup_bat_charging
	ej backup_bat_charge_status,1,backup_bat_charge_detect_end
	movla .1
	movam backup_bat_charge_status
	start_led_backup_bat_charge
	lgoto backup_bat_charge_detect_end
backup_bat_charge_detect_end
endm
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;loop v1~v4
led_backup_bat_show macro 
	local led_backup_bat_show_1,led_backup_bat_show_2,led_backup_bat_show_3,led_backup_bat_show_4,led_backup_bat_show_0,led_backup_bat_full,led_backup_bat_show_end
	;int10@110617
	ej backup_bat_charge_status,2,led_backup_bat_full
	ej led_backup_bat_status,1,led_backup_bat_show_1
	ej led_backup_bat_status,2,led_backup_bat_show_2
	ej led_backup_bat_status,3,led_backup_bat_show_3
	ej led_backup_bat_status,4,led_backup_bat_show_4
	lgoto led_backup_bat_show_0
led_backup_bat_show_0
	movla .1
	movam led_backup_bat_status
	bs set_led_v1
	lgoto led_backup_bat_show_end
led_backup_bat_show_1
	movla .2
	movam led_backup_bat_status
	;bc set_led_v1
	bs set_led_v2
	lgoto led_backup_bat_show_end
led_backup_bat_show_2
	movla .3
	movam led_backup_bat_status
	;bc set_led_v2
	bs set_led_v3
	lgoto led_backup_bat_show_end
led_backup_bat_show_3
	;bc set_led_v3
	;int10@110617
	;ej backup_bat_charge_status,2,led_backup_bat_full
	movla .4
	movam led_backup_bat_status
	bs set_led_v4
	lgoto led_backup_bat_show_end
led_backup_bat_full
	movla .0
	movam led_backup_bat_status
	bs set_led_v1
	bs set_led_v2
	bs set_led_v3
	bs set_led_v4
	lgoto led_backup_bat_show_end

led_backup_bat_show_4
	movla .0
	movam led_backup_bat_status
	bc set_led_v4
	bc set_led_v1
	bc set_led_v2
	bc set_led_v3
	lgoto led_backup_bat_show_end
led_backup_bat_show_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;control led_v1
led_v1_center macro
ifdef IPhone4_LN055JLY10_020
	ej backup_bat_charge_status,1,led_center_bbat_charging
	ej backup_bat_charge_status,2,led_center_bbat_full
	lgoto led_center_bbat_not_charging
led_center_bbat_charging
	led_backup_bat_show
	lgoto led_v1_center_end
led_center_bbat_full
	led_backup_bat_show
	lgoto led_v1_center_end
led_center_bbat_not_charging
endif
	btsc led_status,led_battery_indicat
	lgoto led_v1_center_battery_indicat
	btss led_status,led_v1_using
	lgoto led_v1_center_end
	decsz led_v1_pre_counter,m
	lgoto led_v1_center_end

	mov led_v1_pre_save_counter,a
	movam led_v1_pre_counter

	btsc led_status,led_v1_pin_status
	lgoto led_v1_high_now
	;;low now
	ej led_v1_counter,0xff,led_v1_counter_hanle_end
	decsz led_v1_counter,m
	lgoto led_v1_counter_hanle_end
	lgoto led_v1_flash_end
	

led_v1_counter_hanle_end
	 bs led_status,led_v1_pin_status
	 bs set_led_v1
	 lgoto led_v1_center_end
led_v1_high_now
	bc led_status,led_v1_pin_status
	bc set_led_v1
	lgoto led_v1_center_end


led_v1_flash_end
	bc led_status,led_v1_using
	lgoto led_v1_center_end

led_v1_center_battery_indicat
	decsz led_battery_indicat_counter,m
	lgoto led_v1_center_end
	bc led_status,led_battery_indicat
	bc set_led_v1
	bc set_led_v2
	bc set_led_v3
	bc set_led_v4
led_v1_center_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;control led_iphone
led_iphone_center macro
	btss led_status,led_iphone_using
	lgoto led_iphone_center_end
	decsz led_iphone_pre_counter,m
	lgoto led_iphone_center_end

	mov led_iphone_pre_save_counter,a
	movam led_iphone_pre_counter

	btsc led_status,led_iphone_pin_status
	lgoto led_iphone_high_now
	;;low now
	ej led_iphone_counter,0xff,led_iphone_counter_hanle_end
	decsz led_iphone_counter,m
	lgoto led_iphone_counter_hanle_end
	lgoto led_iphone_flash_end

led_iphone_counter_hanle_end
	 bs led_status,led_iphone_pin_status
	 bs set_led_iphone
	 lgoto led_iphone_center_end
led_iphone_high_now
	bc led_status,led_iphone_pin_status
	bc set_led_iphone
	lgoto led_iphone_center_end

led_iphone_flash_end
	bc led_status,led_iphone_using

led_iphone_center_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;control the led....
led_center macro
	btss my_status,tm1_overflow
	lgoto led_center_end
	bc my_status,tm1_overflow
	led_v1_center
	led_iphone_center
led_center_end
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

#include "serialDrv.asm"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;main function     it must write under the macro ,or it can't call the macro
main fun
	init_chip

main_loop
	clrwdt
	battery_get_value
	key_scan
	iphone_detect
	low_power_detect
ifdef IPhone4_LN055JLY10_020
	backup_bat_charge_detect
endif
	;led_center
	try_goto_sleep






;	battery_get_value
;	mov adc_value,a
;	movam send_data
;	serial_send
;	m_delay_ms .200
;	m_delay_ms .200
;	m_delay_ms .200
;	m_delay_ms .200
;	m_delay_ms .200
	lgoto main_loop
	ret


end






