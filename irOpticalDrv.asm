;;;;;;;;;;;;;;;;;;;;creat by int10@110323;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;drv of ir .....send a data by led


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;ir send 38Khz carrier,counter place at ir_send_38khz_counter
ir_send_38Khz macro
	local ir_send_38Khz_next,ir_send_38Khz_low_delay
ir_send_38Khz_next
	;8.77us high 
	bs set_ir_out
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	;17.53us low
	bc set_ir_out
	movla .4
	movam tm_counter_l
ir_send_38Khz_low_delay
	decsz tm_counter_l,m
	lgoto ir_send_38Khz_low_delay
	decsz ir_send_38Khz_counter,m
	lgoto ir_send_38Khz_next
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;ir send 8bit ...send data according to the ir protocol ..data place at ir_send_data
ir_send_8bit macro
	local ir_send_next_bit,ir_send_1,ir_send_0,ir_send_bit_end
	movla .8
	movam bit_counter
ir_send_next_bit
	;0.56ms 38khz carrier
	movla .21
	movam ir_send_38Khz_counter
	ir_send_38khz
	;rr ir_send_data,m
	rrc ir_send_data,m
	jnc ir_send_0
ir_send_1
	;1.68ms low
	lcall delay_1680us
	lgoto ir_send_bit_end
ir_send_0
	;0.56ms low
	lcall delay_560us
ir_send_bit_end
	decsz bit_counter,m
	lgoto ir_send_next_bit
	
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;ir send data...data place at custom_8h custom_8l data_8h data_8l
ir_send_optical macro
	local ir_send_next_byte,ir_send_end,ir_send_9ms_carrier
	;;standard is 9ms ...change it to 72ms... change back again(081107)
	;72ms 38khz carrier			;;26*27*100~72000us
	;9ms 28khz carrier				;26*2*173~9000us

	clr ir_send_counter

ir_send_9ms_carrier
	;movla .100
	movla .173
	movam ir_send_38Khz_counter
	ir_send_38Khz
	inc ir_send_counter,m
	;sj ir_send_counter,.27,ir_send_9ms_carrier
	sj ir_send_counter,.2,ir_send_9ms_carrier
	

	
	;4.5ms low
	m_delay_ms .4
	;send 32 bit data
	movla custom_8l
	movam BSR
ir_send_next_byte
	mov INDF,a
	movam ir_send_data
	ir_send_8bit
	mov BSR,a
	;andla b'00111111'

	xorla data_8h
	jz ir_send_end
	dec BSR,m
	lgoto ir_send_next_byte
ir_send_end
	;;;;;stop bit   0.56ms 38khz carrier
	movla .21
	movam ir_send_38Khz_counter
	ir_send_38Khz
	
endm

