;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan the ir			as a sample, use portb 0 as the ir in pin
;ir_scan					;it has only two stack level , so use macro instead function
ir_scan macro
	btsc test_ir_in
	lgoto ir_scan_end
	lcall delay_100us
	btsc test_ir_in
	lgoto ir_scan_end

	;;;;;;low 9ms
	dis_int				;disable int first....
	movla .0
	movam tm_counter_l
	movam tm_counter_h
	
l_9ms
	btsc test_ir_in
	lgoto l_9ms_end
	lcall delay_100us
	inc tm_counter_l,m
	sj tm_counter_l,.90,l_9ms
	lgoto ir_scan_end		;it shouldn't come here....overflow
l_9ms_end
	movla .64			;low limit 64
	sub tm_counter_l,a
	jnc ir_scan_end

	;;;;;;high 4.5ms
	movla .0
	movam tm_counter_l
	movam tm_counter_h
h_4ms
	btss test_ir_in
	lgoto h_4ms_end
	lcall delay_100us
	inc tm_counter_l,m
	;movla .45			;avoid dead circle		high limit 45
	;sub tm_counter_l,a
	;jnc h_4ms
	sj tm_counter_l,.45,h_4ms
	lgoto ir_scan_end		;overflow
h_4ms_end
	;movla .35			;low limit 35
	;sub tm_counter_l,a
	;jnc ir_scan_end
	sj tm_counter_l,.35,ir_scan_end

	;reset the data
	movla .0
	movam custom_8h
	movam custom_8l
	movam data_8h
	movam data_8l
	movam receive_data
	movla b'00000001'
	movam value_mask
;	movla .4
;	movam byte_counter
	movla custom_8l					;bsr point to custom_8l , after receive a byte , dec ,when it's 0x30,means receive done
	movam BSR


	;begin to receive data code	
data_code
	movla .0
	movam tm_counter_l
	movam tm_counter_h
l_056ms							;low 0.56ms
	btsc test_ir_in
	lgoto l_056ms_end
	lcall delay_100us
	inc tm_counter_l,m
	;movla .8					;avoid dead circle  high limit 8
	;sub tm_counter_l,a
	;jnc l_056ms
	sj tm_counter_l,.8,l_056ms
	lgoto ir_scan_end				;overflow
l_056ms_end

;	movla .0
;	movam tm_counter_l
;	movam tm_counter_h
h_1or0							;high voltage,1:2.25-0.56ms  0:1.25-0.56ms
	btss test_ir_in
	lgoto h_1or0_end
	lcall delay_100us
	inc tm_counter_l,m
	;movla .24				;avoid dead circle high limit 24
	;sub tm_counter_l,a
	;jnc h_1or0
	sj tm_counter_l,.24,h_1or0

	lgoto ir_scan_end			;overflow
h_1or0_end
	;receive a bit check the bit is 1 or 0
	;movla .17				;>17 means receive 1 ...<17 means receive 0
	;sub tm_counter_l,a
	;jnc rec_a_bit
	sj tm_counter_l,.17,rec_a_bit

	mov value_mask,a			;receive 1
	ior receive_data,m
	;receive 0 needn't any other operate
rec_a_bit
	;;;   *_*!!!!!     must clear status .c first...
	bc STATUS,C
	rlc value_mask,m
	jc rec_a_byte
	lgoto data_code
rec_a_byte
	movla .1
	movam value_mask

	mov receive_data,a
	movam INDF
	clr receive_data
	
rec_a_byte_end
	mov BSR,a
	xorla data_8h
	jz data_code_end
	dec BSR,m 
	lgoto data_code

	
;	decsz byte_counter,m
;	lgoto data_code


	;;;;;;;;;;;;receive data end
data_code_end
	mov custom_8h,a
	and custom_8l,a
	jnz ir_scan_end
	mov data_8h,a
	and data_8l,a
	jnz ir_scan_end

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;handle
	bs my_status,ir_recevie_status
	
ir_scan_end
	;;;;;clear bsr
	clr BSR
	en_int		;;open int
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;send ir repeat key		use temp_buf to save the pin status ...0means pin is low ,1 means pin is high
ir_repeat macro
	movla 0xa6		;timeout counter 150ms
	movam tm_counter_l
	movla 0x0e
	movam tm_counter_h
	movla .0
	movam temp_buf

ir_repeat_check
	btss test_ir_in
	lgoto ir_repeat_0
ir_repeat_1
	bs set_ir_out
	movla .1
	xor temp_buf,a
	jz ir_repeat_check_end

	movla .1
	movam temp_buf
	movla 0xa6		;timeout counter 150ms
	movam tm_counter_l
	movla 0x0e
	movam tm_counter_h
	lgoto ir_repeat_check_end
	
ir_repeat_0
	bc set_ir_out
	movla .0
	xor temp_buf,a
	jz ir_repeat_check_end

	movla .0
	movam temp_buf
	movla 0xa6		;timeout counter 150ms
	movam tm_counter_l
	movla 0x0e
	movam tm_counter_h
	lgoto ir_repeat_check_end
ir_repeat_check_end
	lcall delay_40us
	decsz tm_counter_l,m
	lgoto ir_repeat_check
	decsz tm_counter_h,m
	lgoto ir_repeat_check
	
ir_repeat_end
	endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;send 32 bit data using philips order..		data place at custom_8h custom_8l data_8h data_8l
send_32_bit
	dis_int				;;;disable int 
	bc set_ir_out			;;;;;;;;;;;;;;;;;;;low 9ms
	m_delay_ms .9

	bs set_ir_out			;;;;;;;;;;;;;;;;;;;high 4ms
	m_delay_ms .4

	movla custom_8l		;bsr point to 0x33, after send a byte ,dec ,when it's 0x30 ,means send done
	movam BSR
	
send_32_bit_prepare

	mov INDF,a
	movam send_data

	;;;;;;start to send 8bit data
	movla .8
	movam bit_counter
send_a_bit
	rrc send_data,m
	jc send_1
send_0
	bc set_ir_out
	lcall delay_560us
	bs set_ir_out
	lcall delay_560us
	lgoto send_a_bit_end
send_1
	bc set_ir_out
	lcall delay_560us
	bs set_ir_out
	lcall delay_1680us
send_a_bit_end
	decsz bit_counter,m
	lgoto send_a_bit
send_8_bit_end
	mov BSR,a
	xorla data_8h
	jz send_32_bit_end
	dec BSR,m
	lgoto send_32_bit_prepare
	
send_32_bit_end
	;;;end
	;clear bsr
	clr BSR
	bc set_ir_out
	lcall delay_560us
	bs set_ir_out
	en_int				;open int
	ret



