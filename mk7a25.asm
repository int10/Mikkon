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


#define const_delay_40us		.19
#define const_delay_100us		.49
#define const_delay_560us		.111
#define const_delay_1680us		.167
#define const_delay_1ms		.199

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;memery map			;;;;  0x40~0xbf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

a_buf			equ   		0x40   		;acc缓存器 
status_buf		equ   		0x41   		;status缓存器 
temp_buf		equ			0x42
delay_counter	equ			0x43
delay_ms_counter		equ			0x44
tm0_overflow			equ			0x45

adc_value				equ			0x5f




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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
mycall macro function
	lcall function
endm

myret macro
	ret
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set main entery

org			0x000	
lgoto		main

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

ifdef USE_CHIP_MK7A21P
	;PortA端口方向及状态设定            
	movla      	0xff
	movam temp_buf
	bc temp_buf,bit_stb
	bc temp_buf,bit_reset
	mov temp_buf,a
	movam PA_DIR
	clr   		PORTA
	clr          	PA_PLU
	;------------------------------------------------------ 
	;PortB端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
	mov temp_buf,a
	movam PB_DIR
	clr   		PORTB
	;------------------------------------------------------

	;PortC端口方向及状态设定  
	movla        	b'11111111'              ;;all are input pin
	movam temp_buf
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


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;init wtd
	movla b'10000111'
	movam WDT_CTL


endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start to work
enterworkmode macro

workmodeloop

	brightness_check
	

	btss tm0_overflow,0
	lgoto workmodeloop

	showledelement
	preparenextledelement


	
	lgoto workmodeloop
workmode_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start to translate
entertransmode macro
transmodeloop
	lgoto transmodeloop
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;read adc and return the value at adc_value
adc_get_value macro channel
	local adc_check_complete,adc_get_value_end,adc_get_value_delay
	movla 0xff
	movam adc_value
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
	movam tm_counter_l
adc_check_complete
	clrwdt
	lcall delay_40us
	btss AD_CTL1,7
	lgoto adc_get_value_end
	decsz tm_counter_l,m
	lgoto adc_check_complete
adc_get_value_end
	mov AD_DAT,a
	movam adc_value


	movla .4			;had better have 16 instruction nop before it go to next adc_get_value
	movam tm_counter_l
adc_get_value_delay
	decsz tm_counter_l,m
	lgoto adc_get_value_delay
	
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;delay function
;;the conter expresstion      (instruction_counter)*(instructions_per_circle) = (total_instruction)-4
;;ps:mk7a21p one instruction build by 2 system clock...  mk7a11p is 4 system clock

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;main function     it must write under the macro ,or it can't call the macro
main
	init_chip
main_loop
	clrwdt
	enterworkmode
	entertransmode
	lgoto main_loop
	ret



end











