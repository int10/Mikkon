;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;creat by int10@101103			for too many dsp defines , move all of them to here to make the code look better


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#define Cmd_dsp_hw_reset		0xa0
#define Cmd_start_code			0xa1
#define Cmd_send_4bytes			0xa2
#define Cmd_wait_irq_low			0xa3
#define Cmd_dsp_dev_write		0xa4
#define Cmd_dsp_dev_read		0xa5
#define Cmd_get_4bytes			0xa6
#define Cmd_stop_code			0xa7
#define Cmd_set_cs8614			0xa8
#define Cmd_get_cs8614			0xa9

#define Ack_ok						0x50
#define Ack_faile					0x51
#define Ack_8614_data				0x52
#define Ack_data_not_end			0x53
#define Ack_data_end				0x54

