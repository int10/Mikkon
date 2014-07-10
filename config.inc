;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;20100728     Newage_CD_recoder move to main_7a_6a11.asm ........remove it

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CHIPSET;;;;;;;;;;;;;;;;;;;;;;
#define USE_CHIP_MK7A21P
#include "mk7a21p.inc"



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROJECT;;;;;;;;;;;;;;;;;;;;;;;;;
;#define HenYu_PMP
;#define HY_LN041B			;base on HenYu_PMP ,and add watch-dog
;#define Newage_DMB
;#define Matsunichi_PMP
;#define IPSTB_LN090
;#define Umicore_LN090
;#define INNOHILL_LN047NH_00
#define INNOHILL_LN054IH10_010


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FEATURE;;;;;;;;;;;;;;;;;;;;;;;;;;
;#define HAVE_USB_DETECT
;#define USB_IR_MESSAGE
;#define HAVE_START_UP_HANDSHAKE
;#define HAVE_POWER_KEY_DELAY
;#define USE_PMP_MAPPING
;#define HAVE_PANEL_REPEAT
;#define HAVE_RTC_AUTO_PW_ON
;#define HAVE_IR_PW_ON
;#define PowerUpAtStart
;#define HAVE_KEY_HOLP				;had better don't use it with HAVE_FORCE_PW_DOWN
;#define HAVE_FORCE_PW_DOWN		;had better don't use it with HAVE_KEY_HOLP
;#define HAVE_SOFT_WDT
;#define HAVE_SHUT_DOWN_DETECT

;;;;;;;;;;;;;;;;;;;;;CHANGE SOME KEY WORDS TO MK7A11P , FOR USE ONE CODE TO HANDLE THE TWO CHIP ;;;;;;;;;;;
ifdef USE_CHIP_MK7A21P
#define PORTB PB_DAT
#define PORTA PA_DAT
#define PORTC PC_DAT
#define BSR FSR
endif


ifdef HenYu_PMP
bit_ir_in			equ		PB2
;bit_key_in		equ		PB0
bit_ir_out		equ		PC3
bit_shut_down	equ		PC2;PA4
bit_stb			equ		PA3
bit_reset		equ		PA5
bit_usb_vbus	equ		PA2
bit_mute		equ		PC0
bit_alarm		equ		PA4
bit_key_holp	equ		PB3


#define	test_ir_in		PORTB,bit_ir_in
;#define	test_key_in	PORTB,bit_key_in
#define	set_ir_out	PORTC,bit_ir_out
;#define	test_shut_down	PORTA,bit_shut_down
#define	test_shut_down	PORTC,bit_shut_down
#define	set_stb			PORTA,bit_stb
#define	set_reset			PORTA,bit_reset
#define	test_usb_vbus		PORTA,bit_usb_vbus
#define	set_mute			PORTC,bit_mute
#define	test_alarm		PORTA,bit_alarm
#define	test_key_holp		PORTB,bit_key_holp

#define	ch_adc_key		0x00

;#define HAVE_USB_DETECT
;#define USB_IR_MESSAGE
;#define HAVE_START_UP_HANDSHAKE
;#define HAVE_POWER_KEY_DELAY

#define HAVE_USB_DETECT
#define USB_IR_MESSAGE
#define HAVE_START_UP_HANDSHAKE
#define PowerUpAtStart
#define HAVE_RTC_AUTO_PW_ON
#define HAVE_KEY_HOLP
#define HAVE_FORCE_PW_DOWN
;#define HAVE_IR_PW_ON
#define HAVE_SHUT_DOWN_DETECT

endif

ifdef HY_LN041B
bit_ir_in			equ		PB2
;bit_key_in		equ		PB0
bit_ir_out		equ		PC3
bit_shut_down	equ		PC2;PA4
bit_stb			equ		PA3
bit_reset		equ		PA5
bit_usb_vbus	equ		PA2
bit_mute		equ		PC0
bit_alarm		equ		PA4
bit_key_holp	equ		PB3


#define	test_ir_in		PORTB,bit_ir_in
;#define	test_key_in	PORTB,bit_key_in
#define	set_ir_out	PORTC,bit_ir_out
;#define	test_shut_down	PORTA,bit_shut_down
#define	test_shut_down	PORTC,bit_shut_down
#define	set_stb			PORTA,bit_stb
#define	set_reset			PORTA,bit_reset
#define	test_usb_vbus		PORTA,bit_usb_vbus
#define	set_mute			PORTC,bit_mute
#define	test_alarm		PORTA,bit_alarm
#define	test_key_holp		PORTB,bit_key_holp

#define	ch_adc_key		0x00

;#define HAVE_USB_DETECT
;#define USB_IR_MESSAGE
;#define HAVE_START_UP_HANDSHAKE
;#define HAVE_POWER_KEY_DELAY

#define HAVE_USB_DETECT
#define USB_IR_MESSAGE
#define HAVE_START_UP_HANDSHAKE
#define PowerUpAtStart
#define HAVE_RTC_AUTO_PW_ON
#define HAVE_KEY_HOLP
#define HAVE_FORCE_PW_DOWN
#define HAVE_SOFT_WDT
#define HAVE_SHUT_DOWN_DETECT

endif



ifdef Newage_DMB
bit_ir_in			equ		PB2
bit_ir_out		equ		PC3
bit_shut_down	equ		PC2;PA4
bit_stb			equ		PA3
bit_reset		equ		PA5
bit_mute		equ		PC0
bit_alarm		equ		PA4

#define	test_ir_in		PORTB,bit_ir_in
#define	set_ir_out	PORTC,bit_ir_out
#define	test_shut_down	PORTC,bit_shut_down
#define	set_stb			PORTA,bit_stb
#define	set_reset			PORTA,bit_reset
#define	test_alarm		PORTA,bit_alarm

#define	ch_adc_key		0x00

;#define HAVE_START_UP_HANDSHAKE
;#define HAVE_POWER_KEY_DELAY
#define HAVE_RTC_AUTO_PW_ON
#define HAVE_IR_PW_ON
#define HAVE_SHUT_DOWN_DETECT

endif


ifdef Matsunichi_PMP
bit_ir_in			equ		PB2
bit_ir_out		equ		PC3
bit_shut_down	equ		PC2;PA4
bit_stb			equ		PA3
bit_reset		equ		PA5
bit_usb_vbus	equ		PA2
bit_mute		equ		PC0
bit_alarm		equ		PA4
bit_key_holp	equ		PB3

#define	test_ir_in		PORTB,bit_ir_in
#define	set_ir_out	PORTC,bit_ir_out
#define	test_shut_down	PORTC,bit_shut_down
#define	set_stb			PORTA,bit_stb
#define	set_reset			PORTA,bit_reset
#define	test_usb_vbus		PORTA,bit_usb_vbus
#define	set_mute			PORTC,bit_mute
#define	test_alarm		PORTA,bit_alarm
#define	test_key_holp		PORTB,bit_key_holp

#define	ch_adc_key		0x00

#define HAVE_USB_DETECT
#define USB_IR_MESSAGE
#define HAVE_START_UP_HANDSHAKE
#define PowerUpAtStart
#define HAVE_RTC_AUTO_PW_ON
#define HAVE_KEY_HOLP
#define HAVE_FORCE_PW_DOWN
#define HAVE_IR_PW_ON
#define HAVE_SHUT_DOWN_DETECT

endif

ifdef IPSTB_LN090
bit_ir_in			equ		PB2
;bit_key_in		equ		PB0
bit_ir_out		equ		PC3
bit_shut_down	equ		PC2;PA4
bit_stb			equ		PA3
bit_reset		equ		PA5
bit_usb_vbus	equ		PA2
bit_mute		equ		PC0
bit_alarm		equ		PA4
bit_key_holp	equ		PB3
bit_stb1			equ		PA2
bit_stb2			equ		PB3


#define	test_ir_in		PORTB,bit_ir_in
;#define	test_key_in	PORTB,bit_key_in
#define	set_ir_out	PORTC,bit_ir_out
;#define	test_shut_down	PORTA,bit_shut_down
#define	test_shut_down	PORTC,bit_shut_down
#define	set_stb			PORTA,bit_stb
#define	set_reset			PORTA,bit_reset
#define	test_usb_vbus		PORTA,bit_usb_vbus
#define	set_mute			PORTC,bit_mute
#define	test_alarm		PORTA,bit_alarm
#define	test_key_holp		PORTB,bit_key_holp
#define	set_stb1			PORTA,bit_stb1
#define	set_stb2			PORTB,bit_stb2

#define	ch_adc_key		0x00

;#define HAVE_USB_DETECT
;#define USB_IR_MESSAGE
;#define HAVE_START_UP_HANDSHAKE
;#define HAVE_POWER_KEY_DELAY

;#define HAVE_USB_DETECT
;#define USB_IR_MESSAGE
#define PowerUpAtStart
;#define HAVE_RTC_AUTO_PW_ON
;#define HAVE_KEY_HOLP
#define HAVE_FORCE_PW_DOWN
#define HAVE_SHUT_DOWN_DETECT

endif

ifdef Umicore_LN090
;bit_ir_in			equ		PB2
bit_ir_in			equ		PC3
;bit_key_in		equ		PB0
;bit_ir_out		equ		PC3
bit_ir_out		equ		PB2
bit_shut_down	equ		PC2;PA4
bit_stb			equ		PA3
bit_reset		equ		PA5
bit_usb_vbus	equ		PA2
bit_mute		equ		PC0
bit_alarm		equ		PA4
bit_key_holp	equ		PB3
bit_stb1			equ		PA2
bit_stb2			equ		PB3


;#define	test_ir_in		PORTB,bit_ir_in
#define	test_ir_in		PORTC,bit_ir_in
;#define	test_key_in	PORTB,bit_key_in
;#define	set_ir_out	PORTC,bit_ir_out
#define	set_ir_out	PORTB,bit_ir_out
;#define	test_shut_down	PORTA,bit_shut_down
#define	test_shut_down	PORTC,bit_shut_down
#define	set_stb			PORTA,bit_stb
#define	set_reset			PORTA,bit_reset
#define	test_usb_vbus		PORTA,bit_usb_vbus
#define	set_mute			PORTC,bit_mute
#define	test_alarm		PORTA,bit_alarm
#define	test_key_holp		PORTB,bit_key_holp
#define	set_stb1			PORTA,bit_stb1
#define	set_stb2			PORTB,bit_stb2

#define	ch_adc_key		0x00

;#define HAVE_USB_DETECT
;#define USB_IR_MESSAGE
;#define HAVE_START_UP_HANDSHAKE
;#define HAVE_POWER_KEY_DELAY

;#define HAVE_USB_DETECT
;#define USB_IR_MESSAGE
#define PowerUpAtStart
;#define HAVE_RTC_AUTO_PW_ON
;#define HAVE_KEY_HOLP
#define HAVE_FORCE_PW_DOWN
#define HAVE_SHUT_DOWN_DETECT

endif

ifdef INNOHILL_LN047NH_00
bit_ir_in			equ PB2
bit_ir_out		equ PC3
bit_rx			equ PA3
bit_tx			equ PA2
bit_stb			equ PB3
bit_rst_per		equ PA4
bit_rst_sys		equ PA5
bit_rst_ice		equ PC2
bit_shut_down	equ PC1;PA4
bit_reset		equ bit_rst_sys
bit_mute		equ		PC0


#define test_ir_in			PORTB,bit_ir_in
#define set_ir_out		PORTC,bit_ir_out
#define set_tx 			PORTC,bit_tx
#define test_rx 			PORTC,bit_rx
#define set_stb			PORTB,bit_stb
#define set_rst_per		PORTA,bit_rst_per
#define set_rst_sys		PORTA,bit_rst_sys
#define test_rst_ice		PORTC,bit_rst_ice
#define	test_shut_down	PORTC,bit_shut_down
#define set_reset			set_rst_sys

#define	ch_adc_key		0x00

;#define HAVE_USB_DETECT
;#define USB_IR_MESSAGE
;#define HAVE_START_UP_HANDSHAKE
;#define HAVE_POWER_KEY_DELAY

;#define HAVE_USB_DETECT
;#define USB_IR_MESSAGE
#define PowerUpAtStart
;#define HAVE_RTC_AUTO_PW_ON
;#define HAVE_KEY_HOLP
;#define HAVE_FORCE_PW_DOWN
#define HAVE_SHUT_DOWN_DETECT

endif

ifdef INNOHILL_LN054IH10_010
bit_ir_in			equ PC3
bit_ir_out		equ PB2
bit_stb			equ PA3
bit_shut_down	equ PC2;PA4
bit_reset		equ PA5
bit_mute		equ PC0
bit_bm2			equ PB3


#define test_ir_in			PORTB,bit_ir_in
#define set_ir_out		PORTC,bit_ir_out
#define set_stb			PORTB,bit_stb
#define	test_shut_down	PORTC,bit_shut_down
#define set_reset			PORTA,bit_reset
#define set_mute			PORTC,bit_mute
#define set_bm2			PORTB,bit_bm2

#define	ch_adc_key		0x00

pa_dir_value	equ b'11010111'
pb_dir_value	equ b'11110011'
pc_dir_value	equ b'11111010'

;#define HAVE_USB_DETECT
;#define USB_IR_MESSAGE
;#define HAVE_START_UP_HANDSHAKE
;#define HAVE_POWER_KEY_DELAY
;#define USE_PMP_MAPPING
;#define HAVE_PANEL_REPEAT
;#define HAVE_RTC_AUTO_PW_ON
;#define HAVE_IR_PW_ON
#define PowerUpAtStart
;#define HAVE_KEY_HOLP
;#define HAVE_FORCE_PW_DOWN
;#define HAVE_SOFT_WDT
;#define HAVE_SHUT_DOWN_DETECT


endif



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;delay const

#define const_delay_40us		.19
#define const_delay_100us		.49
#define const_delay_560us		.111
#define const_delay_1680us		.167
#define const_delay_1ms		.199


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;panel map
#define min_panel_key_value				0x05
#define middle_panel_key_value				0x1a
#define max_panel_key_value				0xfd


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;shut down counter
#define shut_down_counter			0x0e;;;;.14 means 140ms

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;soft wdt counter const
soft_wdt_idle_counter_const_l		equ	0x82
soft_wdt_idle_counter_const_h		equ	0x8b	;almost 5S



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;some key define

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

#define key_menu					0x16
#define key_fun1					0x17
#define key_fun2					0x18
#define key_fun3					0x19
#define key_fun4					0x1a
#define key_fun5					0x1b
#define key_fun6					0x1c
#define key_fun7					0x1d
#define key_fun8					0x1e


#define key_usb_device_in			0x20
#define key_usb_device_out			0x21
#define key_usb_otg_in				0x22
#define key_usb_otg_out			0x23
#define key_rtc					0x24
#define key_ack_ok				0x25
#define key_wdt					0x26



ifdef Newage_DMB
#define ir_in_pow_key				0x03
#define ir_in_pow_key1				0x03
endif
ifdef Matsunichi_PMP
#define ir_in_pow_key				0x14
#define ir_in_pow_key1				0x14
endif

