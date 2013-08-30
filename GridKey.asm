;;;;;;;;;;;;;;creat by int10@110322;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;all input pin connect to each pin of pa,it form a 8*8 grid key
;follow:
;1:read pa ,check whether key pressed..if no key pressed ,goto end
;2:set all pa pin to write mode except the pin change to low..
;3:set pa pin to high(one pin each time) and check whether the key press pin change to high,if change ,get key ,if not ,pull up next pin and check..
;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;get key....key data place at grid_key_data
grid_v2k macro
	mov grid_key_line,a
	movam grid_key_data
	bc STATUS,C
	rl grid_key_data,m
	rl grid_key_data,m
	rl grid_key_data,m
	rl grid_key_data,m
	mov grid_key_row,a
	ior grid_key_data,m

	movla 0x07
	movam TAB_BNK
	bc STATUS,C
	rrc grid_key_data,m
	jc grid_v2k_1
	movla 0x50
	add grid_key_data,m
	tabrdh grid_key_data
	movam grid_key_data
	lgoto grid_v2k_end

grid_v2k_1
	movla 0x50
	add grid_key_data,m
	tabrdl grid_key_data
	movam grid_key_data
grid_v2k_end
	
endm



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;scan grid key
gridkey_scan macro
	mov PORTA,a
	movam pa_status
	ej pa_status,0xff,gridkey_scan_end
	m_delay_ms .20
	mov PORTA,a
	movam pa_status
	ej pa_status,0xff,gridkey_scan_end
	;;;set pins to write mode except the pin changed to low
	mov pa_status,a
	movam pa_status_save
	com pa_status,a
	movam PA_DIR
	nop
	nop
	nop
	
	;;;;
	clr grid_key_check_counter
	movla 0x01
	movam pa_mask
gridkey_scan_next_mask
	mov pa_mask,a
	movam PORTA
;	m_delay_ms .1
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

	mov PORTA,a
	ior pa_status_save,a		;;;;set write mode pins value to 1
	movam pa_status
	enj  pa_status,0xff,gridkey_scan_not_get
	
	mov pa_mask,a
	movam PORTA
	mov PORTA,a
	ior pa_status_save,a		;;;;set write mode pins value to 1
	movam pa_status
	enj  pa_status,0xff,gridkey_scan_not_get
	lgoto gridkey_scan_get_value
gridkey_scan_not_get
	bc STATUS,C
	rlc pa_mask,m
	jc gridkey_scan_get_value
	lgoto gridkey_scan_next_mask
	
gridkey_scan_get_value
	nop
	bit_index grid_key_line,pa_status_save,0
	ej grid_key_line,0xff,gridkey_scan_end
	bit_index grid_key_row,pa_mask,1
	enj grid_key_row,0xff,gridkey_scan_get_key
	nop
	mov grid_key_line,a
	movam grid_key_row
gridkey_scan_get_key
	nop
	grid_v2k
	grid_key_handle

gridkey_scan_end
	movla 0xff
	movam PA_DIR
	
	endm










