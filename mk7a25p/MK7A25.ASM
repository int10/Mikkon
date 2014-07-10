;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;creat by int10@100618
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;use mk7a25p	

#include  "mk7a21p.inc"  ;编译该文档需包含"mk7a21p.inc"文件

;配置寄存器设置说明（CONFIG） 
;1-----------FOSC=RC    ;LS,NS,HS,RC    
;2-----------INRC=ON    ;ON,OFF 
;3-----------CPT=ON    ;ON,OFF    
;4-----------WDTE=Enable   ;Enable,Disable 
;5-----------LV=Low Vol Reset ON  ;Low Vol Reset ON,Low Vol Reset OFF 
;6-----------RESET=...input...   ;...input...,...reset... 

;#define USE_EMLUATOR
#define fun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;some define 
#define const_delay_40us		.19
#define const_delay_100us		.49
#define const_delay_560us		.111
#define const_delay_1680us		.167
#define const_delay_1ms		.199

#define ser_symbol_send_start		0xba
#define ser_symbol_ack_start		0xab
#define ser_symbol_cmd_end		0x0a
#define ser_symbol_cmd_burn		0x00
#define ser_symbol_cmd_verify	0x01
#define ser_symbol_cmd_size		0x02
#define ser_symbol_cmd_check	0x03
#define ser_symbol_ack_ok			0x00
#define ser_symbol_ack_fail		0x01

#define eeprom_32k_last_addr_h	0x0f
#define eeprom_32k_last_addr_l	0xff
#define eeprom_64k_last_addr_h	0x1f
#define eeprom_64k_last_addr_l	0xff
#define eeprom_128k_last_addr_h	0x3f
#define eeprom_128k_last_addr_l	0xff
#define eeprom_256k_last_addr_h	0x7f
#define eeprom_256k_last_addr_l	0xff
#define const_256k_test_value	0x04
#define const_128k_test_value	0x03
#define const_64k_test_value		0x02
#define const_32k_test_value		0x01
#define eeprom_work_count_addr_h	0x00
#define eeprom_work_count_addr_l	0x02


ch_night_dividing_line		equ 	0x00
eeprom_twr					equ	.12		;ms
eeprom_dev_addr_r			equ	0xa1
eeprom_dev_addr_w			equ	0xa0


#define PORTB PB_DAT
#define PORTA PA_DAT
#define PORTC PC_DAT
#define BSR FSR


bit_rx			equ PA2
bit_tx			equ PA3
bit_led_1		equ PC3
bit_led_2		equ PC4
bit_led_3		equ PA7
bit_led_4		equ PA6
bit_led_5		equ PA5
bit_led_6		equ PA4
bit_led_7		equ PB1
bit_led_8		equ PB2
bit_led_9		equ PB3
bit_led_10		equ PC5
bit_led_11		equ PA0
bit_led_12		equ PA1
bit_sck			equ PC2
bit_sda			equ PC0


#define set_tx 			PORTA,bit_tx
#define test_rx 			PORTA,bit_rx

#define set_led_1			PORTC,bit_led_1
#define set_led_2			PORTC,bit_led_2
#define set_led_3			PORTA,bit_led_3
#define set_led_4			PORTA,bit_led_4
#define set_led_5			PORTA,bit_led_5
#define set_led_6			PORTA,bit_led_6
#define set_led_7			PORTB,bit_led_7
#define set_led_8			PORTB,bit_led_8
#define set_led_9			PORTB,bit_led_9
#define set_led_10			PORTC,bit_led_10
#define set_led_11			PORTA,bit_led_11
#define set_led_12			PORTA,bit_led_12

#define set_sck				PORTC,bit_sck
#define set_sda				PORTC,bit_sda
#define test_sda				PORTC,bit_sda


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;my_status bit define
tm1_overflow				equ 		0
night_work_mode			equ		1
work_counter_available		equ		2		;0:error 1:available
serial_receive_status		equ		3
serial_string_receive_status	equ		4
adc_running_status			equ		5
adc_complete_status			equ		6
rx_int_status				equ		7


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;memery map			;;;;  0x40~0xbf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

a_buf					equ   		0x40   		;acc缓存器 
status_buf				equ   		0x41   		;status缓存器 
temp_buf				equ			0x42
delay_counter			equ			0x43
delay_ms_counter		equ			0x44
tm1_counter_h			equ			0x45
tm1_counter_l			equ			0x46
bit_counter				equ			0x47
my_status				equ			0x48		;;;
tm_counter_l			equ			0x49

value_mask				equ			0x4a

eeprom_byte_counter	equ			0x4b
serial_byte_counter		equ			0x4c
eeprom_operate_addr_h	equ			0x4e
eeprom_operate_addr_l	equ			0x4f


led_element_h			equ			0x50
led_element_l			equ			0x51

led_value_h				equ			0x52
led_value_l				equ			0x53
led_cycle_h				equ			0x54
led_cycle_l				equ			0x55

tmp_addr_h				equ			0x56
tmp_addr_l				equ			0x57
tmp_dword_op_buf		equ			0x58
tmp_dword_op_buf2		equ			0x59
adc_time_out_counter	equ			0x5a
brightness_check_counter	equ		0x5b


adc_value				equ			0x5d



sersor_gate				equ			0x5e
sersor_factor			equ			0x5f
working_counter_h		equ			0x60
working_counter_l		equ			0x61

cycle_table_addr_h		equ			0x62
cycle_table_addr_l		equ			0x63
status_table_addr_h		equ			0x64
status_table_addr_l		equ			0x65
pattern_table_addr_h	equ			0x66
pattern_table_addr_l		equ			0x67
module_index_table_addr_h	equ		0x68
module_index_table_addr_l	equ		0x69

cur_pattern_addr_h		equ			0x6a
cur_pattern_addr_l		equ			0x6b
cur_module_index		equ			0x6c
cur_element_addr_h		equ			0x6d
cur_element_addr_l		equ			0x6e


receive_data			equ			0x70			;can share the same buf with send
send_data				equ			0x70			;can share the same buf with recive

file_size_h				equ			0x71
file_size_l				equ			0x72
file_size_back_h			equ			0x73
file_size_back_l			equ			0x74


i2c_buf					equ			0x75
i2c_ack_counter			equ			0x76

eeprom_32k_back		equ			0x77
eeprom_64k_back		equ			0x78
eeprom_128k_back		equ			0x79
eeprom_256k_back		equ			0x7a
rom_size_h				equ			0x7b
rom_size_l				equ			0x7c
bri_same_mode_counter	equ			0x7d
bri_same_mode_counter2	equ		0x7e

serial_buf_start		equ			0xa0
serial_buf_end			equ			0xaf
serial_cmd_start_point	equ			0xa0
serial_cmd_point		equ			0xa2
serial_file_size_h_point	equ			0xa3
serial_file_size_l_point	equ			0xa4
eeprom_value_h			equ			0xa0
eeprom_value_l			equ			0xa1




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;some macro
jnz macro position
	btss STATUS,Z
	lgoto position
endm


jnc macro position
	btss STATUS,C
	lgoto position
endm

;if M>L then jump to position		M:memory data			L:literal
bj macro M,L,position
	movla L
	sub M,a
	jc position
endm

;if M<L then jump to position		M:memory data			L:literal
sj macro M,L,position
	movla L
	sub M,a
	jnc position
endm

;if M==L then jump to position		M:memory data			L:literal
ej macro M,L,position
	movla L
	xor M,a
	jz position
endm

;if M!=L then jump to position		M:memory data			L:literal
enj macro M,L,position
	movla L
	xor M,a
	jnz position
endm

;;16 bit data right shift 1bit
dword_rr macro dw_h,dw_l
	local dword_rr_end
	bc STATUS,C
	rrc dw_l,m
	bc STATUS,C
	rrc dw_h,m
	jnc dword_rr_end
	bs dw_l,7
dword_rr_end

endm

;;16bit data left shift 1bit
dword_rl macro dw_h,dw_l
	local dword_rl_end
	bc STATUS,C
	rlc dw_h,m
	bc STATUS,C
	rlc dw_l,m
	jnc dword_rl_end
	bs dw_h,0
dword_rl_end
endm

;16bit data add 8bit data.....assume dw_h!=0xff
dword_add macro dw_h,dw_l,m_value
	local dword_add_no_carry
	mov m_value,a
	add dw_l,m
	jnc dword_add_no_carry
	inc dw_h,m
dword_add_no_carry
endm

;;;;;;;16bit data add 8bit data.......assume dw_h+value_h<0xff
dword_add2 macro dw_h,dw_l,m_value_h,m_value_l
	local dword_add2_no_carry
	mov m_value_h,a
	add dw_h,m
	mov m_value_l,a
	add dw_l,m
	jnc dword_add2_no_carry
	inc dw_h,m
dword_add2_no_carry
endm

;;;;;;16bit data add 8bit data.....assume dw_h!=0xff
dword_add3 macro dw_h,dw_l,l_value
	local dword_add3_no_carry
	movla l_value
	add dw_l,m
	jnc dword_add3_no_carry
	inc dw_h,m
dword_add3_no_carry
endm


;;16bit data compare.....
dword_ej macro dw_h,dw_l,l_value_h,l_value_l,position
	local dword_ej_end
	enj dw_h,l_value_h,dword_ej_end
	enj dw_l,l_value_l,dword_ej_end
	lgoto position
dword_ej_end
endm

dword_enj macro dw_h,dw_l,l_value_h,l_value_l,position
	enj dw_h,l_value_h,position
	enj dw_l,l_value_l,position
endm




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
mycall macro function
	lcall function
endm

myret macro
	ret
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
en_int macro
	bs IRQM,INTM
endm

dis_int macro
	bc IRQM,INTM
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set main entery

org			0x000	
lgoto		main
org			0x004
lgoto		int_entry

org 			0x0010



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;delay x ms ,x<255
m_delay_ms macro ms
	local delay_ms_loop

	movla ms
	movam delay_ms_counter
delay_ms_loop
	lcall delay_1ms
	decsz delay_ms_counter,m
	lgoto delay_ms_loop
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;init the chip
init_chip macro

	;PortA端口方向及状态设定            
	movla      	0xff
	movam temp_buf
	bc temp_buf,bit_led_12
	bc temp_buf,bit_led_11
	bc temp_buf,bit_led_6
	bc temp_buf,bit_led_4
	bc temp_buf,bit_led_5
	bc temp_buf,bit_led_3
	bc temp_buf,bit_tx
	mov temp_buf,a
	movam PA_DIR
	clr   		PORTA
	;------------------------------------------------------ 
	;PortB端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
	bc temp_buf,bit_led_7
	bc temp_buf,bit_led_8
	bc temp_buf,bit_led_9
	mov temp_buf,a
	movam PB_DIR
	clr   		PORTB
	;------------------------------------------------------

	;PortC端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
	bc temp_buf,bit_led_1
	bc temp_buf,bit_led_2
	bc temp_buf,bit_led_10
	bc temp_buf,bit_sck
	bc temp_buf,bit_sda
	mov temp_buf,a
	movam PC_DIR
	clr   		PORTC

	;;;;;;;;set pull up register
	movla b'11111111'
	movam temp_buf
	mov temp_buf,a
	movam PA_PLU
	movam PB_PLU
	movam PC_PLU
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;personal setting

	bs set_tx
	bs set_sck

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;init wtd
	movla b'10000111'
	movam WDT_CTL

	;;;;;;;;;;;;;;;;;;;;;;;;
	movla .7
	movam brightness_check_counter
	clr bri_same_mode_counter
	clr bri_same_mode_counter2
	clr my_status
	get_show_info_from_eeprom

	clr IRQF
	bs IRQM,PAM
	bs IRQM,INTM
	bs PA_INTE,bit_rx
	
endm


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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;serial send	9600bps		data place at send_data
serial_send macro
	;;start bit 
	bc set_tx
	lcall delay_100us
	;;start to send 8bit data
	serial_send_8bit
	;;stop bit
	bs set_tx
	lcall delay_100us
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
	;rl decode_mask,m
	rlc value_mask,m
	jc receive_8bit_end
	lgoto receive_next_bit
receive_8bit_end
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;serial receive 9600bps		after received ,place it at receive_data , if receive_data = 0 ;means receive no data
serial_receive macro
	local serial_receive_end,serial_receive_stop_bit_wait
	;;start bit 
	clr receive_data
	bc my_status,serial_receive_status
	btsc test_rx
	lgoto serial_receive_end
	btsc test_rx
	lgoto serial_receive_end

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
serial_receive_stop_bit_wait:
	btss test_rx
	lgoto serial_receive_end
	decsz tm_counter_l,m
	lgoto serial_receive_stop_bit_wait
	
serial_receive_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;receive a string ..... data place at serial_buf_base
serial_receive_string macro
	local serial_receive_string_next_byte,serial_receive_string_sucess,serial_receive_string_end
	movla serial_buf_start
	movam BSR
	bc my_status,serial_string_receive_status

serial_receive_string_next_byte
	serial_receive
	btss my_status,serial_receive_status
	lgoto serial_receive_string_end
	mov receive_data,a
	movam INDF
	ej receive_data,0x0a,serial_receive_string_sucess
	inc BSR,m
	ej BSR,serial_buf_end,serial_receive_string_end
	lgoto serial_receive_string_next_byte
serial_receive_string_sucess
	bs my_status,serial_string_receive_status
serial_receive_string_end
	clr BSR
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;send a string .... data place at serial_buf_base
serial_send_string macro
	local serial_send_string_next_byte,serial_send_string_end
	movla serial_buf_start
	movam BSR

serial_send_string_next_byte
	mov INDF,a
	movam send_data
	serial_send
	mov INDF,a
	movam send_data
	ej send_data,0x0a,serial_send_string_end
	inc BSR,m
	lgoto serial_send_string_next_byte
	
serial_send_string_end
	clr BSR

endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;check it's day or night
brightness_check macro
	;local brightness_check_day,brightness_check_night,brightness_check_end
	local brightness_check_day,brightness_check_night_now,brightness_check_change_2_night,brightness_check_night,brightness_check_day_now,brightness_check_change_2_day,brightness_check_end
	decsz brightness_check_counter,m
	lgoto brightness_check_end
	movla .180
	movam brightness_check_counter



	adc_get_value ch_night_dividing_line
	btss my_status,adc_complete_status
	lgoto brightness_check_end
	bc my_status,adc_complete_status
	clrwdt
	mov sersor_gate,a
	sub adc_value,a
	jnc brightness_check_day
	lgoto brightness_check_night
brightness_check_day
	btsc my_status,night_work_mode
	lgoto brightness_check_night_now
	clr bri_same_mode_counter
	clr bri_same_mode_counter2
	lgoto brightness_check_end

brightness_check_night_now
	;ej bri_same_mode_counter,.250,brightness_check_change_2_day
	;inc bri_same_mode_counter,m
	dword_ej bri_same_mode_counter2,bri_same_mode_counter,0x0b,0xff,brightness_check_change_2_day
	movla .1
	movam tmp_dword_op_buf
	dword_add bri_same_mode_counter2,bri_same_mode_counter,tmp_dword_op_buf
	
	lgoto brightness_check_end

brightness_check_change_2_day
	clr bri_same_mode_counter
	clr bri_same_mode_counter2
	bc my_status,night_work_mode
	lgoto brightness_check_end

brightness_check_night
	btss my_status,night_work_mode
	lgoto brightness_check_day_now
	clr bri_same_mode_counter
	clr bri_same_mode_counter2
	lgoto brightness_check_end

brightness_check_day_now
	;ej bri_same_mode_counter,.250,brightness_check_change_2_night
	;inc bri_same_mode_counter,m
	dword_ej bri_same_mode_counter2,bri_same_mode_counter,0x0b,0xff,brightness_check_change_2_night
	movla .1
	movam tmp_dword_op_buf
	dword_add bri_same_mode_counter2,bri_same_mode_counter,tmp_dword_op_buf
	
	lgoto brightness_check_end
	
brightness_check_change_2_night
	clr bri_same_mode_counter
	clr bri_same_mode_counter2
	bs my_status,night_work_mode
	lgoto brightness_check_end
brightness_check_end
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start adc 
start_adc macro channel
	local adc_check_complete,adc_get_value_end,adc_get_value_delay
	clra
	xorla channel
	movam AD_CTL1

	movla .3			;;;;;System clock X128
	movam AD_CTL2
	
	movla b'00000001'			;;;;;;Bit3-0:PB0-3复用管脚的选择,做ADC用 
	movam AD_CTL3	

	clr AD_DAT
	bs AD_CTL1,EN

	movla .17
	movam adc_time_out_counter
	bs my_status,adc_running_status
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;read adc and return the value at adc_value
adc_get_value macro channel
	local adc_get_value_running,adc_get_value_ok,adc_get_value_end,adc_get_value_delay
	btsc my_status,adc_running_status
	lgoto adc_get_value_running
	start_adc channel
	lgoto adc_get_value_end

adc_get_value_running
	btss AD_CTL1,7
	lgoto adc_get_value_ok
	decsz adc_time_out_counter,m
	lgoto adc_get_value_end
	bc my_status,adc_running_status		;;timeout ,,reset adc
	lgoto adc_get_value_end
	
adc_get_value_ok
	bc my_status,adc_running_status
	bs my_status,adc_complete_status
	mov AD_DAT,a
	movam adc_value
	
;	movla .2			;had better have 16 instruction nop before it go to next adc_get_value
;	movam adc_time_out_counter
;adc_get_value_delay
;	clrwdt
;	decsz adc_time_out_counter,m
;	lgoto adc_get_value_delay
adc_get_value_end
	
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start tm1
start_tm1 macro
	;;init variable
	movla b'01100101'
	movam tm1_ctl1       	;TM1时钟源内部RC时钟,预分频1:32
	;IC's clock is faster tha emulate...fix it 
	;movla 0x09 
	movla 0x0d 
	movam tm1l_la 
	;movla 0x3d
	movla 0x3f
	movam tm1h_la  	;溢出周期125ms
	
	;movla b'10000010' 	;以下是中断设置 
	;movam irqm
	bs IRQM,TM1M
	en_int
	clr irqf 
	bs tm1_ctl1,7
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;stop tm1
stop_tm1 macro
	bc TM1_CTL1,7
	bc IRQM,TM1M
	clr IRQF
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;tm1 int
int_tm1 macro

	bc IRQF,TM1F
	;;;add the code below


	dec tm1_counter_l,m
	jnz int_tm1_end
	ej tm1_counter_h,0x00,int_tm1_overflow
	dec tm1_counter_h,m
	lgoto int_tm1_end
int_tm1_overflow
	bs my_status,tm1_overflow
	
int_tm1_end
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;pa int
int_pa macro
	bc IRQF,PAF
	btss test_rx
	lgoto int_pa_0
int_pa_1
	nop
	lgoto int_pa_end
int_pa_0
	nop
	bs my_status,rx_int_status
int_pa_end

endm


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
	bc PC_DIR,bit_sda
	nop
	nop
endm

i2c_sda_read_mode macro
	bs PC_DIR,bit_sda
	nop
	nop
endm


i2c_startcode macro
	I2C_SDA_SET;
	I2C_SCL_SET;
	clrwdt
	clrwdt
	I2C_SDA_CLEAR;
	clrwdt
	clrwdt
	I2C_SCL_CLEAR;
	clrwdt
	clrwdt
endm

i2c_bytesend macro 
	local i2c_bytesend_next,i2c_bytesend_1,i2c_bytesend_0,i2c_bytesend_bit_end,i2c_bytesend_end
	movla 0x80
	movam value_mask

i2c_bytesend_next
	mov value_mask,a
	and i2c_buf,a
	jz i2c_bytesend_0
i2c_bytesend_1
	I2C_SDA_SET
	lgoto i2c_bytesend_bit_end
i2c_bytesend_0
	I2C_SDA_CLEAR
i2c_bytesend_bit_end
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	I2C_SCL_SET
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	I2C_SCL_CLEAR
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
endm




i2c_sendack macro
	I2C_SDA_CLEAR;
	nop
	I2C_SCL_SET;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	I2C_SCL_CLEAR;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
endm

;;;;int10@101027  add....should use it at eeprom drv ,but now ,don't use,because no debug and the code can work without it ...
i2c_sendnoack macro
	I2C_SDA_SET;
	nop
	I2C_SCL_SET;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	I2C_SCL_CLEAR;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
endm

i2c_checkack macro
	local i2c_checkack_wait,i2c_checkack_end
	movla .255
	movam i2c_ack_counter

;	i2c_sda_set
;	clrwdt
	i2c_sda_read_mode
	
	I2C_SCL_SET;
	clrwdt
	clrwdt
	clrwdt
	clrwdt
i2c_checkack_wait
	btss test_sda
	lgoto i2c_checkack_end
	decsz i2c_ack_counter,m
	lgoto i2c_checkack_wait

i2c_checkack_end
	i2c_scl_clear
	i2c_sda_write_mode

endm

i2c_byteget macro
	local i2c_byteget_next,i2c_byteget_1,i2c_byteget_0,i2c_byteget_bit_end,i2c_byteget_end
	clr i2c_buf
	movla 0x80
	movam value_mask

	i2c_sda_read_mode

i2c_byteget_next
	I2C_SCL_SET
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	btss test_sda
	lgoto i2c_byteget_0
i2c_byteget_1
	mov value_mask,a
	ior i2c_buf,m
	lgoto i2c_byteget_bit_end
i2c_byteget_0
i2c_byteget_bit_end
	I2C_SCL_CLEAR
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

endm

i2c_stopcode macro
	I2C_SDA_CLEAR;
	nop;
	I2C_SCL_SET;
	nop;
	I2C_SDA_SET;
	nop;
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
	i2c_stopcode
	clr BSR

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get show info......
get_show_info_from_eeprom macro
	eeprom_read_ex 0x00,0x00,.8
	movla serial_buf_start
	movam BSR
	
	mov INDF,a
	movam sersor_gate

	inc BSR,m
	mov INDF,a
	movam sersor_factor

	mov sersor_factor,a
	add sersor_gate,m
	

	inc BSR,m
	mov INDF,a
	movam working_counter_h

	inc BSR,m
	mov INDF,a
	movam working_counter_l
	
	eeprom_read_ex 0x00,0x08,.8
	movla serial_buf_start
	movam BSR

	mov INDF,a
	movam cycle_table_addr_h
	
	inc BSR,m
	mov INDF,a
	movam cycle_table_addr_l
	
	inc BSR,m
	mov INDF,a
	movam status_table_addr_h
	
	inc BSR,m
	mov INDF,a
	movam status_table_addr_l

	inc BSR,m
	mov INDF,a
	movam pattern_table_addr_h

	inc BSR,m
	mov INDF,a
	movam pattern_table_addr_l

	inc BSR,m
	mov INDF,a
	movam module_index_table_addr_h

	inc BSR,m
	mov INDF,a
	movam module_index_table_addr_l
	
	clr BSR
	
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;creat burn ack package
creat_ser_cmd_burn_ack macro
	movla serial_buf_start
	movam BSR
	movla ser_symbol_ack_start
	movam INDF
	inc BSR,m
	movla 0x02
	movam INDF
	inc BSR,m
	movla ser_symbol_cmd_burn
	movam INDF
	inc BSR,m
	movla ser_symbol_cmd_end
	movam INDF
	;;end
	clr BSR
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;creat verify ack package
creat_ser_cmd_verify_ack macro
	movla serial_buf_start
	movam BSR
	movla ser_symbol_ack_start
	movam INDF
	inc BSR,m
	movla 0x02
	movam INDF
	inc BSR,m
	movla ser_symbol_cmd_verify
	movam INDF
	inc BSR,m
	movla ser_symbol_cmd_end
	movam INDF
	;;end
	clr BSR
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get eeprom size
get_rom_size macro

	eeprom_read_ex eeprom_256k_last_addr_h,eeprom_256k_last_addr_l,.1
	mov eeprom_value_h,a
	movam eeprom_256k_back
	eeprom_read_ex eeprom_128k_last_addr_h,eeprom_128k_last_addr_l,.1
	mov eeprom_value_h,a
	movam eeprom_128k_back
	eeprom_read_ex eeprom_64k_last_addr_h,eeprom_64k_last_addr_l,.1
	mov eeprom_value_h,a
	movam eeprom_64k_back
	eeprom_read_ex eeprom_32k_last_addr_h,eeprom_32k_last_addr_l,.1
	mov eeprom_value_h,a
	movam eeprom_32k_back

	movla const_256k_test_value
	movam eeprom_value_h
	eeprom_write_ex eeprom_256k_last_addr_h,eeprom_256k_last_addr_l,.1
	movla const_128k_test_value
	movam eeprom_value_h
	eeprom_write_ex eeprom_128k_last_addr_h,eeprom_128k_last_addr_l,.1
	movla const_64k_test_value
	movam eeprom_value_h
	eeprom_write_ex eeprom_64k_last_addr_h,eeprom_64k_last_addr_l,.1
	movla const_32k_test_value
	movam eeprom_value_h
	eeprom_write_ex eeprom_32k_last_addr_h,eeprom_32k_last_addr_l,.1


	eeprom_read_ex eeprom_256k_last_addr_h,eeprom_256k_last_addr_l,.1
	ej eeprom_value_h,const_256k_test_value,get_rom_size_256k
	eeprom_read_ex eeprom_128k_last_addr_h,eeprom_128k_last_addr_l,.1
	ej eeprom_value_h,const_128k_test_value,get_rom_size_128k
	eeprom_read_ex eeprom_64k_last_addr_h,eeprom_64k_last_addr_l,.1
	ej eeprom_value_h,const_64k_test_value,get_rom_size_64k
	eeprom_read_ex eeprom_32k_last_addr_h,eeprom_32k_last_addr_l,.1
	ej eeprom_value_h,const_32k_test_value,get_rom_size_32k

	

	
get_rom_size_256k
	movla .1
	movam rom_size_h
	clr rom_size_l
	lgoto get_rom_size_end
get_rom_size_128k
	clr rom_size_h
	movla 0x80
	movam rom_size_l
	lgoto get_rom_size_end
get_rom_size_64k
	clr rom_size_h
	movla 0x40
	movam rom_size_l
	lgoto get_rom_size_end
get_rom_size_32k
	clr rom_size_h
	movla 0x20
	movam rom_size_l
	lgoto get_rom_size_end
get_rom_size_end	
	mov eeprom_256k_back,a
	movam eeprom_value_h
	eeprom_write_ex eeprom_256k_last_addr_h,eeprom_256k_last_addr_l,.1
	mov eeprom_128k_back,a
	movam eeprom_value_h
	eeprom_write_ex eeprom_128k_last_addr_h,eeprom_128k_last_addr_l,.1
	mov eeprom_64k_back,a
	movam eeprom_value_h
	eeprom_write_ex eeprom_64k_last_addr_h,eeprom_64k_last_addr_l,.1
	mov eeprom_32k_back,a
	movam eeprom_value_h
	eeprom_write_ex eeprom_32k_last_addr_h,eeprom_32k_last_addr_l,.1
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;creat size ack package
creat_ser_cmd_size_ack macro
	get_rom_size
	movla serial_buf_start
	movam BSR
	movla ser_symbol_ack_start
	movam INDF
	inc BSR,m
	movla 0x04
	movam INDF
	inc BSR,m
	movla ser_symbol_cmd_size
	movam INDF
	inc BSR,m
	;;;size h
	;movla 0x00
	mov rom_size_h,a
	movam INDF
	inc BSR,m
	;;;size l
	;movla .64
	mov rom_size_l,a
	movam INDF
	inc BSR,m
	
	movla ser_symbol_cmd_end
	movam INDF
	;;end
	clr BSR

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;creat check ack package
creat_ser_cmd_check_ack macro
	movla serial_buf_start
	movam BSR
	movla ser_symbol_ack_start
	movam INDF
	inc BSR,m
	movla 0x02
	movam INDF
	inc BSR,m
	;;check result
	movla 0x00
	movam INDF
	inc BSR,m
	movla ser_symbol_cmd_check
	movam INDF
	inc BSR,m
	movla ser_symbol_cmd_end
	movam INDF
	;;end
	clr BSR
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;burn eeprom
ser_cmd_burn_handle macro
	mov serial_file_size_h_point,a
	movam file_size_back_h
	movam file_size_h
	mov serial_file_size_l_point,a
	movam file_size_back_l
	movam file_size_l

	clr eeprom_operate_addr_h
	clr eeprom_operate_addr_l
	
	creat_ser_cmd_burn_ack
	serial_send_string


	start_tm1			;;timer for time out at receive byte
ser_cmd_burn_handle_next_block
	movla serial_buf_start
	movam BSR

	movla 0x08
	movam serial_byte_counter
	;;;;;add time out
	movla 0x10
	movam tm1_counter_l
	clr tm1_counter_h
	bc my_status,tm1_overflow
ser_cmd_burn_handle_next_byte
	clrwdt
	serial_receive
	btsc my_status,tm1_overflow
	;lgoto ser_cmd_burn_handle_end				;time out
	lgoto ser_cmd_burn_handle_time_out
	
	btss my_status,serial_receive_status
	lgoto ser_cmd_burn_handle_next_byte
	mov receive_data,a
	movam INDF
	inc BSR,m

	;;is file end??
	dec file_size_l,m
	jnz ser_cmd_burn_handle_not_file_end
	;enj file_size_l,0x01,ser_cmd_burn_handle_not_file_end
	ej file_size_h,0x00,ser_cmd_burn_handle_ok
	dec file_size_h,m
ser_cmd_burn_handle_not_file_end
	;dec file_size_l,m
;ser_cmd_burn_handle_receive_a_byte
	decsz serial_byte_counter,m
	lgoto ser_cmd_burn_handle_next_byte
	;;;;write eeprom
	eeprom_write .8
	movla .8
	movam tmp_dword_op_buf
	dword_add eeprom_operate_addr_h,eeprom_operate_addr_l,tmp_dword_op_buf
	
	creat_ser_cmd_burn_ack
	serial_send_string
	lgoto ser_cmd_burn_handle_next_block
ser_cmd_burn_handle_time_out
	clrwdt
	lgoto ser_cmd_burn_handle_end
ser_cmd_burn_handle_ok
	eeprom_write .8				;;;write last serval bytes
	get_show_info_from_eeprom
ser_cmd_burn_handle_end

	clr BSR
	stop_tm1
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;send eeprom data to pc
ser_cmd_verify_handle macro

	creat_ser_cmd_verify_ack
	serial_send_string
	movla serial_buf_start
	movam BSR
	
	mov file_size_back_h,a
	movam file_size_h
	mov file_size_back_l,a
	movam file_size_l

	;;;;;;if have no file_size
	dword_ej file_size_h,file_size_l,0x00,0x00,ser_cmd_verify_handle_end
	clr eeprom_operate_addr_h
	clr eeprom_operate_addr_l

ser_cmd_verify_next_block
	movla 0x08
	movam serial_byte_counter
	;;;;;;;;;;read eeprom prepare 8 bytes data
	eeprom_read .8

	;;start send a block
	movla serial_buf_start
	movam BSR

ser_cmd_verify_next_byte
	mov INDF,a
	movam send_data
	serial_send
	inc BSR,m
	;;is file end??
	dec file_size_l,m
	jnz ser_cmd_verify_not_file_end
	;enj file_size_l,0x01,ser_cmd_verify_not_file_end
	ej file_size_h,0x00,ser_cmd_verify_handle_end				;;file is end
	dec file_size_h,m
ser_cmd_verify_not_file_end
	;dec file_size_l,m
	decsz serial_byte_counter,m
	lgoto ser_cmd_verify_next_byte
	movla .8
	movam tmp_dword_op_buf
	dword_add eeprom_operate_addr_h,eeprom_operate_addr_l,tmp_dword_op_buf
	lgoto ser_cmd_verify_next_block
	
ser_cmd_verify_handle_end
	clr BSR


	
	
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;send eeprom size to pc
ser_cmd_size_handle macro
	creat_ser_cmd_size_ack
	serial_send_string

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;check eeprom is ok
ser_cmd_check_handle macro

	creat_ser_cmd_check_ack
	serial_send_string


endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get command from serial
serial_command macro
	serial_receive_string
	btss my_status,serial_string_receive_status
	lgoto serial_command_end
	nop

	enj serial_cmd_start_point,ser_symbol_send_start,serial_command_end

	ej serial_cmd_point,ser_symbol_cmd_burn,serial_command_burn
	ej serial_cmd_point,ser_symbol_cmd_verify,serial_command_verify
	ej serial_cmd_point,ser_symbol_cmd_size,serial_command_size
	ej serial_cmd_point,ser_symbol_cmd_check,serial_command_check

serial_command_burn
	ser_cmd_burn_handle
	lgoto serial_command_end
serial_command_verify
	ser_cmd_verify_handle
	lgoto serial_command_end
serial_command_size
	ser_cmd_size_handle
	lgoto serial_command_end
serial_command_check
	ser_cmd_check_handle
	lgoto serial_command_end
serial_command_end


endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;stop show led
stop_led_show macro
	stop_tm1
	clr led_value_h
	clr led_value_l
	;showledelement
	lcall fun_showledelement
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get cur module index.......accounding to cur_pattern_addr and place the result at cur_module_index
;get_module_index macro
fun_get_module_index fun
;	mov pattern_table_addr_h,a
;	movam tmp_addr_h
;	mov pattern_table_addr_l,a
;	movam tmp_addr_l
;
;	mov cur_pattern_index,a
;	movam temp_buf
;	dword_add tmp_addr_h,tmp_addr_l,temp_buf
;	
;	mov tmp_addr_h,a
;	movam eeprom_operate_addr_h
;	mov tmp_addr_l,a
;	movam eeprom_operate_addr_l
;	eeprom_read .1
;	mov eeprom_value_h,a
;	movam cur_module_index
	
	mov cur_pattern_addr_h,a
	movam eeprom_operate_addr_h
	mov cur_pattern_addr_l,a
	movam eeprom_operate_addr_l
	eeprom_read .1
	mov eeprom_value_h,a
	movam cur_module_index

;endm
ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get module X start addr and place it at cur_element_addr_h & cur_element_addr_l   assume cur_module_index can't bigger than 127
;get_module_entry macro
fun_get_module_entry fun
	mov module_index_table_addr_h,a
	movam tmp_addr_h
	mov module_index_table_addr_l,a
	movam tmp_addr_l

	mov cur_module_index,a
	movam tmp_dword_op_buf

	bc STATUS,C
	rlc tmp_dword_op_buf,m

	dword_add tmp_addr_h,tmp_addr_l,tmp_dword_op_buf

	mov tmp_addr_h,a
	movam eeprom_operate_addr_h
	mov tmp_addr_l,a
	movam eeprom_operate_addr_l
	eeprom_read .2
	mov eeprom_value_h,a
	movam cur_element_addr_h
	mov eeprom_value_l,a
	movam cur_element_addr_l
	
	;rr tmp_addr_l,m
	
;endm
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get led element value
;get_element_value macro
fun_get_element_value fun
	mov cur_element_addr_h,a
	movam eeprom_operate_addr_h
	mov cur_element_addr_l,a
	movam eeprom_operate_addr_l
	eeprom_read .2
	mov eeprom_value_h,a
	movam led_element_h
	mov eeprom_value_l,a
	movam led_element_l
;endm
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get led value
;get_led_value macro
fun_get_led_value fun
	mov status_table_addr_h,a
	movam tmp_addr_h
	mov status_table_addr_l,a
	movam tmp_addr_l

	mov led_element_l,a			;;status code
	movam tmp_dword_op_buf
	clr tmp_dword_op_buf2
	dword_rl tmp_dword_op_buf2,tmp_dword_op_buf
	
	;dword_add tmp_addr_h,tmp_addr_l,tmp_dword_op_buf
	dword_add2 tmp_addr_h,tmp_addr_l,tmp_dword_op_buf2,tmp_dword_op_buf

	mov tmp_addr_h,a
	movam eeprom_operate_addr_h
	mov tmp_addr_l,a
	movam eeprom_operate_addr_l
	eeprom_read .2
	mov eeprom_value_h,a
	movam led_value_h
	mov eeprom_value_l,a
	movam led_value_l
;endm
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get led show time
;get_led_cycle_time macro
fun_get_led_cycle_time fun
	mov cycle_table_addr_h,a
	movam tmp_addr_h
	mov cycle_table_addr_l,a
	movam tmp_addr_l

	mov led_element_h,a
	andla b'00011111'
	movam tmp_dword_op_buf
	clr tmp_dword_op_buf2
	dword_rl tmp_dword_op_buf2,tmp_dword_op_buf

	dword_add2 tmp_addr_h,tmp_addr_l,tmp_dword_op_buf2,tmp_dword_op_buf
	mov tmp_addr_h,a
	movam eeprom_operate_addr_h
	mov tmp_addr_l,a
	movam eeprom_operate_addr_l
	eeprom_read .2
	mov eeprom_value_h,a
	movam led_cycle_h
	mov eeprom_value_l,a
	movam led_cycle_l
;endm
ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;show one led element
;showledelement macro
fun_showledelement fun

	mov led_cycle_h,a
	movam tm1_counter_h
	mov led_cycle_l,a
	movam tm1_counter_l

	;;;;the tm1 is runging now ,needn't start
	;start_tm1
	bc set_led_1
	bc set_led_2
	bc set_led_3
	bc set_led_4
	bc set_led_5
	bc set_led_6
	bc set_led_7
	bc set_led_8
	bc set_led_9
	bc set_led_10
	bc set_led_11
	bc set_led_12

	btsc led_value_l,.0
	bs set_led_1
	btsc led_value_l,.1
	bs set_led_2
	btsc led_value_l,.2
	bs set_led_3
	btsc led_value_l,.3
	bs set_led_4
	btsc led_value_l,.4
	bs set_led_5
	btsc led_value_l,.5
	bs set_led_6
	btsc led_value_l,.6
	bs set_led_7
	btsc led_value_l,.7
	bs set_led_8
	btsc led_value_h,.0
	bs set_led_9
	btsc led_value_h,.1
	bs set_led_10
	btsc led_value_h,.2
	bs set_led_11
	btsc led_value_h,.3
	bs set_led_12

;endm
ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;working counter check
check_working_counter macro
	local check_working_counter_save,check_working_counter_error,check_working_counter_avail,check_working_counter_end
	dword_ej working_counter_h,working_counter_l,0xff,0xff,check_working_counter_avail
	dword_ej working_counter_h,working_counter_l,0x00,0x00,check_working_counter_error
	dec working_counter_l,m
	enj working_counter_l,0x00,check_working_counter_save
	ej working_counter_h,0x00,check_working_counter_save
	dec working_counter_h,m
check_working_counter_save
	mov working_counter_h,a
	movam eeprom_value_h
	mov working_counter_l,a
	movam eeprom_value_l
	eeprom_write_ex eeprom_work_count_addr_h,eeprom_work_count_addr_l,.2
	lgoto check_working_counter_avail
check_working_counter_error
	bc my_status,work_counter_available
	lgoto check_working_counter_end
check_working_counter_avail
	bs my_status,work_counter_available
check_working_counter_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;prepare next led element 
preparenextledelement macro
	local preparenextledelement_get_module_index,preparenextledelement_get_element,preparenextledelement_counter_available,preparenextledelement_end,preparenextledelement_counter_error
	
	movla .2
	movam tmp_dword_op_buf
	dword_add cur_element_addr_h,cur_element_addr_l,tmp_dword_op_buf
	;get_element_value
	lcall fun_get_element_value
	enj led_element_h,0xff,preparenextledelement_get_element
	enj led_element_l,0xff,preparenextledelement_get_element
	;;;;;;module end
	movla .1
	movam tmp_dword_op_buf
	dword_add cur_pattern_addr_h,cur_pattern_addr_l,tmp_dword_op_buf
	lcall fun_get_module_index
	enj cur_module_index,0xff,preparenextledelement_get_module_index
	;;;;;pattern end
	;dword_ej working_counter_h,working_counter_l,0xff,0xff,preparenextledelement_counter_available

	;dec working_counter_l,m
	;enj working_counter_l,0x00,preparenextledelement_counter_available
	;ej working_counter_h,0x00,preparenextledelement_counter_error
	;dec working_counter_h,m
	check_working_counter
	btss my_status,work_counter_available
	lgoto preparenextledelement_counter_error
preparenextledelement_counter_available
	mov pattern_table_addr_h,a
	movam cur_pattern_addr_h
	mov pattern_table_addr_l,a
	movam cur_pattern_addr_l
	lcall fun_get_module_index
	
	
preparenextledelement_get_module_index
	lcall fun_get_module_entry

preparenextledelement_get_element
	lcall fun_get_element_value
	lcall fun_get_led_value
	lcall fun_get_led_cycle_time
	lgoto preparenextledelement_end
preparenextledelement_counter_error
	bc my_status,tm1_overflow
	clr led_value_h
	clr led_value_l
	lcall fun_showledelement
	stop_tm1
	
	

preparenextledelement_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start to show led 
start_led_show macro
	local start_led_show_counter_available,start_led_show_end
	;get_show_info_from_eeprom
	;enj working_counter_l,0x00,start_led_show_counter_available
	;enj working_counter_h,0x00,start_led_show_counter_available
	check_working_counter
	btsc my_status,work_counter_available
	lgoto start_led_show_counter_available
	bc my_status,tm1_overflow
	stop_tm1
	lgoto start_led_show_end 

start_led_show_counter_available
	mov pattern_table_addr_h,a
	movam cur_pattern_addr_h
	mov pattern_table_addr_l,a
	movam cur_pattern_addr_l
	
	lcall fun_get_module_index
	lcall fun_get_module_entry
	lcall fun_get_element_value
	lcall fun_get_led_value
	lcall fun_get_led_cycle_time

	bc my_status,tm1_overflow
	start_tm1
	lcall fun_showledelement
	preparenextledelement
start_led_show_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start to work
enterworkmode macro
	local workmode_dayloop

	;;;;;;;;;;day	
workmode_dayloop
	clrwdt

	brightness_check
	btss my_status,night_work_mode
	lgoto workmode_day_thing
	start_led_show
	lgoto workmode_nightloop

workmode_day_thing

	;serial_command
	btsc my_status,rx_int_status
	lgoto workmode_serial_int
	
	lgoto workmode_dayloop
	;;;;;;;;;;;;;;;;;;;night
workmode_nightloop
	clrwdt
	btsc my_status,rx_int_status
	lgoto workmode_serial_int
	
	brightness_check
	btsc my_status,night_work_mode
	lgoto workmode_night_thing
	;;turn off all led
	stop_led_show
	lgoto workmode_dayloop
workmode_night_thing
	btss my_status,tm1_overflow
	lgoto workmode_nightloop
	bc my_status,tm1_overflow

	lcall fun_showledelement
	preparenextledelement

	lgoto workmode_nightloop
workmode_end
	stop_led_show
workmode_serial_int
	;bc IRQM,PAM
	stop_tm1
	bc IRQM,PAM
	serial_command
	bs IRQM,PAM
	clr IRQF
	clr my_status
	
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start to translate
entertransmode macro

transmodeloop
	lgoto transmodeloop
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;delay function
;;the conter expresstion      (instruction_counter)*(instructions_per_circle) = (total_instruction)-4
;;ps:mk7a21p one instruction build by 2 system clock...  mk7a11p is 4 system clock

ifdef USE_EMLUATOR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 40us  
delay_40us
;	clrwdt
	movla const_delay_40us
	movam delay_counter
delay_40_us_loop
	clrwdt
	decsz delay_counter,m
	lgoto delay_40_us_loop
delay_40us_end
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 100us 
delay_100us
;	clrwdt
	movla const_delay_100us
	movam delay_counter
delay_100_us_loop
	clrwdt
	decsz delay_counter,m
	lgoto delay_100_us_loop
;	clrwdt
;	clrwdt
delay_100us_end
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 560us 
delay_560us
	movla const_delay_560us
	movam delay_counter	
delay_560us_loop
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	decsz delay_counter,m
	lgoto delay_560us_loop
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
delay_560us_end
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 1680us	 
delay_1680us
	movla const_delay_1680us
	movam delay_counter	
delay_1680us_loop
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
	clrwdt
	clrwdt
	clrwdt
	decsz delay_counter,m
	lgoto delay_1680us_loop
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
	clrwdt
	clrwdt

	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 1ms 
delay_1ms
	movla const_delay_1ms
	movam delay_counter
delay_1ms_loop
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	decsz delay_counter,m
	lgoto delay_1ms_loop
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
delay_1ms_end
	ret
else						;;;;;ic's clock is not correct....fix it 。。
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 40us  
delay_40us
	clrwdt
	clrwdt
	movla const_delay_40us
	movam delay_counter
delay_40_us_loop
	clrwdt
	decsz delay_counter,m
	lgoto delay_40_us_loop
delay_40us_end
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 100us 
delay_100us
	movla .50
	movam delay_counter
delay_100_us_loop
	clrwdt
	decsz delay_counter,m
	lgoto delay_100_us_loop
	clrwdt
	clrwdt
delay_100us_end
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 1ms 
delay_1ms
	movla .206
	movam delay_counter
delay_1ms_loop
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	clrwdt
	decsz delay_counter,m
	lgoto delay_1ms_loop
	clrwdt
	clrwdt
delay_1ms_end
	ret
endif


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;int function
int_entry
	;;enter int ,save the register..
	movam a_buf 
	swap status,a 
	movam status_buf 


	btsc IRQF,TM1F		;test int type
	lgoto int_tm1_entry  	;switch to right type int
	btsc IRQF,PAF
	lgoto int_pa_entry


int_tm1_entry
	int_tm1
	lgoto int_entry_end
int_pa_entry
	int_pa
	lgoto int_entry_end
int_entry_end
	;quit int ,restore the register
	swap   		status_buf,a 
	movam  		status 
	swap   		a_buf,m
	swap   		a_buf,a	
	reti


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;main function     it must write under the macro ,or it can't call the macro
main
	init_chip

	clr eeprom_operate_addr_h
	clr eeprom_operate_addr_l
	;bc IRQF,PAF
	;bs IRQM,PAM
	;bs IRQM,INTM
	;bs PA_INTE,bit_rx
;	
main_loop
	clrwdt
	enterworkmode
	;entertransmode

;	get_rom_size
;	serial_command
;	movla 0x55
;	movam 0xa0
;	eeprom_write_ex 0xff,0xff,.1
;	nop
;	clr 0xa0
;	eeprom_read_ex 0xff,0xff,.1
;	clr 0xa0
;	nop
;	eeprom_read_ex 0x1f,0xff,1

;	eeprom_read .8
;	movla .8
;	movam tmp_dword_op_buf
;	dword_add eeprom_operate_addr_h,eeprom_operate_addr_l,tmp_dword_op_buf

	lgoto main_loop
	ret



end











