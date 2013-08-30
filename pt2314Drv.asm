
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;pt2314 address
#define PT2314_CHIP_ADDR		0X88
#define PT2314_VOLUME_ADDR	0X00
#define PT2314_SPEAKER_L_ADDR	b'11000000'
#define PT2314_SPEAKER_R_ADDR	b'11100000'
#define PT2314_AUDIO_SWITCH_ADDR	b'01000000'
#define PT2314_BASS_ADDR		b'01100000'
#define PT2314_TREBLE_ADDR		b'01110000'
#define PT2314_STEREO_1			0x0
#define PT2314_STEREO_2			0x1
#define PT2314_STEREO_3			0x2
#define PT2314_STEREO_4			0x3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;pt2314 driver
;send a byte to pt2314,M is a pointer		fun mode
fun_pt2314_send_byte fun
	i2c_startcode
	i2c_bytesend_ex PT2314_CHIP_ADDR
	i2c_checkack
	i2c_bytesend_ex2 pt2314_trans_value
	i2c_checkack
	nop
	i2c_stopcode
	
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;send a byte to pt2314....    macro mode
pt2314_send_byte macro M
	mov M,a
	movam pt2314_trans_value
	lcall fun_pt2314_send_byte
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;mute pt2314
pt2314_mute macro
	movla b'00111111'
	movam pt2314_trans_value
	movla PT2314_VOLUME_ADDR
	ior pt2314_trans_value,m
	pt2314_send_byte pt2314_trans_value
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;select pt2314 channel
pt2314_select_channel macro L_channel
	local pt2314_select_channel_end
	;ej pt2314_channel,L_channel,pt2314_select_channel_end
	pt2314_mute
	movla b'01011100'
	iorla L_channel
	movam pt2314_trans_value
	pt2314_send_byte pt2314_trans_value
	pt2314_set_volume volume_value
pt2314_select_channel_end
endm




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set pt2314 volume
pt2314_set_volume macro M_volume
	mov M_volume,a
	movam pt2314_trans_value
	movla PT2314_VOLUME_ADDR
	ior pt2314_trans_value,m
	pt2314_send_byte pt2314_trans_value
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;volume up.....-5db
pt2314_volume_down macro
	local pt2314_volume_down_end
	ej volume_value,b'00111110',pt2314_volume_down_end
	bj volume_value,b'00111110',pt2314_volume_down_end
	movla b'00000010'
	add volume_value,m
	pt2314_set_volume volume_value
pt2314_volume_down_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;volume down......5db
pt2314_volume_up macro
	local pt2314_volume_up_end
	ej volume_value,b'00000000',pt2314_volume_up_end
	sj volume_value,b'00000010',pt2314_volume_up_end
	movla b'00000010'
	sub volume_value,m
	pt2314_set_volume volume_value
pt2314_volume_up_end
endm
