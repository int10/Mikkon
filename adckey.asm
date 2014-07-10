;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;change the adc value to key value	,place the key at adc_key
adc_2_key macro
	local adc_2_key_next,adc_2_key_not_match,adc_2_key_match,adc_2_key_end
	movla .7
	movam TAB_BNK
	movla 0x50
	movam tab_offset

adc_2_key_next
	tabrdl tab_offset
	sub adc_value,a
	jc adc_2_key_not_match
	
	tabrdh tab_offset
	xorla .0						;;;;    all number(0x00~0xff) - 0, C = 0,don't know why.....but ,fuck,and only mk7a21p have this bug,11&11bp doesn't
	jz adc_2_key_match

	sub adc_value,a
	jc adc_2_key_match
adc_2_key_not_match
	movla .2
	add tab_offset,m
	lgoto adc_2_key_next
	
adc_2_key_match
	inc tab_offset,m
	tabrdl tab_offset
	movam adc_key
adc_2_key_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get a key	read from adc and change to key value ,result at adc_key
adc_get_key macro
	local adc_check_valid_data,adc_get_valid_data,adc_get_key_end
	movla key_null
	movam adc_key
	adc_get_value ch_adc_key


	ej adc_value,0xff,adc_get_key_end
	;;int10@080708   it seems the adc module is unstable,it always read error data..so had better read it twice to improve it ..
	adc_get_value ch_adc_key
	ej adc_value,0xff,adc_get_key_end
	m_delay_ms .80
	read_adc_5times ch_adc_key

;	mov adc_value,m
;	movam send_data
;	serial_send
	
;	i2c_startcode
;	i2c_bytesend_ex2 adc_value
;	i2c_stopcode
	
	ej adc_value,0xff,adc_get_key_end


adc_get_valid_data					;now get the exact value
	adc_2_key

adc_get_key_end
endm

