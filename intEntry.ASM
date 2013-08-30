;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;int function
int_entry fun
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
	movam           status
	swap   		a_buf,m
	swap   		a_buf,a	
	reti

