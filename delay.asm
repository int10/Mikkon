;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;delay function
;;int10@130731	it's use at chip MK7A25P ,had better not use it at other chip

ifdef USE_EMLUATOR
else						;;;;;ic's clock is not correct....fix it ¡£¡£
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;wait 40us  
delay_40us
	clrwdt
	clrwdt
	movla .19
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
