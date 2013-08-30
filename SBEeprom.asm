;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;i2c function
e_i2c_sda_set macro
	bs set_e_sda
endm
e_i2c_sda_clear macro
	bc set_e_sda
endm
e_i2c_scl_set macro
	bs set_e_sck
endm
e_i2c_scl_clear macro
	bc set_e_sck
endm


e_i2c_sda_write_mode macro
	bc set_e_sda_dir
	nop
	nop
endm

e_i2c_sda_read_mode macro
	bs set_e_sda_dir
	nop
	nop
endm

e_i2c_sda_read macro
	bc i2c_status,i2c_sda_status
	btsc test_e_sda
	bs i2c_status,i2c_sda_status
endm


e_i2c_startcode macro
	e_i2c_SDA_SET;
	e_i2c_SCL_SET;
	clrwdt
	clrwdt
	e_i2c_SDA_CLEAR;
	clrwdt
	clrwdt
	e_i2c_SCL_CLEAR;
	clrwdt
	clrwdt
endm

e_i2c_bytesend macro 
	local e_i2c_bytesend_next,e_i2c_bytesend_1,e_i2c_bytesend_0,e_i2c_bytesend_bit_end,e_i2c_bytesend_end
	movla 0x80
	movam value_mask

e_i2c_bytesend_next
	mov value_mask,a
	and i2c_buf,a
	jz e_i2c_bytesend_0
e_i2c_bytesend_1
	e_i2c_SDA_SET
	lgoto e_i2c_bytesend_bit_end
e_i2c_bytesend_0
	e_i2c_SDA_CLEAR
e_i2c_bytesend_bit_end
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	e_i2c_SCL_SET
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	e_i2c_SCL_CLEAR
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	bc STATUS,C			;clear register C first
	rrc value_mask,m
	jc e_i2c_bytesend_end

	lgoto e_i2c_bytesend_next
e_i2c_bytesend_end
endm


e_i2c_sendack macro
	e_i2c_SDA_CLEAR;
	nop
	e_i2c_SCL_SET;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	e_i2c_SCL_CLEAR;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
endm

e_i2c_sendnoack macro
	e_i2c_SDA_SET;
	nop
	e_i2c_SCL_SET;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	e_i2c_SCL_CLEAR;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
endm


e_i2c_checkack macro
	local e_i2c_checkack_wait,e_i2c_checkack_end
	movla .255
	movam i2c_ack_counter

	e_i2c_sda_set
	clrwdt
	e_i2c_sda_read_mode
	
	e_i2c_SCL_SET;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
e_i2c_checkack_wait
	e_i2c_sda_read
	btss i2c_status,i2c_sda_status
	;btss test_sda
	lgoto e_i2c_checkack_end
	decsz i2c_ack_counter,m
	lgoto e_i2c_checkack_wait
	nop
e_i2c_checkack_end
	e_i2c_scl_clear
	e_i2c_sda_write_mode

endm

e_i2c_byteget macro
	local e_i2c_byteget_next,e_i2c_byteget_1,e_i2c_byteget_0,e_i2c_byteget_bit_end,e_i2c_byteget_end
	clr i2c_buf
	movla 0x80
	movam value_mask

	e_i2c_sda_read_mode

e_i2c_byteget_next
	e_i2c_SCL_SET
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	e_i2c_sda_read
	btss i2c_status,i2c_sda_status
	;btss test_sda
	lgoto e_i2c_byteget_0
e_i2c_byteget_1
	mov value_mask,a
	ior i2c_buf,m
	lgoto e_i2c_byteget_bit_end
e_i2c_byteget_0
e_i2c_byteget_bit_end
	e_i2c_SCL_CLEAR
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	bc STATUS,C
	rrc value_mask,m
	jc e_i2c_byteget_end
	lgoto e_i2c_byteget_next
e_i2c_byteget_end	

	e_i2c_sda_write_mode

endm

e_i2c_stopcode macro
	e_i2c_SDA_CLEAR;
	nop;
	e_i2c_SCL_SET;
	nop;
	e_i2c_SDA_SET;
	nop;
endm

e_i2c_bytesend_ex macro value
	movla value
	movam i2c_buf
	e_i2c_bytesend
endm

e_i2c_bytesend_ex2 macro value_point
	mov value_point,a
	movam i2c_buf
	e_i2c_bytesend
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;eeprom read function mode
fun_eeprom_read fun

	e_i2c_startcode
	e_i2c_bytesend_ex eeprom_dev_addr_w			;;dev addr
	e_i2c_checkack
	e_i2c_bytesend_ex2 eeprom_operate_addr_h		;;addr _h
	e_i2c_checkack
	e_i2c_bytesend_ex2 eeprom_operate_addr_l
	e_i2c_checkack
	movla serial_buf_start
	movam BSR
	e_i2c_startcode
	e_i2c_bytesend_ex eeprom_dev_addr_r
	e_i2c_checkack
eeprom_read_next
	e_i2c_byteget
	mov i2c_buf,a
	movam INDF
	inc BSR,m	
	dec eeprom_byte_counter,m
	ej eeprom_byte_counter,0x0, eeprom_read_end
	e_i2c_sendack
	;decsz eeprom_byte_counter,m
	lgoto eeprom_read_next

eeprom_read_end
	;;int10@101028
	e_i2c_sendnoack
	e_i2c_stopcode
	clr BSR
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;eeprom write fun mode
fun_eeprom_write fun
	e_i2c_startcode
	e_i2c_bytesend_ex eeprom_dev_addr_w			;;dev addr
	e_i2c_checkack
	e_i2c_bytesend_ex2 eeprom_operate_addr_h		;;addr _h
	e_i2c_checkack
	e_i2c_bytesend_ex2 eeprom_operate_addr_l		;;addr _l
	e_i2c_checkack

	movla serial_buf_start
	movam BSR
eeprom_write_next
	mov INDF,a
	movam i2c_buf
	e_i2c_bytesend
	e_i2c_checkack
	inc BSR,m
	decsz eeprom_byte_counter,m
	lgoto eeprom_write_next

	e_i2c_stopcode
	clr BSR
	m_delay_ms eeprom_twr
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;eeprom read ,par are start addr_h,start_addr_l,byte counter..ps:bytes can't bigger than .16
eeprom_read macro bytes
	movla bytes
	movam eeprom_byte_counter
	lcall fun_eeprom_read
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;eeprom read ex...call eeprom_read
eeprom_read_ex macro start_addr_h,start_addr_l,bytes
	movla start_addr_h
	movam eeprom_operate_addr_h
	movla start_addr_l
	movam eeprom_operate_addr_l
	eeprom_read bytes
	
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;eeprom read ex2
eeprom_read_ex2 macro M_bytes
	mov M_bytes,a
	movam eeprom_byte_counter
	lcall fun_eeprom_read
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;eeprom write ,par are start addr_h,start_addr_l,byte counter..ps:bytes can't bigger than .16...and data place at serial_buf_start~serial_buf_end
eeprom_write macro bytes
	movla bytes
	movam eeprom_byte_counter
	lcall fun_eeprom_write
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;eeprom write ex.... call eeprom_write
eeprom_write_ex macro start_addr_h,start_addr_l,bytes
	movla start_addr_h
	movam eeprom_operate_addr_h
	movla start_addr_l
	movam eeprom_operate_addr_l
	eeprom_write bytes
endm


