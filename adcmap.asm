;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;adc key map
org 0x0750
ifdef AD_NET_3511
dw			0x0005
dw			key_power
dw			0x0f19
dw			key_dvd_open
dw			0x2731
dw			key_lcd_open
dw			0x3c46
dw			key_lcd_close
dw			0x4d57
dw			key_av_audio
dw			0x5c66
dw			key_pc_audio
dw			0x6b75
dw			key_dvd_audio
dw			0x7781
dw			key_loudness
dw			0x838c
dw			key_bass
dw			0x8d97
dw			key_treble
endif
ifdef Car_Front_Panel
dw			0x0005
dw			key_mute
dw			0x0711
dw			key_power
dw			0x1721
dw			key_funtion
dw			0x2731
dw			key_channel_up
dw			0x3a44
dw			key_channel_down
dw			0x4953
dw			key_play_pause
dw			0x5a64
dw			key_stop
dw			0x6a74
dw			key_lcd_open
dw			0x7983
dw			key_lcd_on
dw			0x8a94
dw			key_dvd_eject
endif

ifdef Newage_LN053NA08_010
ifdef USE_CHIP_MK7A25P
dw			0x7781
dw			key_keyp
dw			0x6c76
dw			key_keya
dw			0x5f69
dw			key_keyc
dw			0x4f59
dw			key_pc
dw			0x3e48
dw			key_phone
dw			0x2735
dw			key_volume_down
dw			0x0523
dw			key_volume_up
else			;;not USE_CHIP_MK7A25P
dw			0x7680
dw			key_keyp
dw			0x6b75
dw			key_keya
dw			0x5d67
dw			key_keyc
dw			0x4d57
dw			key_pc
dw			0x3d47
dw			key_phone
dw			0x2735
dw			key_volume_down
dw			0x0520
dw			key_volume_up
endif		;USE_CHIP_MK7A25P
endif		;Newage_LN053NA08_010
dw			0x00ff			;all data match...
dw			key_null			;end .......

;org 0x0750
;dw			0x0005
;dw			key_mode_scrolling
;dw			0x0f19
;dw			key_channel_up
;dw			0x2731
;dw			key_channel_down
;dw			0x3c46
;dw			key_fast_forward
;dw			0x4d57
;dw			key_fast_reward
;dw			0x5c66
;dw			key_play_pause
;dw			0x6b75
;dw			key_stop
;dw			0x7781
;dw			key_dvd_eject
;dw			0x838c
;dw			key_lcd_off
;dw			0x8d97
;dw			key_mute
;dw			0x00ff			;all data match...
;dw			key_null			;end .......


;;;;;;;;;;;;;;;;;;;;;;;;
;;repeat key

org 0x780
ifdef Newage_LN053NA08_010
dw			key_volume_up
dw			key_volume_down
endif
dw			key_null			;end.....

ifdef HAVE_74VHC595_DRV
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;c595 mask value
org 0x7a0
dw			key_mute
dw			0x0001
dw			key_power
dw			0x0002
dw			key_funtion
dw			0x0004
dw			key_channel_up
dw			0x0008
dw			key_channel_down
dw			0x0010
dw			key_play_pause
dw			0x0020
dw			key_stop
dw			0x0040
dw			key_lcd_open
dw			0x0080
dw			key_lcd_on
dw			0x0100
dw			key_dvd_eject
dw			0x0200
dw			key_volume_up2
dw			0x0800
dw			key_volume_down2
dw			0x0400
dw			key_null
dw			0x0000

endif


