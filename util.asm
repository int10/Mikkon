;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;delay function
;;the conter expresstion      (instruction_counter)*(instructions_per_circle) = (total_instruction)-4
;;ps:mk7a21p one instruction build by 2 system clock...  mk7a11p is 4 system clock

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 40us  
;delay_40us
;	movla const_delay_40us
;	movam delay_counter
;delay_40_us_loop
;	clrwdt
;	decsz delay_counter,m
;	lgoto delay_40_us_loop
;delay_40us_end
;	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 100us 
;delay_100us
;	movla const_delay_100us
;	movam delay_counter
;delay_100_us_loop
;	clrwdt
;	decsz delay_counter,m
;	lgoto delay_100_us_loop
;delay_100us_end
;	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 560us 
;delay_560us
;	movla .186
;	movam delay_counter	
;delay_560us_loop
;	clrwdt
;	clrwdt
;	clrwdt
;	decsz delay_counter,m
;	lgoto delay_560us_loop
;delay_560us_end
;	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 1680us	 
;delay_1680us
;	movla .223
;	movam delay_counter	
;delay_1680us_loop
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	decsz delay_counter,m
;	lgoto delay_1680us_loop
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 1ms 
;delay_1ms
;	movla .249
;	movam delay_counter
;delay_1ms_loop
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	decsz delay_counter,m
;	lgoto delay_1ms_loop
;delay_1ms_end
;	clrwdt
;	clrwdt
;	clrwdt
;	clrwdt
;	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;delay x ms ,x<255
;m_delay_ms macro ms
;	local delay_ms_loop
;
;	movla ms
;	movam delay_ms_counter
;delay_ms_loop
;	lcall delay_1ms
;	decsz delay_ms_counter,m
;	lgoto delay_ms_loop
;endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
en_int macro
	bs IRQM,INTM
endm

dis_int macro
	bc IRQM,INTM
endm

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

dword_sub macro dw_h,dw_l,M_value
	local dword_sub_no_carry
	mov M_value,a
	sub dw_l,m
	jnc dword_sub_no_carry
	dec dw_h,m
dword_sub_no_carry
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;absolute of m1-m2.....result place at m_result    |m1-m2|
abs_sub macro m1,m2,m_result
	local m1bm2,abs_sub_end
	mov m2,a
	sub m1,a
	jc m1bm2
	mov m2,a
	movam m_result
	mov m1,a
	sub m_result,m
	lgoto abs_sub_end
m1bm2
	mov m1,a
	movam m_result
	mov m2,a
	sub m_result,m
	
abs_sub_end
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;find the first position of the value specified bit value,L_bit_value can only be 0 or 1
bit_index macro M_po,M_value,L_bit_value
	local bit_index_1,bit_index_0,bit_index_not_found,bit_index_end,bit_index_found
	clr M_po
	clr bit_index_counter
	movla L_bit_value
	tmss a
	lgoto bit_index_1
	lgoto bit_index_0
	;ej L_bit_value,0,bit_index_0
bit_index_1
	bc STATUS,C
	rrc M_value,m
	jc bit_index_found
	inc bit_index_counter,m
	ej bit_index_counter,8,bit_index_not_found
	lgoto bit_index_1
	

bit_index_0
	bc STATUS,C
	rrc M_value,m
	jnc bit_index_found
	inc bit_index_counter,m
	ej bit_index_counter,8,bit_index_not_found
	lgoto bit_index_0
bit_index_found
	mov bit_index_counter,a
	movam M_po
	lgoto bit_index_end
bit_index_not_found
	movla 0xff
	movam M_po
bit_index_end
	endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get max audio value ..get the max value from start addr to stop addr ,and place the max value at M_max_value
get_max_value macro L_start_addr,L_stop_addr,M_max_value
	local get_max_value_next,get_max_value_not_bigger
	movla L_start_addr
	movam FSR
	mov L_start_addr,a
	movam M_max_value
get_max_value_next
	mov M_max_value,a
	inc FSR,m
	sub INDF,a
	jnc get_max_value_not_bigger
	mov INDF,a
	movam M_max_value
get_max_value_not_bigger
	enj FSR,L_stop_addr,get_max_value_next
	clr FSR
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get min audio value
get_min_value macro L_start_addr,L_stop_addr,M_min_value
	local get_min_value_next,get_min_value_not_smaller
	movla L_start_addr
	movam FSR
	mov L_start_addr,a
	movam M_min_value
get_min_value_next
	mov M_min_value,a
	inc FSR,m
	sub INDF,a
	jc get_min_value_not_smaller
	mov INDF,a
	movam M_min_value
get_min_value_not_smaller
	enj FSR,L_stop_addr,get_min_value_next
	clr FSR
endm

	



