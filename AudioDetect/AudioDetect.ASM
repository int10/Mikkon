;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;creat by int10@100618
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;use mk7a25p	

#include  "mk7a25p.inc"  ;编译该文档需包含"mk7a21p.inc"文件



;配置寄存器设置说明（CONFIG） 
;1-----------FOSC=RC    ;LS,NS,HS,RC    
;2-----------INRC=ON    ;ON,OFF 
;3-----------CPT=ON    ;ON,OFF    
;4-----------WDTE=Enable   ;Enable,Disable 
;5-----------LV=Low Vol Reset ON  ;Low Vol Reset ON,Low Vol Reset OFF 
;6-----------RESET=...input...   ;...input...,...reset... 

;#define USE_EMLUATOR
#define fun


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;const for tm1,about 15 minutes to overflow
;;#define const_timeout_tm1_15min_h			0x1c
;;#define const_timeout_tm1_15min_l			0x20
#define const_timeout_tm1_15min_h			0x01
#define const_timeout_tm1_15min_l			0xe0
#define const_timeout_tm1_5sec_h			0x00
#define const_timeout_tm1_5sec_l			0x28


#define const_audio_playing_div			.2



ch_audio_analog_in_r			equ 0x00
ch_audio_analog_in_l			equ 0x01

#define PORTB PB_DAT
#define PORTA PA_DAT
#define PORTC PC_DAT
#define BSR FSR



bit_stand_by_signal		equ	PB2
bit_stand_by_signal2	equ	PC3
bit_test_mode_key		equ	PC1


#define set_stand_by_signal		PORTB,bit_stand_by_signal
#define set_stand_by_signal2		PORTC,bit_stand_by_signal2
#define test_test_mode_key		PORTC,bit_test_mode_key


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;my_status bit define
tm1_overflow				equ 		0
test_mode_status			equ		1		;0:normal mode ,1:test mode

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

my_status				equ			0x48		;;;


audio_max_value		equ			0x50
audio_min_value		equ			0x51

adc_time_out_counter	equ			0x52

adc_value_h				equ			0x53
adc_value_l				equ			0x54
adc_merged_value		equ			0x55

audio_detect_cur_channel	equ		0x56		;0:Right     1:Left
audio_detect_counter		equ		0x57
adc_compare_resut 		equ			0x58



adc_tmp_value_r1			equ			0x60
adc_tmp_value_r2			equ			0x61
adc_tmp_value_r3			equ			0x62
adc_tmp_value_r4			equ			0x63
adc_tmp_value_r5			equ			0x64
adc_tmp_value_r6			equ			0x65
adc_tmp_value_r7			equ			0x66
adc_tmp_value_r8			equ			0x67
adc_tmp_value_r9			equ			0x68
adc_tmp_value_r10			equ			0x69

adc_tmp_value_l1			equ			0x70
adc_tmp_value_l2			equ			0x71
adc_tmp_value_l3			equ			0x72
adc_tmp_value_l4			equ			0x73
adc_tmp_value_l5			equ			0x74
adc_tmp_value_l6			equ			0x75
adc_tmp_value_l7			equ			0x76
adc_tmp_value_l8			equ			0x77
adc_tmp_value_l9			equ			0x78
adc_tmp_value_l10			equ			0x79


#include "..\util.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set main entery

org			0x000	
lgoto		main
org			0x004
lgoto		int_entry

org 			0x0010

#include "..\delay.asm"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;init the chip
init_chip macro

	;PortA端口方向及状态设定            
	movla      	0xff
	movam temp_buf
	mov temp_buf,a
	movam PA_DIR
	clr   		PORTA
	;------------------------------------------------------ 
	;PortB端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
	bc temp_buf,bit_stand_by_signal
	mov temp_buf,a
	movam PB_DIR
	clr   		PORTB
	;------------------------------------------------------

	;PortC端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
	bc temp_buf,PC2
	bc temp_buf,bit_stand_by_signal2
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
	bs set_stand_by_signal
	clr audio_detect_counter


	movla const_timeout_tm1_15min_h
	movam tm1_counter_h
	movla const_timeout_tm1_15min_l
	movam tm1_counter_l
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;init wtd
	movla b'10000111'
	movam WDT_CTL

	;;;;;;;;;;;;;;;;;;;;;;;;
	clr my_status


	clr IRQF
	bs IRQM,INTM
endm

#include "..\tmDrv.asm"
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
	;test int from pa0 or pa1
	;btss test_rx
	lgoto int_pa_0
int_pa_1
	nop
	lgoto int_pa_end
int_pa_0
	nop
	bs my_status,rx_int_status
int_pa_end

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;if overflow , goto standby mode
tm1_check_overflow macro
	btsc my_status,tm1_overflow
	lgoto goto_standby_mode
	lgoto tm1_check_overflow_end
goto_standby_mode
	bc set_stand_by_signal
	bs set_stand_by_signal2
	m_delay_ms .200
	m_delay_ms .200
	m_delay_ms .200
;	bc set_stand_by_signal2
	bc my_status,tm1_overflow
	movla const_timeout_tm1_15min_h
	movam tm1_counter_h
	movla const_timeout_tm1_15min_l
	movam tm1_counter_l

	lgoto goto_standby_mode

tm1_check_overflow_end

	
endm

#include "..\adcDrv.asm"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;merge adc_value_h&adc_value_l into one byte ,assume adc_value_h high 2bit is 0
merge_adc_value macro
	rlc adc_value_l,m
	rlc adc_value_h,m
	rlc adc_value_l,m
	rlc adc_value_h,m
	mov adc_value_h,a
	movam adc_merged_value
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;check play or stop
check_adc_div macro L_start_addr,L_stop_addr
	local check_adc_div_check_0_next,check_adc_div_start,check_adc_div_test_mode,check_adc_div_reset_tm1_end,check_adc_div_stop,check_adc_div_end,check_adc_div_move_next
	merge_adc_value
	mov adc_merged_value,a
	movam L_start_addr
	movla L_start_addr
	movam FSR
check_adc_div_check_0_next
	ej INDF,0,check_adc_div_end
	ej FSR,L_stop_addr,check_adc_div_start
	inc FSR,m
	lgoto check_adc_div_check_0_next
check_adc_div_start
	clr FSR
	get_max_value L_start_addr,L_stop_addr,audio_max_value
	get_min_value L_start_addr,L_stop_addr,audio_min_value
	abs_sub audio_max_value,audio_min_value,adc_compare_resut
	ej adc_compare_resut,const_audio_playing_div,check_adc_div_stop
	sj adc_compare_resut,const_audio_playing_div,check_adc_div_stop
	
	btsc my_status,test_mode_status
	lgoto check_adc_div_test_mode
	movla const_timeout_tm1_15min_h
	movam tm1_counter_h
	movla const_timeout_tm1_15min_l
	movam tm1_counter_l
	lgoto check_adc_div_reset_tm1_end
check_adc_div_test_mode
	movla const_timeout_tm1_5sec_h
	movam tm1_counter_h
	movla const_timeout_tm1_5sec_l
	movam tm1_counter_l

check_adc_div_reset_tm1_end
	bs PORTC,PC2
	lgoto check_adc_div_end
check_adc_div_stop
	bc PORTC,PC2
	
check_adc_div_end
	clr FSR
	movla L_stop_addr
	subla .1
	movam FSR
check_adc_div_move_next
	mov INDF,a
	inc FSR,m
	movam INDF
	dec FSR,m
	dec FSR,m
	enj FSR,L_start_addr,check_adc_div_move_next
	mov INDF,a
	inc FSR,m
	movam INDF
	clr FSR
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan key
key_scan macro
	btss test_test_mode_key
	lgoto key_scan_end
	m_delay_ms .80
	btss test_test_mode_key
	lgoto key_scan_end
	movla const_timeout_tm1_5sec_h
	movam tm1_counter_h
	movla const_timeout_tm1_5sec_l
	movam tm1_counter_l
	bs my_status,test_mode_status
key_scan_end
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;audio detect
audio_detect macro
	ej audio_detect_cur_channel,0,audio_detect_r_channel
audio_detect_l_channel
	adc_get_value ch_audio_analog_in_l
	ej adc_value_h,0xff,audio_detect_end
	check_adc_div adc_tmp_value_l1,adc_tmp_value_l10
	inc audio_detect_counter,m
	sj audio_detect_counter,10,audio_detect_end
	clr audio_detect_cur_channel
	clr audio_detect_counter
	adc_change_channel ch_audio_analog_in_r
	lgoto audio_detect_end
audio_detect_r_channel
	adc_get_value ch_audio_analog_in_r
	ej adc_value_h,0xff,audio_detect_end
	check_adc_div adc_tmp_value_r1,adc_tmp_value_r10
	inc audio_detect_counter,m
	sj audio_detect_counter,10,audio_detect_end
	movla .1
	movam audio_detect_cur_channel
	clr audio_detect_counter
	adc_change_channel ch_audio_analog_in_l
	lgoto audio_detect_end
	
audio_detect_end
endm

#include "..\intEntry.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;main function     it must write under the macro ,or it can't call the macro
main fun
	init_chip
	;start_tm1 b'01100101',0x09,0x3d			;TM1时钟源内部RC时钟,预分频1:32,溢出周期125ms,IC's clock is faster tha emulate...fix it 
	start_tm1 b'01100101',0x0d,0x3f
	adc_init ch_audio_analog_in_l		;;max number of the adc channel

main_loop
	clrwdt
	m_delay_ms .100

	tm1_check_overflow
;	adc_get_value ch_audio_analog_in_r
;	ej adc_value_h,0xff,adc_error
;	
;	check_adc_div
	audio_detect
	key_scan

	lgoto main_loop
	
	ret



end


