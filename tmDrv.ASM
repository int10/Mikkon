

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;start tm1
start_tm1 macro L_ctl1,L_l_la,L_h_la
	;;init variable
	movla L_ctl1
	movam tm1_ctl1       	;TM1时钟源内部RC时钟,预分频1:32
	;IC's clock is faster tha emulate...fix it 
	;movla 0x09 
	movla L_l_la
	movam tm1l_la 
	;movla 0x3d
	movla L_h_la
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

