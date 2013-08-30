;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;serial send 8bit data 9600bps 		data place at send_data
serial_send_8bit macro
	local send_next_bit,send_1,send_0,send_bit_end,send_8bit_end
	movla .8
	movam bit_counter
send_next_bit
	;rr send_data,m
	rrc send_data,m
	jnc send_0
send_1
	bs set_tx
	lgoto send_bit_end
send_0
	bc set_tx
send_bit_end
	lcall delay_100us
	decsz bit_counter,m
	lgoto send_next_bit
send_8bit_end

endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;serial send 9600bps data place at send_data fun mode
fun_serial_send fun
	dis_int
	;;start bit 
	bc set_tx
	lcall delay_100us
	;;start to send 8bit data
	serial_send_8bit
	;;stop bit
	bs set_tx
	lcall delay_100us
	en_int	
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;serial send	9600bps		data place at send_data macro mode
serial_send macro
	lcall fun_serial_send
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;serial send cmd ,data place at custom_8l &data_8l
serial_send_cmd macro
	mov custom_8l,a
	movam send_data
	serial_send
	mov data_8l,a
	movam send_data
	serial_send
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;serial send cmd
serial_send_cmd_ex macro custom,data
	movla custom
	movam send_data
	serial_send
	movla data
	movam send_data
	serial_send
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;serial receive 8bit data 9600bps 			after receive,place it at receive_data
serial_receive_8bit macro
	local receive_next_bit,receive_1,receive_0,receive_bit_end,receive_8bit_end
	;init variable
	clr receive_data
	movla .1
	movam value_mask

receive_next_bit
	lcall delay_100us
	btss test_rx
	lgoto receive_0
receive_1
	mov value_mask,a
	ior receive_data,m
receive_0
receive_bit_end
	bc STATUS,C
	;rl value_mask,m
	rlc value_mask,m
	jc receive_8bit_end
	lgoto receive_next_bit
receive_8bit_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;serial receive fun mode
fun_serial_receive fun
	;;start bit 
	clr receive_data
	bc my_status,serial_receive_status
	btsc test_rx
	lgoto serial_receive_end
	btsc test_rx
	lgoto serial_receive_end
	dis_int

	;ps:make sure the sample timing is in the middle of the stable state,then I sample per 100us,avoid sampling at the changing edge or any other wrong time
	lcall delay_40us
	;;start to receive 8bit data
	serial_receive_8bit
	bs my_status,serial_receive_status
	;;stop bit .... after delay 100us ,wait about 65us to make sure receive the complete bit ...
	;;but if test_rx change to low ,means next byte is coming ,must quit and change to receive next byte immediately
	lcall delay_100us
	movla 17
	movam tm_counter_l
serial_receive_stop_bit_wait
	btss test_rx
	lgoto serial_receive_end
	decsz tm_counter_l,m
	lgoto serial_receive_stop_bit_wait
	
serial_receive_end
	en_int

	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;serial receive 9600bps		after received ,place it at receive_data 
serial_receive macro
	;local serial_receive_end,serial_receive_stop_bit_wait
	lcall fun_serial_receive
	
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;receive a string ..... data place at serial_buf_base
serial_receive_string macro
	local serial_receive_string_next_byte,serial_receive_string_sucess,serial_receive_string_end
	movla serial_buf_start
	movam BSR
	bc my_status,serial_string_receive_status
	movla 0x05
	movam serial_byte_counter

serial_receive_string_next_byte
	serial_receive
	btss my_status,serial_receive_status
	lgoto serial_receive_string_end
	mov receive_data,a
	movam INDF
	;ej receive_data,0x0a,serial_receive_string_sucess
	inc BSR,m
	;ej BSR,serial_buf_end,serial_receive_string_end
	dec serial_byte_counter,m
	ej serial_byte_counter,0,serial_receive_string_sucess
	;;for different device may not send next byte immediately,it should be delay .....so had better check it for a time to make sure the package is complete...but if last byte had received,needn't do it ..
	movla 0xff
	movam tm_counter_l
serial_receive_string_wait_next_byte
	btss test_rx
	lgoto serial_receive_string_next_byte
	decsz tm_counter_l,m
	lgoto serial_receive_string_wait_next_byte
	
	lgoto serial_receive_string_end				;;time out ......
serial_receive_string_sucess
	bs my_status,serial_string_receive_status
serial_receive_string_end
	clr BSR
endm



