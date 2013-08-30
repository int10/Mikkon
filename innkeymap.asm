
#define ir_custom_pc				0x30
#define ir_custom_noraml			0x10
#define ir_custom_dvd				0x00
#define ir_custom_tv				0x20
#define ir_custom_dvbt			0x40



#define ir_key_power_tv			0x4b
#define ir_key_power_main		0x01
#define ir_key_menu				0x11
#define ir_key_return				0x12
#define ir_key_screen_keyboard	0x13
#define ir_key_hdmi_out			0x14
#define ir_key_av_out				0x15
#define ir_key_aux_in				0x16
#define ir_key_pc					0x03
#define ir_key_tv					0x04
#define ir_key_dvd					0x05
#define ir_key_dvbt				0x06
#define ir_key_source				0x17
#define ir_key_favorite				0x18
#define ir_key_setup				0x19
#define ir_key_ch_up				0x1a
#define ir_key_ch_down			0x1b
#define ir_key_eject				0x1c
#define ir_key_subtitle				0x1d
#define ir_key_mute				0x21
#define ir_key_vol_up				0x22
#define ir_key_vol_down			0x23
#define ir_key_config				0x24
#define ir_key_surround			0x25
#define ir_key_effect				0x26
#define ir_key_speaker				0x27
#define ir_key_up					0x31
#define ir_key_right				0x32
#define ir_key_enter				0x33
#define ir_key_down				0x34
#define ir_key_left					0x35
#define ir_key_pf					0x36
#define ir_key_ff					0x37
#define ir_key_play_pause			0x38
#define ir_key_pb					0x39
#define ir_key_fb					0x3a
#define ir_key_stop				0x3b
#define ir_key_1					0x41
#define ir_key_2					0x42
#define ir_key_3					0x43
#define ir_key_4					0x44
#define ir_key_5					0x45
#define ir_key_6					0x46
#define ir_key_7					0x47
#define ir_key_8					0x48
#define ir_key_9					0x49
#define ir_key_0					0x40
#define ir_key_jing					0x4a
#define ir_key_xing					0x4b
#define ir_key_MKY_1				0x51
#define ir_key_MKY_2				0x52
#define ir_key_MKY_3				0x53
#define ir_key_MKY_4				0x54
#define ir_key_MKY_5				0x00
#define ir_key_MKY_6				0x00
#define ir_key_MKY_7				0x00
#define ir_key_MKY_8				0x00
#define ir_key_MKY_9				0x00
#define ir_key_MKY_10				0x00
#define ir_key_MKY_11				0x00
#define ir_key_MKY_12				0x00


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;get the value accound to the line and row of the key.....
;;;;;example,key power main,line= 6,row=1,the key positinon is 0x61,then keyvalue place 0x750+(0x61/2),and the last bit it 1,low 8bit is the value of key power main
org 0x750
db	ir_key_MKY_12,ir_key_ff		;0x0
db	ir_key_6,ir_key_5
db	ir_key_4,ir_key_play_pause
db	ir_key_fb,ir_key_MKY_10
db	ir_key_MKY_11,0x00
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00
db	0x00,ir_key_ch_up		;0x10
db	ir_key_3,ir_key_2
db	ir_key_1,0x00
db	ir_key_vol_up,ir_key_MKY_9
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00
db	ir_key_effect,ir_key_av_out		;0x20
db	ir_key_9,ir_key_8
db	ir_key_7,ir_key_hdmi_out
db	0x00,ir_key_config
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00
db	ir_key_MKY_7,ir_key_pf		;0x30
db	ir_key_jing,ir_key_0
db	ir_key_xing,ir_key_stop
db	ir_key_pb,ir_key_MKY_5
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00

db	ir_key_MKY_4,ir_key_right		;0x40
db	ir_key_subtitle,ir_key_setup
db	ir_key_menu,ir_key_enter
db	ir_key_left,ir_key_MKY_2
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00

db	ir_key_speaker,0x00		;0x50
db	ir_key_dvbt,ir_key_dvd
db	ir_key_power_tv,ir_key_aux_in
db	ir_key_source,ir_key_surround
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00

db	ir_key_MKY_8,ir_key_return		;0x60
db	ir_key_power_main,ir_key_tv
db	ir_key_pc,ir_key_down
db	ir_key_screen_keyboard,ir_key_MKY_6
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00

db	ir_key_MKY_3,ir_key_ch_down		;0x70
db	ir_key_mute,ir_key_eject
db	ir_key_favorite,ir_key_up
db	ir_key_vol_down,ir_key_MKY_1
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00

db	0x00,0x00		;0x80
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00
db	0x00,0x00




