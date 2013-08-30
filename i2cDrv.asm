;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;i2c function
i2c_sda_set macro
	bs set_sda
endm
i2c_sda_clear macro
	bc set_sda
endm
i2c_scl_set macro
	bs set_sck
endm
i2c_scl_clear macro
	bc set_sck
endm


i2c_sda_write_mode macro
	bc set_sda_dir
	nop
	nop
endm

i2c_sda_read_mode macro
	bs set_sda_dir
	nop
	nop
endm

i2c_sda_read macro
	bc i2c_status,i2c_sda_status
	btsc test_sda
	bs i2c_status,i2c_sda_status
endm


;i2c_startcode macro
fun_i2c_startcode fun
	i2c_sda_set;
	i2c_scl_set;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt	
	i2c_sda_clear;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt	
	i2c_scl_clear;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt	
;endm
	ret

i2c_startcode macro
	lcall fun_i2c_startcode
endm

;i2c_bytesend macro 
fun_i2c_bytesend fun
	;local i2c_bytesend_next,i2c_bytesend_1,i2c_bytesend_0,i2c_bytesend_bit_end,i2c_bytesend_end
	movla 0x80
	movam value_mask

i2c_bytesend_next
	mov value_mask,a
	and i2c_buf,a
	jz i2c_bytesend_0
i2c_bytesend_1
	i2c_sda_set
	lgoto i2c_bytesend_bit_end
i2c_bytesend_0
	i2c_sda_clear
i2c_bytesend_bit_end
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	i2c_scl_set
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	i2c_scl_clear
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	bc STATUS,C			;clear register C first
	rrc value_mask,m
	jc i2c_bytesend_end

	lgoto i2c_bytesend_next
i2c_bytesend_end
;endm
	ret

i2c_bytesend macro 
	lcall fun_i2c_bytesend
endm



;i2c_sendack macro
fun_i2c_sendack fun
	i2c_sda_clear;
	nop
	i2c_scl_set;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	i2c_scl_clear;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
;endm
	ret
i2c_sendack macro
	lcall fun_i2c_sendack
	endm

;i2c_sendnoack macro
fun_i2c_sendnoack fun
	i2c_sda_set;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	i2c_scl_set;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	i2c_scl_clear;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
;endm
	ret

i2c_sendnoack macro
	lcall fun_i2c_sendnoack
endm


;i2c_checkack macro
fun_i2c_checkack fun
	;local i2c_checkack_wait,i2c_checkack_end
	movla .255
	movam i2c_ack_counter

	i2c_sda_set
	clrwdt
	i2c_sda_read_mode
	
	i2c_scl_set;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
i2c_checkack_wait
	i2c_sda_read
	btss i2c_status,i2c_sda_status
	;btss test_sda
	lgoto i2c_checkack_sucess
	decsz i2c_ack_counter,m
	lgoto i2c_checkack_wait
	nop				;;;;ack fail
	i2c_scl_clear
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	lcall fun_i2c_stopcode
	lgoto i2c_checkack_end
i2c_checkack_sucess
	i2c_scl_clear
i2c_checkack_end
	i2c_sda_write_mode

;endm
	ret

i2c_checkack macro
	lcall fun_i2c_checkack
endm

fun_i2c_byteget fun
;i2c_byteget macro
	;local i2c_byteget_next,i2c_byteget_1,i2c_byteget_0,i2c_byteget_bit_end,i2c_byteget_end
	clr i2c_buf
	movla 0x80
	movam value_mask

	i2c_sda_read_mode

i2c_byteget_next
	i2c_scl_set
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt	
	i2c_sda_read
	btss i2c_status,i2c_sda_status
	;btss test_sda
	lgoto i2c_byteget_0
i2c_byteget_1
	mov value_mask,a
	ior i2c_buf,m
	lgoto i2c_byteget_bit_end
i2c_byteget_0
i2c_byteget_bit_end
	i2c_scl_clear
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	bc STATUS,C
	rrc value_mask,m
	jc i2c_byteget_end
	lgoto i2c_byteget_next
i2c_byteget_end	

	i2c_sda_write_mode
;endm
	ret

i2c_byteget macro 
	lcall fun_i2c_byteget
endm

;i2c_stopcode macro
fun_i2c_stopcode fun
	i2c_sda_clear;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	i2c_scl_set;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt	
	i2c_sda_set;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
;endm
	ret

i2c_stopcode macro
	lcall fun_i2c_stopcode
endm

i2c_bytesend_ex macro value
	movla value
	movam i2c_buf
	i2c_bytesend
endm

i2c_bytesend_ex2 macro value_point
	mov value_point,a
	movam i2c_buf
	i2c_bytesend
endm
