;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set mask base key value
c595_set_mask macro
	local c595_set_mask_next,c595_set_mask_found,c595_set_mask_end
	clr c595_mask_h
	clr c595_mask_l
	btss my_status,c595_key_press_status
	lgoto c595_set_mask_end
	movla 0x07
	movam TAB_BNK
	movla 0xa0
	movam tab_offset

c595_set_mask_next
	tabrdl tab_offset
	xorla key_null
	jz c595_set_mask_end

	tabrdl tab_offset
	xor c595_save_key,a
	jz c595_set_mask_found

	movla .2
	add tab_offset,m
	lgoto c595_set_mask_next
	
c595_set_mask_found
	inc tab_offset,m
	tabrdh tab_offset
	movam c595_mask_h
	tabrdl tab_offset
	movam c595_mask_l
	
c595_set_mask_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set data into C595
c595_set_data macro mdata
	local set_c595_data_next_bit,c595_set_data_1,c595_set_data_0,c595_set_data_bit_end,c595_set_data_end
	mov mdata,a
	movam send_data
	com send_data,m							;;;0:light on , 1:light off		..com it for easier understand
	movla .8
	movam bit_counter
set_c595_data_next_bit
	bc STATUS,C
	rlc send_data,m
	jnc c595_set_data_0
c595_set_data_1
	bs set_led_sda
	lgoto c595_set_data_bit_end
c595_set_data_0
	bc set_led_sda
c595_set_data_bit_end
	bc set_led_sck
	bs set_led_sck
	;bc set_led_src
	;bs set_led_src
	decsz bit_counter,m
	lgoto set_c595_data_next_bit
	bc set_led_sck		;;;;end
c595_set_data_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;prepare c595 data
prepare_c595_data macro
	local c595_pin_low,prepare_c595_data_set,prepare_c595_data_end
	btsc my_status,c595_status
	lgoto prepare_c595_data_end
	btss my_status,c595_pin_status
	lgoto c595_pin_low
	c595_set_mask					;;pin is high now change to low
	;movla 0x00	
	;movam c595_data_h
	;movam c595_data_l
	mov c595_mask_h,a
	movam c595_data_h
	mov c595_mask_l,a
	movam c595_data_l
	
	bc my_status,c595_pin_status
	lgoto prepare_c595_data_set
	
c595_pin_low							;;pin is low now ,change to high
	movla 0xff
	movam c595_data_h
	movam c595_data_l
	;clr c595_data_h
	;clr c595_data_l
	bs my_status,c595_pin_status
prepare_c595_data_set
	c595_set_data c595_data_h
	c595_set_data c595_data_l
	bs my_status,c595_status
prepare_c595_data_end	
endm
