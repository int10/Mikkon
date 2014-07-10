
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;eeprom read function mode
fun_eeprom_read fun

	i2c_startcode
	i2c_bytesend_ex eeprom_dev_addr_w			;;dev addr
	i2c_checkack
	i2c_bytesend_ex2 eeprom_operate_addr_h		;;addr _h
	i2c_checkack
	i2c_bytesend_ex2 eeprom_operate_addr_l
	i2c_checkack
	movla serial_buf_start
	movam BSR
	i2c_startcode
	i2c_bytesend_ex eeprom_dev_addr_r
	i2c_checkack
eeprom_read_next
	i2c_byteget
	mov i2c_buf,a
	movam INDF
	inc BSR,m	
	dec eeprom_byte_counter,m
	ej eeprom_byte_counter,0x0, eeprom_read_end
	i2c_sendack
	;decsz eeprom_byte_counter,m
	lgoto eeprom_read_next

eeprom_read_end
	;;int10@101028
	i2c_sendnoack
	i2c_stopcode
	clr BSR
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;eeprom write fun mode
fun_eeprom_write fun
	i2c_startcode
	i2c_bytesend_ex eeprom_dev_addr_w			;;dev addr
	i2c_checkack
	i2c_bytesend_ex2 eeprom_operate_addr_h		;;addr _h
	i2c_checkack
	i2c_bytesend_ex2 eeprom_operate_addr_l		;;addr _l
	i2c_checkack

	movla serial_buf_start
	movam BSR
eeprom_write_next
	mov INDF,a
	movam i2c_buf
	i2c_bytesend
	i2c_checkack
	inc BSR,m
	decsz eeprom_byte_counter,m
	lgoto eeprom_write_next

	i2c_stopcode
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

