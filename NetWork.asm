;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Creat by int10@090921
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;use MK7A21P chip

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CHIPSET;;;;;;;;;;;;;;;;;;;;;;

;#define USE_CHIP_MK7A21P
#define USE_CHIP_MK7A25P
#include "mk7a21p.inc"
#include "dspinc.inc"

#define fun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROJECT;;;;;;;;;;;;;;;;;;;;;;;;;
;#define AD_NET_3511
;#define Car_Front_Panel
#define Newage_LN053NA08_010
;#define Newage_LN053NA08_010_A		;open Newage_LN053NA08_010 with it
;#define SoundBar_DSP_LN054IH10_010
;#define InnoHill_LN054IH07_010
#define Newage_LN053NA09		;open Newage_LN053NA08_010 with it

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FEATURE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#define HAVE_74VHC595_DRV			PS:Open HAVE_I2C_DRV with it
;#define HAVE_ENC_SCAN_FUNCTION		
;#define HAVE_PT2314_DRV				PS:Open HAVE_I2C_DRV with it
;#define HAVE_PT2301_DRV				PS:Open HAVE_I2C_DRV with it
;#define HAVE_CS8416_DRV			PS:Open HAVE_I2C_DRV with it
;#define HAVE_CS_485XX_DRV			PS:Open HAVE_I2C_DRV with it
;#define HAVE_EEPROM_DRV			PS:Open HAVE_I2C_DRV with it
;#define HAVE_IR_FUNCTION
;#define HAVE_KEY_SCAN_FUNCTION		PS:Open HAVE_ADC_DRV with it
;#define HAVE_SERIAL_CMD_FUNCTION
;#define HAVE_I2C_DRV
;#define HAVE_ADC_DRV
;#define HAVE_EXTRA_VOL_KEY
;#define HAVE_GRIDKEY_FUNCTION
;#define HAVE_IR_OPTICAL_DRV



;;;;;;;;;;;;;;;;;;;;;CHANGE SOME KEY WORDS TO MK7A11P , FOR USE ONE CODE TO HANDLE THE TWO CHIP ;;;;;;;;;;;
#define PORTB PB_DAT
#define PORTA PA_DAT
#define PORTC PC_DAT
#define BSR FSR

ifdef AD_NET_3511
;
;work_mode_dvd		equ 1
;work_mode_music	equ 2
;work_mode_fm		equ 3
;work_mode_pc		equ 4
;work_mode_phone	equ 5
;work_mode_end		equ work_mode_phone
;
;bit_ir_in			equ PA4
;bit_ir_out		equ PA5
;bit_enc_a		equ PC0
;bit_enc_b		equ PC1
;bit_led_pc		equ PA3
;bit_led_phone	equ PA2
;bit_led_dvd		equ PB3
;bit_led_music	equ PB2
;bit_led_fm		equ PB1
;bit_rx			equ PC3
;bit_tx			equ PC2
;
;#define test_ir_in			PORTA,bit_ir_in
;#define set_ir_out		PORTA,bit_ir_out
;#define test_enc_a		PORTC,bit_enc_a
;#define test_enc_b		PORTC,bit_enc_b
;#define set_led_pc		PORTA,bit_led_pc
;#define set_led_phone	PORTA,bit_led_phone
;#define set_led_dvd		PORTB,bit_led_dvd
;#define set_led_music	PORTB,bit_led_music
;#define set_led_fm		PORTB,bit_led_fm
;#define set_tx 			PORTC,bit_tx
;#define test_rx 			PORTC,bit_rx
;
;pa_dir_value	equ b'11010011'
;pb_dir_value	equ b'11110001'
;pc_dir_value	equ b'11111011'
;pa_plu_value			equ b'11111111'
;pb_plu_value			equ b'11111111'
;pc_plu_value			equ b'11111100'
;
;#define HAVE_ENC_SCAN_FUNCTION
;#define HAVE_IR_FUNCTION
;#define HAVE_KEY_SCAN_FUNCTION
;#define HAVE_SERIAL_CMD_FUNCTION
;#define HAVE_ADC_DRV
;
endif

ifdef Car_Front_Panel
;bit_ir_in			equ PA4
;bit_enc_a		equ PC0
;bit_enc_b		equ PC1
;bit_rx			equ PC3
;bit_tx			equ PC2				;;;;ps: share the pin with ir_out...
;bit_ir_out		equ PC2				;;ps : share the pin with tx
;bit_led_sda		equ PB3
;bit_led_src		equ PB2
;bit_led_sck		equ PB1
;
;#define test_ir_in		PORTA,bit_ir_in
;#define test_enc_a		PORTC,bit_enc_a
;#define test_enc_b		PORTC,bit_enc_b
;#define set_tx			PORTC,bit_tx
;#define set_rx			PORTC,bit_rx
;#define set_led_sda	PORTB,bit_led_sda
;#define set_led_src		PORTB,bit_led_src
;#define set_led_sck	PORTB,bit_led_sck
;;#define set_ir_out		PORTA,bit_ir_in			;;in fact it's no use in this project...add it only for compile....
;#define set_ir_out		PORTC,bit_ir_out		;;change at 100822 ....use ir instead serial protocol
;
;pa_dir_value	equ b'11111111'
;pb_dir_value	equ b'11110001'
;pc_dir_value	equ b'11111011'
;pa_plu_value			equ b'11111111'
;pb_plu_value			equ b'11111111'
;pc_plu_value			equ b'11111100'
;
;#define HAVE_74VHC595_DRV
;#define HAVE_ENC_SCAN_FUNCTION
;#define HAVE_IR_FUNCTION
;#define HAVE_KEY_SCAN_FUNCTION
;#define HAVE_SERIAL_CMD_FUNCTION
;#define HAVE_ADC_DRV
;
endif


ifdef Newage_LN053NA08_010
ifndef Newage_LN053NA09
;
;bit_led_phone 	equ PA4
;bit_led_pc		equ PA5
;bit_sck			equ PB1
;bit_sda			equ PB2
;bit_led_key_p	equ PC0
;bit_led_key_a	equ PC2
;bit_led_key_c	equ PC3
;
;
;#define set_led_phone			PORTA,bit_led_phone
;#define set_led_pc				PORTA,bit_led_pc
;#define set_sck					PORTB,bit_sck
;#define set_sda				PORTB,bit_sda
;#define test_sda				PORTB,bit_sda
;;;int10int10
;#define set_sda_dir				PB_DIR,bit_sda
;#define set_led_key_p			PORTC,bit_led_key_p
;#define set_led_key_a			PORTC,bit_led_key_a
;#define set_led_key_c			PORTC,bit_led_key_c
;#define set_ir_out				0xbf,1
;#define test_ir_in				0xbf,0
;#define set_tx					0xbf,1
;;#define set_e_sck				PORTB,bit_sck
;;#define set_e_sda				PORTB,bit_sda
;;#define set_e_sda_dir			PB_DIR,bit_sda
;;#define test_e_sda				PORTB,bit_sda
;
;pa_dir_value			equ b'11001111'
;pb_dir_value			equ b'11111001'
;pc_dir_value			equ b'11110010'
;pa_plu_value			equ b'11111111'
;pb_plu_value			equ b'11111111'
;pc_plu_value			equ b'11111111'
;
;#define HAVE_PT2314_DRV
;#define HAVE_KEY_SCAN_FUNCTION
;#define HAVE_I2C_DRV
;#define HAVE_ADC_DRV
;ifdef Newage_LN053NA08_010_A
;bit_key_vol_up				equ PA3
;bit_key_vol_down			equ	PA2
;#define HAVE_EXTRA_VOL_KEY
;#define test_key_vol_up		PORTA,bit_key_vol_up
;#define test_key_vol_down	PORTA,bit_key_vol_down
;endif ;Newage_LN053NA08_010_A
;
else ;not Newage_LN053NA09

bit_led_phone 	equ PA4
bit_led_pc		equ PA5
bit_sck			equ PB3
bit_sda			equ PA2
bit_led_key_p	equ PC0
bit_led_key_a	equ PC2
bit_led_key_c	equ PC3
bit_shut_down	equ PB1
bit_mute		equ PB2

bit_key_vol_up				equ PA3
bit_key_vol_down			equ	PC1

#define set_led_phone			PORTA,bit_led_phone
#define set_led_pc				PORTA,bit_led_pc
#define set_sck					PORTB,bit_sck
#define set_sda				PORTA,bit_sda
#define test_sda				PORTA,bit_sda
;;int10int10
#define set_sda_dir				PA_DIR,bit_sda
#define set_led_key_p			PORTC,bit_led_key_p
#define set_led_key_a			PORTC,bit_led_key_a
#define set_led_key_c			PORTC,bit_led_key_c
#define set_shut_down			PORTB,bit_shut_down
#define set_mute				PORTB,bit_mute
#define set_ir_out				0xbf,1
#define test_ir_in				0xbf,0
#define set_tx					0xbf,1
;#define set_e_sck				PORTB,bit_sck
;#define set_e_sda				PORTB,bit_sda
;#define set_e_sda_dir			PB_DIR,bit_sda
;#define test_e_sda				PORTB,bit_sda
#define test_key_vol_up		PORTA,bit_key_vol_up
#define test_key_vol_down	PORTC,bit_key_vol_down


pa_dir_value			equ b'11001011'
pb_dir_value			equ b'11110001'
pc_dir_value			equ b'11110010'
pa_plu_value			equ b'11111111'
pb_plu_value			equ b'11111111'
pc_plu_value			equ b'11111111'

#define HAVE_PT2301_DRV
#define HAVE_KEY_SCAN_FUNCTION
#define HAVE_I2C_DRV
#define HAVE_ADC_DRV
#define HAVE_EXTRA_VOL_KEY


endif ;Newage_LN053NA09


endif




ifdef SoundBar_DSP_LN054IH10_010
;bit_sda				equ PA2
;bit_sck				equ PA3
;bit_watch_dog		equ PA4
;bit_e_sck			equ PA4
;bit_dsp_irq			equ PA5
;bit_tx				equ PB0
;bit_rx				equ PB1
;bit_aud_rst			equ PB2
;bit_amp_pnd		equ PB3
;bit_cs8416_err		equ PC0
;bit_e_sda			equ PC0
;bit_cs8416_int		equ PC1
;bit_dsp_rst			equ PC2
;bit_dsp_bsy			equ PC3
;
;#define set_sck					PORTA,bit_sck
;#define set_sda				PORTA,bit_sda
;#define test_sda				PORTA,bit_sda
;#define set_sda_dir			PA_DIR,bit_sda
;#define set_watch_dog			PORTA,bit_watch_dog
;#define test_dsp_irq			PORTA,bit_dsp_irq
;#define set_tx					PORTB,bit_tx
;#define test_rx					PORTB,bit_rx
;#define set_aud_rst			PORTB,bit_aud_rst
;#define set_amp_pnd			PORTB,bit_amp_pnd
;#define test_cs8416_err		PORTC,bit_cs8416_err
;#define set_cs8416_int			PORTC,bit_cs8416_int
;#define set_dsp_rst			PORTC,bit_dsp_rst
;#define test_dsp_bsy			PORTC,bit_dsp_bsy
;#define set_e_sck				PORTA,bit_e_sck
;#define set_e_sda				PORTC,bit_e_sda
;#define test_e_sda				PORTC,bit_e_sda
;#define set_e_sda_dir			PC_DIR,bit_e_sda
;
;
;pa_dir_value			equ b'11100011'
;pb_dir_value			equ b'11110010'
;pc_dir_value			equ b'11111010'
;pa_plu_value			equ b'11011111'
;pb_plu_value			equ b'11111111'
;pc_plu_value			equ b'11111111'
;
;#define HAVE_CS8416_DRV
;#define HAVE_CS_485XX_DRV
;#define HAVE_EEPROM_DRV
;#define HAVE_SERIAL_CMD_FUNCTION
;#define HAVE_I2C_DRV
endif

ifdef InnoHill_LN054IH07_010
;bit_led_pc		equ		PB3
;bit_led_tv		equ		PB2
;bit_led_dvd		equ		PB1
;bit_led_dvb		equ		PB0
;
;bit_ir_out		equ		PC0
;bit_ir_in			equ 		PC1
;bit_sck			equ		PC2
;bit_sda			equ		PC3
;bit_rxd			equ		PC4
;bit_txd			equ		PC5
;
;
;#define set_led_pc		PORTB,bit_led_pc
;#define set_led_tv		PORTB,bit_led_tv
;#define set_led_dvd	PORTB,bit_led_dvd
;#define set_led_dvb	PORTB,bit_led_dvb
;
;#define set_ir_out		PORTC,bit_ir_out
;#define test_ir_in		PORTC,bit_ir_in
;#define set_sck			PORTC,bit_sck
;#define set_sda		PORTC,bit_sda
;#define test_rxd		PORTC,bit_rxd
;#define set_txd			PORTC,bit_txd
;
;
;pa_dir_value			equ b'11111111'
;pb_dir_value			equ b'11110000'
;pc_dir_value			equ b'11010010'
;pa_plu_value			equ b'11111111'
;pb_plu_value			equ b'11111111'
;pc_plu_value			equ b'11111111'
;
;
;#define HAVE_GRIDKEY_FUNCTION
;#define HAVE_IR_OPTICAL_DRV
;
;
endif



#define	ch_adc_key		0x00


#define custom_code				0xfe
;#define custom_code				0x00

;;ir key mode
#define IR_MODE_NORMAL		0X00
#define IR_MODE_PC			0X01
#define IR_MODE_DVD			0X02
#define IR_MODE_DVBT			0X03
#define IR_MODE_TV			0X04



;;enc status
#define ENC_IDLE			0
#define ENC_A_PUSH		1
#define ENC_B_PUSH		2



;my_status define 
ir_recevie_status			equ	0
key_long_press_status		equ	1
c595_status					equ	2		;;;;0:idle.....1:data complete.....
c595_pin_status				equ	3		;;;;0:low status.....1:high status
serial_receive_status		equ	4
c595_key_press_status		equ	5
tm1_overflow				equ	6
serial_string_receive_status		equ 7

;;;i2c_status define
i2c_fun_switch			equ 0			;;;;1:eeprom is using i2c....0:other device		;;before eeprom use it ,set it to 1,and remember set it to 0 as soon as eeprom oper end...
i2c_sda_status			equ 1			;;;;save sda pin status


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;key define
key_null			equ 0x00
key_keyc			equ 0xea
key_keya			equ 0xeb
key_keyp			equ 0xec
key_pc				equ 0xed
key_phone			equ 0xee
key_funtion			equ 0xef
key_power			equ 0xf0
key_volume_up		equ 0xf1
key_volume_down	equ 0xf2
key_mode_scrolling	equ 0xf3
key_channel_up		equ 0xf4
key_channel_down	equ 0xf5
key_fast_forward	equ 0xf6
key_fast_reward		equ 0xf7
key_play_pause		equ 0xf8
key_stop			equ 0xf9
key_dvd_eject		equ 0xfa
key_lcd_off			equ 0xfb
key_mute			equ 0xfc
key_next_track		equ 0xfd
key_pre_trakck		equ 0xfe
key_lcd_on			equ 0xff


key_dvd_open		equ 0x1c
key_lcd_open		equ 0x14
key_lcd_close		equ 0x5f
key_av_audio		equ 0x43
key_pc_audio		equ 0x4f
key_dvd_audio		equ 0x57
key_volume_up2	equ 0x4b
key_volume_down2	equ 0x5e
key_loudness		equ 0x47
key_bass			equ 0x53
key_treble			equ 0x5b


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;delay const

#define const_delay_40us		.19
#define const_delay_100us		.49
#define const_delay_560us		.111
#define const_delay_1680us		.167
#define const_delay_1ms		.199






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;cs8416 address
#define CS8416_CHIP_ADDR_W	0X20
#define CS8416_CHIP_ADDR_R		0X21

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;cs485xx address
#define CS485XX_CHIP_ADDR_W	0X80
#define CS485XX_CHIP_ADDR_R	0X81

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;eeprom address
#define EEPROM_TWR				.12		;MS
#define EEPROM_DEV_ADDR_R		0XA1
#define EEPROM_DEV_ADDR_W		0XA0


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
pt2301_trans_value		equ			0x6e			;same as pt2314 trans value.....two device shouldn't exist in one board..
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

pa_status				equ			0x83
pa_status_save			equ			0x84
pa_mask				equ			0x85
grid_key_check_counter	equ			0x86
grid_key_row			equ			0x87
grid_key_line			equ			0x88
bit_index_counter		equ			0x89
grid_key_data			equ			0x8a

ir_send_38Khz_counter	equ			0x8b
ir_send_data			equ			0x8c
ir_send_counter			equ			0x8d
ir_using_mode			equ			0x8e







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


ifndef InnoHill_LN054IH07_010
#include "adcmap.asm"
else
;#include "innkeymap.asm"
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set main entery
org			0x000				;mk7a21p的复位向量地址定义 
lgoto		main				;跳转到主程序入口   
org			0x004
lgoto		int_entry				;int entry
org 			0x0010


#include "util.asm"

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start tm1
start_tm1 macro
ifdef SoundBar_DSP_LN054IH10_010
;	;;init variable
;	movla b'01100010'
;	movam tm1_ctl1       	;TM1时钟源内部RC时钟,预分频1:4
;	;IC's clock is faster tha emulate...fix it 
;	;movla 0x09 
;	movla 0x50 
;	movam tm1l_la 
;	;movla 0x3d
;	movla 0xc3
;	movam tm1h_la  	;溢出周期50ms
;	
;	;movla b'10000010' 	;以下是中断设置 
;	;movam irqm
;	bs IRQM,TM1M
;	en_int
;	;clr irqf 
;	bc IRQF,TM1F
;	bs tm1_ctl1,7
endif	;SoundBar_DSP_LN054IH10_010
ifdef Car_Front_Panel
;	;;init variable
;	movla b'01100010'
;	movam tm1_ctl1       	;TM1时钟源内部RC时钟,预分频1:4
;	;IC's clock is faster tha emulate...fix it 
;	;movla 0x09 
;	movla 0xe8 
;	movam tm1l_la 
;	;movla 0x3d
;	movla 0x03
;	movam tm1h_la  	;溢出周期1ms
;	
;	;movla b'10000010' 	;以下是中断设置 
;	;movam irqm
;	bs IRQM,TM1M
;	en_int
;	;clr irqf 
;	bc IRQF,TM1F
;	bs tm1_ctl1,7
endif		;Car_Front_Panel
ifdef InnoHill_LN054IH07_010
;	;;init variable
;	movla b'01100111'
;	movam TM1_CTL1				;TM1时钟源内部RC时钟,预分频1:128
;	;IC's clock is faster tha emulate...fix it 
;	;movla 0x09 
;	movla 0x35 
;	movam TM1L_LA
;	;movla 0x3d
;	movla 0x0c
;	movam TM1H_LA				;溢出周期100MS
;	
;	;movla b'10000010' 	;以下是中断设置 
;	;movam irqm
;	bs IRQM,TM1M
;	en_int
;	;clr irqf 
;	bc IRQF,TM1F
;	bs TM1_CTL1,7
endif		;InnoHill_LN054IH07_010
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;stop tm1
stop_tm1 macro
	bc TM1_CTL1,7
	bc IRQM,TM1M
	;clr IRQF
	bc IRQF,TM1F
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;tm1 int
int_tm1 macro

	bc IRQF,TM1F
	;;;add the code below

	dec tm1_counter_l,m
	jnz int_tm1_end
	ej tm1_counter_h,0x00,int_tm1_overflow
	dec tm1_counter_h,m
	lgoto int_tm1_end
int_tm1_overflow
	bs my_status,tm1_overflow
ifdef HAVE_74VHC595_DRV
;	;bs my_status,tm1_overflow
;	bs set_led_src
;	bc my_status,c595_status
;	bc set_led_src
;	movla 0x00
;	movam tm1_counter_h
;	movla 0x02
;	movam tm1_counter_l
;	prepare_c595_data
;	btss my_status,c595_key_press_status
;	lgoto int_tm1_end
;	dword_add3 c595_tm1_counter_h,c595_tm1_counter_l,.1
;	dword_enj c595_tm1_counter_h,c595_tm1_counter_l,0x03,0xe8,int_tm1_end
;	bc my_status,c595_key_press_status
endif
ifdef InnoHill_LN054IH07_010
;	movla .100
;	movam tm1_counter_l
;	bc set_led_pc
;	bc set_led_dvd
;	bc set_led_dvb
;	bc set_led_tv
;	movla IR_MODE_NORMAL
;	movam ir_using_mode
;	bc TM1_CTL1,7
endif
	
int_tm1_end
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;pa int
int_pa macro
	bc IRQF,PAF
int_pa_end

endm

ifdef HAVE_I2C_DRV
#include "i2cDrv.asm"
endif

ifdef HAVE_PT2314_DRV
;#include "pt2314Drv.asm"
endif		;HAVE_PT2314_DRV

ifdef HAVE_PT2301_DRV
#include "pt2301Drv.asm"
endif ;HAVE_PT2301_DRV



ifdef HAVE_EEPROM_DRV
;ifdef SoundBar_DSP_LN054IH10_010
;#include "SBEeprom.asm"
;
;else ;;;SoundBar_DSP_LN054IH10_010
;#include "Eeprom.asm"
;endif		;;;SoundBar_DSP_LN054IH10_010
endif		;HAVE_EEPROM_DRV



ifdef HAVE_CS8416_DRV
;#include "cs8416.asm"
endif			;HAVE_CS8416_DRV

ifdef HAVE_CS_485XX_DRV
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;cs485xx hw reset
;cs485xx_reset macro
;	bc set_dsp_rst
;	lcall delay_40us
;	bs set_dsp_rst
;	lcall delay_40us
;endm
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;wait dsp irq to low
;;dsp_wait_irq_low macro 
;fun_dsp_wait_irq_low fun
;	;local dsp_wait_irq_low_wait,dsp_wait_irq_low_end
;	movla .100
;	movam tm_counter_l
;dsp_wait_irq_low_wait
;	btss test_dsp_irq
;	lgoto dsp_wait_irq_low_sucess
;	m_delay_ms .5
;	decsz tm_counter_l,m
;	lgoto dsp_wait_irq_low_wait
;	;fail
;	lcall fun_serial_fail_ack
;	lgoto dsp_wait_irq_low_end
;dsp_wait_irq_low_sucess
;	lcall fun_serial_ok_ack
;dsp_wait_irq_low_end	
;;endm
;	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;wait dsp irq low 
;dsp_wait_irq_low macro 
;	lcall fun_dsp_wait_irq_low
;endm
;
endif			;HAVE_CS_485XX_DRV



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;init power amplifier
init_amp macro
ifdef HAVE_PT2314_DRV
;	;set speak attenuation -> 0db
;	movla b'11000000'
;	movam pt2314_trans_value
;	pt2314_send_byte pt2314_trans_value
;
;	movla b'11100000'
;	movam pt2314_trans_value
;	pt2314_send_byte pt2314_trans_value
;
;	movla b'00001110'					;-17.5db
;	movam volume_value
;	pt2314_set_volume volume_value
;	pt2314_select_channel PT2314_STEREO_3
endif
ifdef HAVE_PT2301_DRV
	pt2301_mute
	movla b'00010100'					;-15db
	movam volume_value
	pt2301_set_volume volume_value

	movla b'01000010'							;enable sw-a
	movam pt2314_trans_value
	pt2301_send_byte pt2314_trans_value

	movla b'01000100'							;enable sw-b
	movam pt2314_trans_value
	pt2301_send_byte pt2314_trans_value

	movla b'01000110'							;enable sw-c
	movam pt2314_trans_value
	pt2301_send_byte pt2314_trans_value	

	movla b'01001000'							;enable sw-d
	movam pt2314_trans_value
	pt2301_send_byte pt2314_trans_value		
	
	pt2301_select_channel PT2301_STEREO_1
	pt2301_unmute
endif
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;volume up
amp_volume_up macro
ifdef HAVE_PT2314_DRV
;	pt2314_volume_up
endif
ifdef HAVE_PT2301_DRV
	pt2301_volume_up
endif
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;volume down
amp_volume_down macro
ifdef HAVE_PT2314_DRV
;	pt2314_volume_down
endif
ifdef HAVE_PT2301_DRV
	pt2301_volume_down
endif
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;select channel
amp_select_channel macro L_channel
ifdef HAVE_PT2314_DRV
;	pt2314_select_channel L_channel
endif
ifdef HAVE_PT2301_DRV
	pt2301_select_channel L_channel
endif
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
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;personal setting
ifdef Newage_LN053NA08_010
	bs set_sck
	bs set_sda
ifdef Newage_LN053NA09
	pt2301_mute
	bs set_shut_down
endif

	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
	
	init_amp

	
	bs set_led_phone
endif  ;Newage_LN053NA08_010

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;set ir_out pin set stb
ifdef HAVE_IR_FUNCTION
;	bs set_ir_out
endif
ifdef HAVE_SERIAL_CMD_FUNCTION
;	bs set_tx
endif
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;init wtd
	movla b'10000111'
	movam WDT_CTL
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;init some variable
	clr my_status
	clr enc_scan_status
	movla .32
	movam key_loop_counter

ifdef InnoHill_LN054IH07_010
;	movla .100
;	movam tm1_counter_l
;	clr ir_using_mode
endif
	
ifdef HAVE_74VHC595_DRV
;	movla .2
;	movam tm1_counter_l
;	clr tm1_counter_h
;	clr c595_save_key
;	start_tm1
endif
ifdef SoundBar_DSP_LN054IH10_010
;	init_cs8416
endif
endm
;	ret

ifdef HAVE_IR_FUNCTION
;#include "irDrv.asm"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;ir handle
;ir_key_handle macro
;	btss my_status,ir_recevie_status		;;have receive data or not..
;	lgoto ir_key_handle_end
;	bc my_status,ir_recevie_status
;
;ifdef AD_NET_3511
;	lcall send_32_bit
;endif
;ifdef Car_Front_Panel
;	;serial_send_cmd
;	lcall send_32_bit
;endif
;ifdef SoundBar_DSP_LN054IH10_010
;	dsp_key_handle data_8l
;endif
;;	serial_send_cmd
;
;	;ir_repeat
;ir_key_handle_end
;
;endm
endif			;HAVE_IR_FUNCTION

ifdef HAVE_IR_OPTICAL_DRV
;#include "irOpticalDrv.asm"
endif


ifdef HAVE_ADC_DRV
#include "adcDrv.asm"
endif

ifdef HAVE_KEY_SCAN_FUNCTION
#include "adckey.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;adc key mapping
adc_key_mapping macro
	local adc_power_key,adc_key_mapping_end
	ej adc_key,key_null,adc_key_mapping_end

ifdef Newage_LN053NA08_010
	local adc_key_mapping_volume_up,adc_key_mapping_volume_down,adc_key_mapping_phone,adc_key_mapping_pc,adc_key_mapping_keyc,adc_key_mapping_keyp,adc_key_mapping_keya
	ej adc_key,key_volume_up,adc_key_mapping_volume_up
	ej adc_key,key_volume_down,adc_key_mapping_volume_down
	ej adc_key,key_phone,adc_key_mapping_phone
	ej adc_key,key_pc,adc_key_mapping_pc
	ej adc_key,key_keyc,adc_key_mapping_keyc
	ej adc_key,key_keyp,adc_key_mapping_keyp
	ej adc_key,key_keya,adc_key_mapping_keya
adc_key_mapping_volume_up
	;pt2314_volume_up
	amp_volume_up
	lgoto adc_key_mapping_end
adc_key_mapping_volume_down
	;pt2314_volume_down	
	amp_volume_down
	lgoto adc_key_mapping_end
ifndef Newage_LN053NA09
;adc_key_mapping_phone
;	;pt2314_select_channel PT2314_STEREO_3
;	amp_select_channel PT2314_STEREO_3
;	bc set_led_pc
;	bs set_led_phone
;	lgoto adc_key_mapping_end
;adc_key_mapping_pc
;	;pt2314_select_channel PT2314_STEREO_4
;	amp_select_channel PT2314_STEREO_4
;	bs set_led_pc
;	bc set_led_phone
;	lgoto adc_key_mapping_end
else		;not Newage_LN053NA09
adc_key_mapping_phone
	;pt2301_select_channel PT2301_STEREO_1
	amp_select_channel PT2301_STEREO_1
	bc set_led_pc
	bs set_led_phone
	lgoto adc_key_mapping_end
adc_key_mapping_pc
	;pt2301_select_channel PT2301_STEREO_2
	amp_select_channel PT2301_STEREO_2
	bs set_led_pc
	bc set_led_phone
	lgoto adc_key_mapping_end
endif ;not Newage_LN053NA09


	
adc_key_mapping_keyc
	bs set_led_key_c
	bc set_led_key_a
	bc set_led_key_p
	lgoto adc_key_mapping_end
adc_key_mapping_keyp
	bc set_led_key_c
	bc set_led_key_a
	bs set_led_key_p	
	lgoto adc_key_mapping_end
adc_key_mapping_keya
	bc set_led_key_c
	bs set_led_key_a
	bc set_led_key_p	
	lgoto adc_key_mapping_end

else			;;not Newage_LN053NA08_010
;	movla custom_code
;	movam custom_8l
;	com custom_8l,a
;	movam custom_8h
;	mov adc_key,a
;	movam data_8l
;	com data_8l,a
;	movam data_8h
;ifdef Car_Front_Panel
;	;serial_send_cmd
;	lcall send_32_bit
;else		;not Car_Front_Panel
;	lcall send_32_bit
;endif		;Car_Front_Panel
endif		;Newage_LN053NA08_010

;	serial_send_cmd
	lgoto adc_key_mapping_end
adc_key_mapping_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan key
key_scan macro

	;because adc convert spent almost 660us one time , it seem a little too long to do it every loop , so had better do it one time per 32 loop..
	decsz key_loop_counter,m
	lgoto key_scan_end
	movla .32
	movam key_loop_counter
	bc my_status,key_long_press_status

	adc_get_key
	ej adc_key,key_null,key_scan_end

	;;int10int10
	mov adc_key,a
	movam adc_save_key
	adc_get_long_press_key
	ej adc_long_press_value,key_null,not_long_press_key

	movla .200
	movam adc_long_press_counter
check_long_press
	adc_get_key
	mov adc_key,a
	xor adc_save_key,a
	jnz not_long_press_key
	decsz adc_long_press_counter,m
	lgoto check_long_press
	;;;;;;;long pressed
	bs my_status,key_long_press_status
	mov adc_long_press_value,a
	movam adc_key
not_long_press_key
	adc_key_mapping

	mov adc_key,a
	movam adc_save_key

	mov adc_key,a
	xorla key_null
	jz key_scan_end
	
	movla .10
	movam key_repeat_counter
wait_key_release

ifdef Car_Front_Panel
;	mov adc_key,a
;	movam c595_save_key
;	bs my_status,c595_key_press_status
;	clr c595_tm1_counter_h
;	clr c595_tm1_counter_l
;;	prepare_c595_data
endif

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
endif			;HAVE_KEY_SCAN_FUNCTION


ifdef HAVE_SERIAL_CMD_FUNCTION
;#include "serialDrv.asm"
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;dsp start code
;dsp_startcode macro
;	i2c_startcode
;
;	lcall fun_serial_ok_ack
;endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;dsp_dev_write macro
;	i2c_bytesend_ex CS485XX_CHIP_ADDR_W		;dev addr
;	i2c_checkack
;	lcall fun_serial_ok_ack
;endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;dsp_dev_read macro
;	i2c_bytesend_ex CS485XX_CHIP_ADDR_R
;	i2c_checkack
;	lcall fun_serial_ok_ack
;endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;dsp send 4bytes ps:check bsy after send
;dsp_send_4bytes macro
;	local dsp_send_4bytes_next,dsp_send_4bytes_wait_busy_high,dsp_send_4bytes_wait_busy_high_sucess,dsp_send_4bytes_end
;	movla .4
;	movam cs485xx_byte_counter 
;	movla serial_buf_start
;	movam BSR
;	inc BSR,m			;;start from serial_buf_start+1
;dsp_send_4bytes_next
;	mov INDF,a
;	movam i2c_buf
;	i2c_bytesend
;	i2c_checkack
;	inc BSR,m
;
;	decsz cs485xx_byte_counter,m
;	lgoto dsp_send_4bytes_next
;
;	;;;wait dsp_bsy high
;	movla .5
;	movam tm_counter_l
;dsp_send_4bytes_wait_busy_high
;	btsc test_dsp_bsy
;	lgoto dsp_send_4bytes_wait_busy_high_sucess
;	lcall delay_40us
;	decsz tm_counter_l,m
;	lgoto dsp_send_4bytes_wait_busy_high
;
;	;;fail
;	lcall fun_serial_fail_ack
;	lgoto dsp_send_4bytes_end
;dsp_send_4bytes_wait_busy_high_sucess
;	lcall fun_serial_ok_ack
;dsp_send_4bytes_end	
;	clr BSR;
;endm
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;dsp_get_4bytes macro
;	local dsp_get_4bytes_next,dsp_get_4bytes_not_end,dsp_get_4bytes_end
;	movla .4
;	movam cs485xx_byte_counter
;	movla serial_buf_start
;	movam BSR
;	;inc BSR,m		;;left space for ack type
;	
;dsp_get_4bytes_next
;	i2c_byteget
;	mov i2c_buf,a
;	movam INDF
;	i2c_sendack
;	
;	inc BSR,m
;	i2c_byteget
;	mov i2c_buf,a
;	movam INDF
;	i2c_sendack
;
;	inc BSR,m
;	i2c_byteget
;	mov i2c_buf,a
;	movam INDF
;	i2c_sendack
;
;	inc BSR,m
;	i2c_byteget
;	mov i2c_buf,a
;	movam INDF
;	;i2c_sendack
;
;	clr BSR
;	btss test_dsp_irq
;	lgoto dsp_get_4bytes_not_end
;	;;;send no ack ..end
;	i2c_sendnoack
;	lcall fun_dsp_end_data_ack
;	lgoto dsp_get_4bytes_end
;
;dsp_get_4bytes_not_end
;	i2c_sendack
;	lcall fun_dsp_not_end_ack
;dsp_get_4bytes_end
;
;endm
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;dsp_stopcode macro
;	i2c_stopcode
;	lcall fun_serial_ok_ack
;endm
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;serial handle
;serial_mapping macro
;ifdef SoundBar_DSP_LN054IH10_010
;	ej cmd_value,Cmd_dsp_hw_reset,serial_mapping_dsp_hw_reset
;	ej cmd_value,Cmd_start_code,serial_mapping_start_code
;	ej cmd_value,Cmd_send_4bytes,serial_mapping_send_4bytes
;	ej cmd_value,Cmd_wait_irq_low,serial_mapping_wait_irq_low
;	ej cmd_value,Cmd_dsp_dev_write,serial_mapping_dsp_dev_write
;	ej cmd_value,Cmd_dsp_dev_read,serial_mapping_dsp_dev_read
;	ej cmd_value,Cmd_get_4bytes,serial_mapping_get_4bytes
;	ej cmd_value,Cmd_stop_code,serial_mapping_stop_code
;	ej cmd_value,Cmd_set_cs8614,serial_mapping_set_cs8614
;	ej cmd_value,Cmd_get_cs8614,serial_mapping_get_cs8614
;
;
;serial_mapping_dsp_hw_reset
;	cs485xx_reset
;	lcall fun_serial_ok_ack
;	lgoto serial_mapping_end
;serial_mapping_start_code
;	dsp_startcode
;	lgoto serial_mapping_end
;serial_mapping_send_4bytes
;	dsp_send_4bytes
;	lgoto serial_mapping_end
;serial_mapping_wait_irq_low
;	dsp_wait_irq_low
;	lgoto serial_mapping_end
;serial_mapping_dsp_dev_write
;	dsp_dev_write
;	lgoto serial_mapping_end
;serial_mapping_dsp_dev_read
;	dsp_dev_read
;	lgoto serial_mapping_end
;serial_mapping_get_4bytes
;	dsp_get_4bytes
;	lgoto serial_mapping_end
;serial_mapping_stop_code
;	dsp_stopcode
;	lgoto serial_mapping_end
;serial_mapping_set_cs8614
;	cs8416_set_data
;	lgoto serial_mapping_end
;serial_mapping_get_cs8614
;	cs8416_get_data
;	lgoto serial_mapping_end
;
;serial_mapping_end
;else		;not SoundBar_DSP_LN054IH10_010
;	ej receive_data,0xaa,serial_mapping_fm_mode
;	ej receive_data,0xbb,serial_mapping_dvd_mode
;	ej receive_data,0xcc,serial_mapping_music
;	ej receive_data,0xdd,serial_mapping_pc
;	ej receive_data,0xee,serial_mapping_aux_fp
;	ej receive_data,0xff,serial_mapping_aux_rr
;	ej receive_data,0x99,serial_mapping_power_on
;	ej receive_data,0x88,serial_mapping_power_off
;	
;serial_mapping_fm_mode
;	light_led work_mode_fm
;	lgoto serial_mapping_end
;serial_mapping_dvd_mode
;	light_led work_mode_dvd
;	lgoto serial_mapping_end
;serial_mapping_music
;	light_led work_mode_music
;	lgoto serial_mapping_end
;serial_mapping_pc
;	light_led work_mode_pc
;	lgoto serial_mapping_end
;serial_mapping_aux_fp
;	lgoto serial_mapping_end
;serial_mapping_aux_rr
;	lgoto serial_mapping_end
;serial_mapping_power_on
;	lgoto serial_mapping_end
;serial_mapping_power_off
;	lgoto serial_mapping_end
;serial_mapping_end
;	
;endif			;SoundBar_DSP_LN054IH10_010
;	
;endm
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;serial receive cmd
;serial_cmd macro
;ifdef SoundBar_DSP_LN054IH10_010
;	serial_receive_string
;	btss my_status,serial_string_receive_status
;	lgoto serial_receive_cmd_end
;	serial_mapping
;serial_receive_cmd_end
;else			;;not SoundBar_DSP_LN054IH10_010
;	serial_receive
;	btss my_status,serial_receive_status
;	lgoto serial_receive_cmd_end
;	enj receive_data,0xfe,serial_receive_cmd_end
;	serial_receive
;	btss my_status,serial_receive_status
;	lgoto serial_receive_cmd_end
;	enj receive_data,0xf3,serial_receive_cmd_end
;	serial_mapping
;serial_receive_cmd_end
;endif	;;SoundBar_DSP_LN054IH10_010
;endm
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;serial send ok ack
;fun_serial_ok_ack fun
;	;movla 0xaa
;	;movam send_data
;	;serial_send
;	movla Ack_ok
;	movam send_data
;	serial_send
;	
;	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;serial send fail ack
;fun_serial_fail_ack fun
;	;movla 0xaa
;	;movam send_data
;	;serial_send
;	movla Ack_faile
;	movam send_data
;	serial_send
;	ret
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;fun_cs8416_ack fun
;	movla Ack_8614_data
;	movam send_data
;	serial_send
;	mov cs8416_value,a
;	movam send_data
;	serial_send
;	ret
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;fun_dsp_not_end_ack fun
;	movla Ack_data_not_end
;	movam send_data
;	serial_send
;	movla serial_buf_start
;	movam BSR
;	mov INDF,a
;	movam send_data
;	serial_send
;	
;	inc BSR,m
;	mov INDF,a
;	movam send_data
;	serial_send
;
;		inc BSR,m
;	mov INDF,a
;	movam send_data
;	serial_send
;
;		inc BSR,m
;	mov INDF,a
;	movam send_data
;	serial_send
;	clr BSR
;	ret
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;fun_dsp_end_data_ack fun
;	movla Ack_data_end
;	movam send_data
;	serial_send
;	movla serial_buf_start
;	movam BSR
;	mov INDF,a
;	movam send_data
;	serial_send
;	
;	inc BSR,m
;	mov INDF,a
;	movam send_data
;	serial_send
;
;	inc BSR,m
;	mov INDF,a
;	movam send_data
;	serial_send
;
;	inc BSR,m
;	mov INDF,a
;	movam send_data
;	serial_send
;	clr BSR
;	ret
;
endif		;HAVE_SERIAL_CMD_FUNCTION




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;light the led
light_led macro work_mode
	local light_led_end
	bc set_led_dvd
	bc set_led_music
	bc set_led_fm
	bc set_led_pc
	bc set_led_phone
	movla work_mode
	add pc,m
	bs set_led_dvd
	bs set_led_music
	bs set_led_fm
	bs set_led_pc
	bs set_led_phone
light_led_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan enc
enc_scan macro
	;;int10@100825
	btss test_enc_a
	lgoto enc_a_low
	btss test_enc_b
	lgoto enc_b_low
	clr enc_scan_status				;;both high
	lgoto enc_scan_end
enc_a_low
	btss test_enc_b					;;both low
	lgoto enc_scan_end
	lgoto enc_al_bh
enc_b_low
	;btss test_enc_a
	;lgoto enc_scan_end				;;needn't check it again...now a high,b low
	lgoto enc_ah_bl

enc_al_bh
	ej enc_scan_status,ENC_IDLE,enc_get_a
	lgoto enc_scan_end

enc_ah_bl
	ej enc_scan_status,ENC_IDLE,enc_get_b
	lgoto enc_scan_end

enc_get_a
	movla ENC_A_PUSH
	movam enc_scan_status
ifdef Car_Front_Panel
;	movla key_volume_up2
;	movam c595_save_key
;	bs my_status,c595_key_press_status
;	clr c595_tm1_counter_h
;	clr c595_tm1_counter_l
endif
	m_send_key custom_code,key_volume_up2
	lgoto enc_scan_end
	
	
enc_get_b
	movla ENC_B_PUSH
	movam enc_scan_status
ifdef Car_Front_Panel
;	movla key_volume_down2
;	movam c595_save_key
;	bs my_status,c595_key_press_status
;	clr c595_tm1_counter_h
;	clr c595_tm1_counter_l
endif
	m_send_key custom_code,key_volume_down2
	lgoto enc_scan_end

enc_scan_end
endm

ifdef HAVE_74VHC595_DRV
;#include "C595Drv.asm"
endif

ifdef HAVE_EXTRA_VOL_KEY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;check the extra key that don't check at key_scan
extra_key_scan macro
	btss test_key_vol_up
	lgoto extra_key_scan_not_vol_up
	m_delay_ms .80
	btss test_key_vol_up
	lgoto extra_key_scan_end
	nop
	;pt2314_volume_up
	amp_volume_up
	lgoto extra_key_scan_end
extra_key_scan_not_vol_up
	btss test_key_vol_down
	lgoto extra_key_scan_end
	m_delay_ms .80
	btss test_key_vol_down
	lgoto extra_key_scan_end
	nop
	;pt2314_volume_down
	amp_volume_down
extra_key_scan_end
endm
endif

ifdef HAVE_GRIDKEY_FUNCTION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;grid key handle
;grid_key_handle macro
;	bc set_led_dvd
;	bc set_led_dvb
;	bc set_led_tv
;	bc set_led_pc
;	ej grid_key_data,ir_key_dvd,grid_key_dvd
;	ej grid_key_data,ir_key_pc,grid_key_pc
;	ej grid_key_data,ir_key_dvbt,grid_key_dvbt
;	ej grid_key_data,ir_key_tv,grid_key_tv
;	lgoto grid_key_nomal_key
;
;grid_key_dvd
;	;bs set_led_dvd
;	movla IR_MODE_DVD
;	movam ir_using_mode
;	lgoto grid_key_handle_get_custom
;grid_key_pc
;	;bs set_led_pc
;	movla IR_MODE_PC
;	movam ir_using_mode
;	lgoto grid_key_handle_get_custom
;grid_key_dvbt
;	;bs set_led_dvb
;	movla IR_MODE_DVBT
;	movam ir_using_mode	
;	lgoto grid_key_handle_get_custom
;grid_key_tv
;	;bs set_led_tv
;	movla IR_MODE_TV
;	movam ir_using_mode
;	lgoto grid_key_handle_get_custom
;grid_key_nomal_key
;	
;	lgoto grid_key_handle_get_custom
;grid_key_handle_get_custom
;	ej ir_using_mode,IR_MODE_DVBT,grid_key_handle_mode_dvbt
;	ej ir_using_mode,IR_MODE_TV,grid_key_handle_mode_tv
;	ej ir_using_mode,IR_MODE_DVD,grid_key_handle_mode_dvd
;	ej ir_using_mode,IR_MODE_PC,grid_key_handle_mode_pc
;	lgoto grid_key_handle_mode_normal
;
;grid_key_handle_mode_dvbt
;	bc set_led_dvd
;	bs set_led_dvb
;	bc set_led_tv
;	bc set_led_pc
;	movla ir_custom_dvbt
;	movam custom_8l
;	lgoto grid_key_handle_send_key
;grid_key_handle_mode_tv
;	bc set_led_dvd
;	bc set_led_dvb
;	bs set_led_tv
;	bc set_led_pc
;	movla ir_custom_tv
;	movam custom_8l
;	lgoto grid_key_handle_send_key
;grid_key_handle_mode_dvd
;	bs set_led_dvd
;	bc set_led_dvb
;	bc set_led_tv
;	bc set_led_pc
;	movla ir_custom_dvd
;	movam custom_8l
;	lgoto grid_key_handle_send_key
;
;grid_key_handle_mode_pc
;	bc set_led_dvd
;	bc set_led_dvb
;	bc set_led_tv
;	bs set_led_pc
;	movla ir_custom_pc
;	movam custom_8l
;	lgoto grid_key_handle_send_key
;
;grid_key_handle_mode_normal
;	bc set_led_dvd
;	bc set_led_dvb
;	bc set_led_tv
;	bc set_led_pc
;	movla ir_custom_noraml
;	movam custom_8l
;	lgoto grid_key_handle_send_key
;	
;grid_key_handle_send_key
;	stop_tm1
;	com custom_8l,a
;	movam custom_8h
;	mov grid_key_data,a
;	movam data_8l
;	com data_8l,a
;	movam data_8h
;	ir_send_optical
;
;	ej ir_using_mode,IR_MODE_NORMAL,grid_key_handle_end
;	movla .100
;	movam tm1_counter_l
;	start_tm1
;grid_key_handle_end		
;endm
;#include "Gridkey.asm"
endif		;HAVE_GRIDKEY_FUNCTION

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;int function
int_entry
	;;enter int ,save the register..
	movam a_buf 
	swap STATUS,a 
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
	movam  		STATUS
	swap   		a_buf,m
	swap   		a_buf,a	
	reti

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;main function     it must write under the macro ,or it can't call the macro
main fun
	init_chip
main_loop
	clrwdt
ifdef HAVE_IR_FUNCTION
;	ir_scan
;	ir_key_handle
endif
ifdef HAVE_KEY_SCAN_FUNCTION
	key_scan
endif
ifdef HAVE_ENC_SCAN_FUNCTION
;	enc_scan
endif
ifdef HAVE_SERIAL_CMD_FUNCTION
;	serial_cmd
endif
ifdef HAVE_EXTRA_VOL_KEY
	extra_key_scan
endif
ifdef HAVE_GRIDKEY_FUNCTION
;	gridkey_scan
endif

	lgoto main_loop
	ret


end





