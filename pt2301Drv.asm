

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;pt2301 address
#define PT2301_CHIP_ADDR			0X8E
#define PT2301_VOLUME_ADDR				0X00
#define PT2301_AUDIO_SWITCH		b'01000000'
#define PT2301_ENERGY_SAVE			b'11000000'
#define PT2301_STEREO_1			0x0
#define PT2301_STEREO_2			0x1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;pt2301 driver
;send a byte to pt2301,M is a pointer		fun mode
fun_pt2301_send_byte fun
	i2c_startcode
	i2c_bytesend_ex PT2301_CHIP_ADDR
	i2c_checkack
	i2c_bytesend_ex2 pt2301_trans_value
	i2c_checkack
	nop
	i2c_stopcode
	
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;send a byte to pt2301....    macro mode
pt2301_send_byte macro M
	mov M,a
	movam pt2301_trans_value
	lcall fun_pt2301_send_byte
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;mute pt2301
pt2301_mute macro
;	movla b'00111111'
;	movam pt2301_trans_value
;	movla PT2314_VOLUME_ADDR
;	ior pt2301_trans_value,m
;	pt2314_send_byte pt2301_trans_value
	bs set_mute
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;mute pt2301
pt2301_unmute macro
;	movla b'00111111'
;	movam pt2301_trans_value
;	movla PT2314_VOLUME_ADDR
;	ior pt2301_trans_value,m
;	pt2314_send_byte pt2301_trans_value
	bc set_mute
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;select pt2301hannel
pt2301_select_channel macro L_channel
	local pt2301_select_channel_end
	;ej pt2314_channel,L_channel,pt2314_select_channel_end
	pt2301_mute
	movla PT2301_AUDIO_SWITCH
	iorla L_channel
	movam pt2301_trans_value
	pt2301_send_byte pt2301_trans_value
	;pt2314_set_volume volume_value
	pt2301_unmute
pt2301_select_channel_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set pt2301 volume
pt2301_set_volume macro M_volume
	mov M_volume,a
	movam pt2301_trans_value
	movla PT2301_VOLUME_ADDR
	ior pt2301_trans_value,m
	pt2301_send_byte pt2301_trans_value
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;volume up.....-3db
pt2301_volume_down macro
	local pt2301_volume_down_end
	ej volume_value,b'00110000',pt2301_volume_down_end
	bj volume_value,b'00110000',pt2301_volume_down_end
	movla b'00000010'
	add volume_value,m
	pt2301_set_volume volume_value
pt2301_volume_down_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;volume down......3db
pt2301_volume_up macro
	local pt2301_volume_up_end
	ej volume_value,b'00000000',pt2301_volume_up_end
	sj volume_value,b'00000010',pt2301_volume_up_end
	movla b'00000010'
	sub volume_value,m
	pt2301_set_volume volume_value
pt2301_volume_up_end
endm

