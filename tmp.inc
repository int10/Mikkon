;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;no use ,just to highlight the key word




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CHIPSET;;;;;;;;;;;;;;;;;;;;;;
USE_CHIP_MK7A11P equ
USE_CHIP_MK7A21P equ 
USE_CHIP_MK6A11P equ

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROJECT;;;;;;;;;;;;;;;;;;;;;;;;;
Newage_CD_recoder equ
HenYu_PMP	equ
Newage_DMB equ
Matsunichi_PMP equ
HY_LN041B equ
IPSTB_LN090 equ
Umicore_LN090 EQU



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FEATURE;;;;;;;;;;;;;;;;;;;;;;;;;;
HAVE_USB_DETECT equ
USB_IR_MESSAGE equ
HAVE_START_UP_HANDSHAKE equ
HAVE_POWER_KEY_DELAY equ
USE_PMP_MAPPING equ
HAVE_PANEL_REPEAT EQU
HAVE_RTC_AUTO_PW_ON EQU
HAVE_IR_PW_ON EQU
PowerUpAtStart equ
HAVE_KEY_HOLP EQU
HAVE_FORCE_PW_DOWN EQU
HAVE_SLEEP_MODE EQU
HAVE_SOFT_WDT equ


bit_ir_in			equ		PB2
bit_key_in		equ		PB0
bit_ir_out		equ		PB7
bit_shut_down		equ		PB5
bit_stb			equ		PA0
bit_reset		equ		PB6
bit_led			equ		PB1

test_ir_in	macro
test_key_in macro
set_ir_out macro
test_shut_down	macro
set_stb	macro
set_stb1 macro
set_stb2 macro
set_reset	macro
set_led	macro
test_alarm macro
test_key_holp macro
test_sensor macro
test_low_pw macro
set_alarm macro
test_enc_a macro
test_enc_b macro
set_led_pc macro
set_led_phone macro
set_led_dvd macro
set_led_music macro
set_led_fm macro

bit_usb_vbus		equ	00


bit_tx equ 2
set_tx macro
bit_rx equ
test_rx macro

test_usb_vbus	macro

shut_down_counter		equ	0xc8	;;;;.200 means 2s
custom_code	equ

key_null	equ
key_power	equ
key_stop	equ
key_funtion	equ
key_up	equ
key_down	equ
key_left	equ
key_right	equ
key_enter	equ
key_fun_hold	equ
key_rec	equ
key_index	equ
key_pause	equ
key_k1	equ
key_k2	equ
key_k3	equ
key_tv_tft	equ
key_volume_up	equ
key_volume_down	equ
key_hold	equ
key_unhold	equ
key_force_shut_down	equ

key_usb_device_in	equ
key_usb_device_out	equ
key_usb_otg_in	equ
key_usb_otg_out	equ
key_rtc	equ
key_ack_ok	equ


key_menu equ
key_fun1 equ
key_fun2 equ
key_fun3 equ
key_fun4 equ
key_fun5 equ
key_fun6 equ
key_fun7 equ
key_fun8 equ
key_idle_mode equ
key_working_mode equ
normal_alarm_id equ

key_wdt equ

ir_in_pow_key	equ
ir_in_pow_key1	equ



ch_adc_key		equ 


min_panel_key_value		equ
middle_panel_key_value		equ
max_panel_key_value		equ

PORTC equ


set_mute macro


ALARM_ANNUNCIATOR EQU
PC_CONNECTER EQU
set_pwk macro
test_sms macro

test_wdt macro
fun_serial_send_string macro
fun_serial_receive_wait macro
fun_serial_receive_string macro

set_ir_power macro

CHECK_SMS_BETWEEN_CALL EQU
SEND_SMS EQU

fun_sint_get_result_wait macro
fun_init_stop_camera_par macro

id_danger_level equ

INNOHILL_LN047NH_00 EQU




set_rst_per	macro
set_rst_sys	macro
test_rst_ice	macro


HAVE_ENC_SCAN EQU
HAVE_KEY_SCAN EQU
HAVE_SERIAL_FUNTION equ 

HAVE_IR_SCAN equ




OuoNas_LN052LS10_010 equ

IR_SEND_IN_SIMPLE_MODE EQU

iodir_porta equ
iodir_portb equ


set_led_1 macro
set_led_2 macro
set_led_3 macro
set_led_4 macro
set_led_5 macro
set_led_6 macro
set_led_7 macro
set_led_8 macro
set_led_9 macro
set_led_10 macro
set_led_11 macro
set_led_12 macro


set_sck macro
set_sda macro
test_sda macro


