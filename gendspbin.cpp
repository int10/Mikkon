#include "stdio.h"
#include "dspdata.h"

typedef struct __BUF_INFO
{
	unsigned short StartAddr;
	unsigned short Size;
}BUF_INFO;
typedef struct __DSP_DATA
{
	unsigned int size;
	unsigned long *data;
}DSP_DATA;

DSP_DATA dataList[] =
{
	{sizeof(OS_P6_uld)/sizeof(unsigned long),OS_P6_uld},
	{sizeof(OS_P2_uld)/sizeof(unsigned long),OS_P2_uld},
	{sizeof(COMS2_P2_uld)/sizeof(unsigned long),COMS2_P2_uld},
	{sizeof(CIRCLE_SURR2_P2_uld)/sizeof(unsigned long),CIRCLE_SURR2_P2_uld},
	{sizeof(PL2_P2_uld)/sizeof(unsigned long),PL2_P2_uld},
	{sizeof(DVS2_P2_uld)/sizeof(unsigned long),DVS2_P2_uld},
	{sizeof(TSXT_P2_uld)/sizeof(unsigned long),TSXT_P2_uld},
	{sizeof(TSHD_P6_uld)/sizeof(unsigned long),TSHD_P6_uld},
	{sizeof(DH2_P2_uld)/sizeof(unsigned long),DH2_P2_uld},
	{sizeof(SPP_P2_uld)/sizeof(unsigned long),SPP_P2_uld},
	{sizeof(ANALOG_IN_TSHD_P6_ULD_uld)/sizeof(unsigned long),ANALOG_IN_TSHD_P6_ULD_uld},
	{0,0},
	{0,0},
	{0,0},
	{0,0},
	{0,0},

	
	{sizeof(board_cfg_rx)/sizeof(unsigned long),board_cfg_rx},			//start index is 16    
	{sizeof(board_cfg_mc)/sizeof(unsigned long),board_cfg_mc},

	{ sizeof(pcm_cfg_spdif)/sizeof(unsigned long), pcm_cfg_spdif },
	{ sizeof(pcm_cfg_analog_lr)/sizeof(unsigned long), pcm_cfg_analog_lr },
	{ sizeof(pcm_cfg_analog_lsrs)/sizeof(unsigned long), pcm_cfg_analog_lsrs },
	{ sizeof(pcm_cfg_analog_csub)/sizeof(unsigned long), pcm_cfg_analog_csub },
	{ sizeof(pcm_cfg_multi_analog)/sizeof(unsigned long), pcm_cfg_multi_analog },

	{ sizeof(os_cfg_spdif)/sizeof(unsigned long), os_cfg_spdif	},
	{ sizeof(os_cfg_analog)/sizeof(unsigned long), os_cfg_analog	},

	{	sizeof(cs2_cfg_default)/sizeof(unsigned long), cs2_cfg_default	},
	{	sizeof(cs2_cfg_all)/sizeof(unsigned long), cs2_cfg_all	},
	{	sizeof(cs2_cfg_disable)/sizeof(unsigned long), cs2_cfg_disable	},

	{	sizeof(pl2_cfg_movie)/sizeof(unsigned long), pl2_cfg_movie	},
	{	sizeof(pl2_cfg_music)/sizeof(unsigned long), pl2_cfg_music	},
	{	sizeof(pl2_cfg_matrix)/sizeof(unsigned long), pl2_cfg_matrix	},
	{	sizeof(pl2_cfg_custom)/sizeof(unsigned long), pl2_cfg_custom	},
	{	sizeof(pl2_cfg_disable)/sizeof(unsigned long), pl2_cfg_disable	},

	{	sizeof(dvs2_cfg_wide)/sizeof(unsigned long), dvs2_cfg_wide	},
	{	sizeof(dvs2_cfg_reference)/sizeof(unsigned long), dvs2_cfg_reference	},
	{	sizeof(dvs2_cfg_disable)/sizeof(unsigned long), dvs2_cfg_disable	},

	{	sizeof(dvs2_output_2_0)/sizeof(unsigned long), dvs2_output_2_0	},
	{	sizeof(dvs2_output_2_1)/sizeof(unsigned long), dvs2_output_2_1	},
	{	sizeof(dvs2_output_3_0)/sizeof(unsigned long), dvs2_output_3_0	},
	{	sizeof(dvs2_output_3_1)/sizeof(unsigned long), dvs2_output_3_1	},
	{	sizeof(dvs2_output_4_0)/sizeof(unsigned long), dvs2_output_4_0	},
	{	sizeof(dvs2_output_4_1)/sizeof(unsigned long), dvs2_output_4_1	},
	{	sizeof(dvs2_output_5_0)/sizeof(unsigned long), dvs2_output_5_0	},
	{	sizeof(dvs2_output_5_1)/sizeof(unsigned long), dvs2_output_5_1	},

	{	sizeof(tsxt_cfg_default)/sizeof(unsigned long), tsxt_cfg_default	},
	{	sizeof(tsxt_cfg_cs2)/sizeof(unsigned long), tsxt_cfg_cs2	},
	{	sizeof(tsxt_cfg_pl2)/sizeof(unsigned long), tsxt_cfg_pl2	},
	{	sizeof(tsxt_cfg_matrix)/sizeof(unsigned long), tsxt_cfg_matrix	},
	{	sizeof(tsxt_cfg_hp)/sizeof(unsigned long), tsxt_cfg_hp	},
	{	sizeof(tsxt_cfg_disable)/sizeof(unsigned long), tsxt_cfg_disable	},

	{	sizeof(tshd_cfg_trubass)/sizeof(unsigned long), tshd_cfg_trubass	},
	{	sizeof(tshd_cfg_dialog)/sizeof(unsigned long), tshd_cfg_dialog	},
	{	sizeof(tshd_cfg_on)/sizeof(unsigned long), tshd_cfg_on	},
	{	sizeof(tshd_cfg_off)/sizeof(unsigned long), tshd_cfg_off	},

	{sizeof(dh2_cfg_default)/sizeof(unsigned long),dh2_cfg_default},
	{sizeof(dh2_cfg_disable)/sizeof(unsigned long),dh2_cfg_disable},


	{ sizeof(tone_cfg_default)/sizeof(unsigned long), tone_cfg_default },

	{sizeof(bm_cfg_multi_0)/sizeof(unsigned long),/* bm_dolby_config_0.cfg */bm_cfg_multi_0},
	{sizeof(bm_cfg_multi_1)/sizeof(unsigned long),/* bm_dolby_config_1.cfg */bm_cfg_multi_1},
	{sizeof(bm_cfg_multi_2)/sizeof(unsigned long),	/* bm_dolby_config_2.cfg */bm_cfg_multi_2},
	{sizeof(bm_cfg_multi_2sub)/sizeof(unsigned long),/* bm_dolby_config_2sub.cfg */bm_cfg_multi_2sub},
	{sizeof(bm_cfg_multi_2a)/sizeof(unsigned long),/* bm_dolby_config_2a.cfg */bm_cfg_multi_2a},
	{sizeof(bm_cfg_multi_3)/sizeof(unsigned long),	/* bm_dolby_config_3.cfg */bm_cfg_multi_3},
	{sizeof(bm_cfg_multi_3sub)/sizeof(unsigned long),/* bm_dolby_config_3sub.cfg */bm_cfg_multi_3sub},
	{sizeof(bm_cfg_multi_simpl)/sizeof(unsigned long),/* bm_dolby_config_simpl.cfg */bm_cfg_multi_simpl},
	{sizeof(bm_cfg_stereo_simpl_sub)/sizeof(unsigned long),/* bm_dolby_config_simpl_sub.cfg */bm_cfg_stereo_simpl_sub	},
	{sizeof(bm_cfg_stereo_0)/sizeof(unsigned long),/* stereo_bm_dolby_config_0.cfg */bm_cfg_stereo_0},
	{sizeof(bm_cfg_stereo_1)/sizeof(unsigned long),/* stereo_bm_dolby_config_1.cfg */bm_cfg_stereo_1},
	{sizeof(bm_cfg_stereo_2)/sizeof(unsigned long),/* stereo_bm_dolby_config_2.cfg */bm_cfg_stereo_2},
	{sizeof(bm_cfg_stereo_2sub)/sizeof(unsigned long),	/* stereo_bm_dolby_config_2sub.cfg */bm_cfg_stereo_2sub},
	{sizeof(bm_cfg_stereo_2a)/sizeof(unsigned long),/* stereo_bm_dolby_config_2a.cfg */bm_cfg_stereo_2a	},
	{sizeof(bm_cfg_stereo_simpl)/sizeof(unsigned long),/* stereo_bm_dolby_config_simpl.cfg */bm_cfg_stereo_simpl},
	{sizeof(bm_cfg_off)/sizeof(unsigned long),	/* "bm_off.cfg" */bm_cfg_off},

	{ sizeof(delay_cfg_default)/sizeof(unsigned long), delay_cfg_default },
	{ sizeof(delay_cfg_tsxt)/sizeof(unsigned long), delay_cfg_tsxt },

	{ sizeof(am_cfg_default)/sizeof(unsigned long), am_cfg_default },
	{ sizeof(am_cfg_mc_out)/sizeof(unsigned long), am_cfg_mc_out },
		
	{ sizeof(kick_st_cfg_default)/sizeof(unsigned long), kick_st_cfg_default },

	{ sizeof(tone_eq_flat)/sizeof(unsigned long), tone_eq_flat },
	{ sizeof(tone_eq_pop)/sizeof(unsigned long), tone_eq_pop },
	{ sizeof(tone_eq_rock)/sizeof(unsigned long), tone_eq_rock },
	{ sizeof(tone_eq_classic)/sizeof(unsigned long), tone_eq_classic },
	{ sizeof(tone_eq_jazz)/sizeof(unsigned long), tone_eq_jazz },

};

BUF_INFO bufHead[128];


typedef union
{
	unsigned long lvalue;
	unsigned char cvalue[4];
}LONGARRAY;

typedef union
{
	unsigned short ivalue;
	unsigned char cvalue[2];
}INTARRAY;
int Array2BinFile(unsigned long *buf,unsigned long size,FILE *fh)
{
	LONGARRAY value;
	unsigned int i,j;
	unsigned int left;
	
	//printf("%d\n",ftell(fh));
	for(i =0;i<size;i++)
	{
		value.lvalue = *buf;
		for(j = 4;j>0;j--)
			fputc(value.cvalue[j-1],fh);
		buf++;
	}
	if(left=((size*sizeof(unsigned long))%16))
	{
		left = 16-left;
		for(i = 0 ;i<left;i++)
			fputc('\0',fh);
	}
	
}

int main()
{
#if 1
	FILE *out,*in;
	unsigned int i = 0,fpos,len,j;
	unsigned char buf[1024];
	
	out = fopen("temp.bin","wb");
	for(i =0;i<(sizeof(dataList)/sizeof(DSP_DATA));i++)
	{
	fpos = ftell(out);
		bufHead[i].StartAddr = fpos+(128*sizeof(BUF_INFO));
		Array2BinFile(dataList[i].data, dataList[i].size, out);
		//bufHead[i].Size = ftell(out)-fpos;
		bufHead[i].Size = dataList[i].size*sizeof(unsigned long);
	}
	for(i = 0;i<(sizeof(dataList)/sizeof(DSP_DATA));i++)
	{
		printf("i = %d sa = %d si =%d\n",i,bufHead[i].StartAddr,bufHead[i].Size);
	}
	
	fclose(out);
	out = fopen("dsp.bin","wb");
	for(i = 0;i<128;i++)
	{
		INTARRAY value;
		value.ivalue= bufHead[i].StartAddr;
		fputc(value.cvalue[1],out);
		fputc(value.cvalue[0],out);
		value.ivalue = bufHead[i].Size;
		fputc(value.cvalue[1],out);
		fputc(value.cvalue[0],out);
	}
	in = fopen("temp.bin","rb");
	while((len = fread(buf,1,1024,in))!=0)
	{
		fwrite(buf,1,len,out);
		//for(j= 0;j<1024;j++)
		//	buf[j] =0;
		//memset(buf,0,1024);
	}
	
//	fpos = ftell(out);
//	bufHead[i].StartAddr = 0;
//	Array2BinFile(OS_P6_uld, sizeof(OS_P6_uld), out);
//	bufHead[i].Size = ftell(out)-fpos;
	fclose(in);
	fclose(out);

#endif	

	//printf("%d  %d  %d\n",sizeof(char),sizeof(short),sizeof(int));
}
