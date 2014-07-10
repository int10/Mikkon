
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;init adc channel should be the max number of the adc channel
adc_init macro channel
	clra
	xorla channel
	movam AD_CTL1

	movla .03			;;;;;System clock X128
	movam AD_CTL2
	
;	movla b'00000001'			;;;;;;Bit3-0:PB0-3复用管脚的选择,做ADC用 
	movla channel			;;;;;;Bit3-0:PB0-3复用管脚的选择,做ADC用 
	addla .1
	movam AD_CTL3	

	clr AD_DAT_H
	clr AD_DAT_L
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;change adc channel
adc_change_channel macro channel
	clra
	xorla channel
	movam AD_CTL1
	adc_get_value channel		;;read one time to make adc stable...
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;read adc and return the value at adc_value
adc_get_value macro channel
	local adc_check_complete,adc_get_value_end,adc_get_value_delay
	movla 0xff
	movam adc_value_h
	movla 0xff
	movam adc_value_l

	clr AD_DAT_H
	clr AD_DAT_L
	bs AD_CTL1,EN

	movla .30
	movam adc_time_out_counter
adc_check_complete
	clrwdt
	lcall delay_40us
	btss AD_CTL1,EN
	lgoto adc_get_value_end
	decsz adc_time_out_counter,m
	lgoto adc_check_complete
adc_get_value_end
	mov AD_DAT_H,a
	movam adc_value_h
	mov AD_DAT_L,a
	movam adc_value_l


	movla .4			;had better have 16 instruction nop before it go to next adc_get_value
	movam adc_time_out_counter
adc_get_value_delay
	decsz adc_time_out_counter,m
	lgoto adc_get_value_delay
	
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;after read adc 5 times ,use this function to get the best value...the best value will place at adc_value
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;check whether the key can repeat , the key place at adc_key , result place at key_repeat_result
key_check_repeat macro
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
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;some key if long press , it change to another key
adc_get_long_press_key macro
	ej adc_key,key_mode_scrolling,long_key_power
	ej adc_key,key_fast_forward,long_next_track
	ej adc_key,key_fast_reward,long_pre_track
	ej adc_key,key_lcd_off,long_lcd_on
	movla key_null
	movam adc_long_press_value
	lgoto adc_get_long_press_key_end

long_key_power
	movla key_power
	movam adc_long_press_value
	lgoto adc_get_long_press_key_end
long_next_track
	movla key_next_track
	movam adc_long_press_value
	lgoto adc_get_long_press_key_end
long_pre_track
	movla key_pre_trakck
	movam adc_long_press_value
	lgoto adc_get_long_press_key_end
long_lcd_on
	movla key_lcd_on
	movam adc_long_press_value
	lgoto adc_get_long_press_key_end
adc_get_long_press_key_end
endm




