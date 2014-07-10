;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;cs8416 write data fun mode
fun_cs8416_write fun
	i2c_startcode
	i2c_bytesend_ex CS8416_CHIP_ADDR_W
	i2c_checkack
	i2c_bytesend_ex2 cs8416_oper_addr
	i2c_checkack
	i2c_bytesend_ex2 cs8416_value
	i2c_checkack
	i2c_stopcode
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;cs8416 write data	 macro mode
cs8416_write macro L_addr,L_value
	movla L_addr
	movam cs8416_oper_addr
	movla L_value
	movam cs8416_value
	lcall fun_cs8416_write
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;cs8416 read data  fun mode
fun_cs8416_read fun
	i2c_startcode
	i2c_bytesend_ex CS8416_CHIP_ADDR_W
	i2c_checkack
	i2c_bytesend_ex2 cs8416_oper_addr
	i2c_checkack
	i2c_startcode
	i2c_bytesend_ex CS8416_CHIP_ADDR_R
	i2c_checkack
	i2c_byteget
	mov i2c_buf,a
	movam cs8416_value
	i2c_sendnoack
	i2c_stopcode
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;cs8416 read data macro mode
cs8416_read macro L_addr
	movla L_addr
	movam cs8416_oper_addr
	lcall fun_cs8416_read
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;cs8416 set data
cs8416_set_data macro
	movla serial_buf_start
	movam BSR
	inc BSR,m
	mov INDF,a
	movam cs8416_oper_addr
	inc BSR,m
	mov INDF,a
	movam cs8416_value
	lcall fun_cs8416_write
	clr BSR
	lcall fun_serial_ok_ack
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;cs8416 get data
cs8416_get_data macro
	movla serial_buf_start
	movam BSR
	inc BSR,m
	mov INDF,a
	movam cs8416_oper_addr
	lcall fun_cs8416_read
	;;;;send ack
	lcall fun_cs8416_ack
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fswclkmutesao macro L_selectfsclk,L_force
	local fswclkmutesao_select_0,fswclkmutesao_select_end,fswclkmutesao_end
	
	movla L_selectfsclk
	jz fswclkmutesao_select_0
	;;1
	cs8416_write 0x00,0x00;
	nop
	cs8416_write 0x01,0x84;	// 256*fs
	nop
	lgoto fswclkmutesao_select_end
fswclkmutesao_select_0
	cs8416_write 0x00,0x40;//switch RMCK to OMCK  and mute data output
	nop
	cs8416_write 0x01,0xc4;
	nop
fswclkmutesao_select_end
	movla L_force
	jz fswclkmutesao_end
;	bc my_status,SPDIF_CS8416
	movla L_selectfsclk
	jz fswclkmutesao_end
;	bs my_status,SPDIF_CS8416
fswclkmutesao_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;init cs8416
init_cs8416 macro
	bc set_aud_rst
	m_delay_ms .100
	bs set_aud_rst

	cs8416_write 0x04,0x00;	//stop internal clock allowing registers to be read and changed
	FswclkMuteSao .1,.1;
;	cs8416_write 0x02,0x32;	//48KHz setting, GPO0 as INT_CS8416
	cs8416_write 0x02,0x00;
	cs8416_write 0x03,0x50;
;	cs8416_write 0x03,0x5b;	//GPO1 as Receiver Error, GPO2 as Fixed low level

	cs8416_write 0x05,0x85;	//i2s up-24-bit data master mode
;	cs8416_write 0x05,0x05;	//i2s up-24-bit data
;	cs8416_write 0x05,0x00;	//left justified 24-bit data
;	cs8416_write 0x05,0x08;	//right justified 24-bit data
;	cs8416_write 0x05,0x30;	//AES3 direct

;	cs8416_write 0x06,0x7f;
	cs8416_write 0x06,0x10;

	cs8416_write 0x07,0x04;

	cs8416_write 0x08,0x00;
	cs8416_write 0x09,0x04;	//error unmarked

;	cs8416_write 0x04,0x80;	//run coaxial1
	cs8416_write 0x04,0x88;	//run coaxial2
;	cs8416_write 0x04,0x90;	//run optical

	;bs my_status,OK_CS8416
	
	cs8416_read 0x7f
	movla 0x0f
	ior cs8416_value,m
	enj cs8416_value,0x2f,init_cs8416_end		;;init fail
	;;;init success

	;lcall fun_serial_ok_ack
init_cs8416_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;switch cs8416
switch_cs8416 macro
	local switch_cs8416_0,switch_cs8416_1,switch_cs8416_2,switch_cs8416_end
	ej input_type,0,switch_cs8416_0
	ej input_type,1,switch_cs8416_1
	ej input_type,2,switch_cs8416_2
	lgoto switch_cs8416_end
switch_cs8416_0
	cs8416_write 0x04,0x90;	//run optical2 rxp2	// rxp0
	lgoto switch_cs8416_end
switch_cs8416_1
	cs8416_write 0x04,0x88;	//run optical1 rxp1	// rxp1
	lgoto switch_cs8416_end
switch_cs8416_2
	cs8416_write 0x04,0x80;	//run coaxial rxp0	// rxp2
	lgoto switch_cs8416_end
switch_cs8416_end

endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;switch cs8416
switch_cs8416_ex macro L_inputsource
	movla L_inputsource
	movam input_type
	switch_cs8416
endm
