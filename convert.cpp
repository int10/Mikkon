


////////////////////////////////////////////////////////////////
//creat by int10 for the compiler have a bug , under condition compile , the not compile part can't contain macro , 
//but I have write many macro in the code ....now ,i write the demo program to remove the not-compile part....


//it only can work...but not good....


#include "stdio.h"
#include "string.h"
#define _U	0x01	/* upper */
#define _L	0x02	/* lower */
#define _D	0x04	/* digit */
#define _C	0x08	/* cntrl */
#define _P	0x10	/* punct */
#define _S	0x20	/* white space (space/lf/tab) */
#define _X	0x40	/* hex digit */
#define _SP	0x80	/* hard space (0x20) */

unsigned char _ctype[] = {
_C,_C,_C,_C,_C,_C,_C,_C,			/* 0-7 */
_C,_C|_S,_C|_S,_C|_S,_C|_S,_C|_S,_C,_C,		/* 8-15 */
_C,_C,_C,_C,_C,_C,_C,_C,			/* 16-23 */
_C,_C,_C,_C,_C,_C,_C,_C,			/* 24-31 */
_S|_SP,_P,_P,_P,_P,_P,_P,_P,			/* 32-39 */
_P,_P,_P,_P,_P,_P,_P,_P,			/* 40-47 */
_D,_D,_D,_D,_D,_D,_D,_D,			/* 48-55 */
_D,_D,_P,_P,_P,_P,_P,_P,			/* 56-63 */
_P,_U|_X,_U|_X,_U|_X,_U|_X,_U|_X,_U|_X,_U,	/* 64-71 */
_U,_U,_U,_U,_U,_U,_U,_U,			/* 72-79 */
_U,_U,_U,_U,_U,_U,_U,_U,			/* 80-87 */
_U,_U,_U,_P,_P,_P,_P,_P,			/* 88-95 */
_P,_L|_X,_L|_X,_L|_X,_L|_X,_L|_X,_L|_X,_L,	/* 96-103 */
_L,_L,_L,_L,_L,_L,_L,_L,			/* 104-111 */
_L,_L,_L,_L,_L,_L,_L,_L,			/* 112-119 */
_L,_L,_L,_P,_P,_P,_P,_C,			/* 120-127 */
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,		/* 128-143 */
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,		/* 144-159 */
_S|_SP,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,   /* 160-175 */
_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,       /* 176-191 */
_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,       /* 192-207 */
_U,_U,_U,_U,_U,_U,_U,_P,_U,_U,_U,_U,_U,_U,_U,_L,       /* 208-223 */
_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,       /* 224-239 */
_L,_L,_L,_L,_L,_L,_L,_P,_L,_L,_L,_L,_L,_L,_L,_L};      /* 240-255 */


#define __ismask(x) (_ctype[(int)(unsigned char)(x)])

#define isalnum(c)	((__ismask(c)&(_U|_L|_D)) != 0)
#define isalpha(c)	((__ismask(c)&(_U|_L)) != 0)
#define iscntrl(c)	((__ismask(c)&(_C)) != 0)
#define isdigit(c)	((__ismask(c)&(_D)) != 0)
#define isgraph(c)	((__ismask(c)&(_P|_U|_L|_D)) != 0)
#define islower(c)	((__ismask(c)&(_L)) != 0)
#define isprint(c)	((__ismask(c)&(_P|_U|_L|_D|_SP)) != 0)
#define ispunct(c)	((__ismask(c)&(_P)) != 0)
#define isspace(c)	((__ismask(c)&(_S)) != 0)
#define isupper(c)	((__ismask(c)&(_U)) != 0)
#define isxdigit(c)	((__ismask(c)&(_D|_X)) != 0)

#define isascii(c) (((unsigned char)(c))<=0x7f)
#define toascii(c) (((unsigned char)(c))&0x7f)




#define MAX_KEY_WORD_NUMBER		100
char key_word[MAX_KEY_WORD_NUMBER][50];
int cur_key_word = 0;
char code_in_valid_area = 1;
int def_level = 0;
FILE *output = 0;


int def_handle(char *buf)
{
	char *p,*p1;
	if(strncmp(buf,"#define",strlen("#define")) != 0)
		return 0;

	if(!code_in_valid_area)
	{
		if(output)
		{
			fputc(';',output);
			fputs(buf,output);
		}
		return 1;
	}
	
	p = buf;
	p += strlen("#define");

	while(!isalpha(*p))
		p++;
	p1 = p;
	while(isalnum(*p)||*p == '_')
		p++;

	if(cur_key_word == MAX_KEY_WORD_NUMBER)
	{
		printf("warning too man key word!!!\n");
		return 1;
	}
	strncpy(key_word[cur_key_word],p1,p-p1);
	key_word[cur_key_word][p-p1] = 0;
	
	cur_key_word++;

	if(output)
		fputs(buf,output);
	
	return 1;
}

int ifdef_handle(char *buf)
{
	char *p;
	int i;
	if(strncmp(buf,"ifdef",strlen("ifdef"))!=0)
		return 0;

	if(!code_in_valid_area)
	{
		def_level++;
		if(output)
		{
			fputc(';',output);
			fputs(buf,output);
		}
		return 1;
	}

	p = buf;
	p+=strlen("ifdef");

	while(!isalpha(*p))
		p++;
		
	for(i = 0;i<cur_key_word;i++)
	{
		if(strncmp(p,key_word[i],strlen(key_word[i])) == 0)
			break;
	}
	if(i == cur_key_word)
		code_in_valid_area = 0;

	if(output)
		fputs(buf,output);
	
	return 1;
}

int ifndef_handle(char *buf)
{
	char *p;
	int i;
	if(strncmp(buf,"ifndef",strlen("ifndef"))!=0)
		return 0;

	if(!code_in_valid_area)
	{
		def_level++;
		if(output)
		{
			fputc(';',output);
			fputs(buf,output);
		}
		return 1;
	}

	p = buf;
	p+=strlen("ifndef");

	while(!isalpha(*p))
		p++;
		
	for(i = 0;i<cur_key_word;i++)
	{
		if(strncmp(p,key_word[i],strlen(key_word[i])) == 0)
		{
			code_in_valid_area = 0;
			break;
		}
	}

	if(output)
		fputs(buf,output);
	
	return 1;
}



int else_handle(char *buf)
{
	if(strncmp(buf,"else",strlen("else"))!=0)
		return 0;
	if(!code_in_valid_area&&def_level!=0)
	{
		if(output)
		{
			fputc(';',output);
			fputs(buf,output);
		}
		return 1;
	}
	else if(!code_in_valid_area&&def_level == 0)
		code_in_valid_area = 1;
	else if(code_in_valid_area)
		code_in_valid_area = 0;

	if(output)
		fputs(buf,output);

	return 1;
		
	
}

int endif_handle(char *buf)
{
	if(strncmp(buf,"endif",strlen("endif"))!=0)
		return 0;
	if(!code_in_valid_area&&def_level!=0)
	{
		if(output)
		{
			fputc(';',output);
			fputs(buf,output);
		}
		def_level--;
		return 1;		
	}
	else if(!code_in_valid_area&&def_level == 0)
		code_in_valid_area = 1;

	if(output)
		fputs(buf,output);
	return 1;
}


int main(int argc ,char **argv)
{
	
	FILE *input;
	char file_buf[1024];
	char *file_head,*file_source,*file_output;

	if(argc == 3)
	{
		file_head = NULL;
		file_source = argv[1];
		file_output = argv[2];
	}
	else if(argc ==4)
	{
		file_head = argv[1];
		file_source = argv[2];
		file_output = argv[3];		
	}
	else
	{
		printf("wrong execute params!!\n");
		getchar();
		return 0;
	}

	
	if(file_head)
	{
		//input = fopen("config.inc","r");
		input = fopen(file_head,"r");
		if(input == 0)
			return 0;

		while(fgets(file_buf,1024,input))
		{
			def_handle(file_buf);
			ifdef_handle(file_buf);
			ifndef_handle(file_buf);
			else_handle(file_buf);
			endif_handle(file_buf);
		}

		fclose(input);
	}
	

	//input = fopen("main_source.asm","r");
	input = fopen(file_source,"r");
	if(input == 0)
		return 0;
	//output = fopen("main.asm","w");
	output = fopen(file_output,"w");
	if(output == 0)
	{
		fclose(input);
		return 0;
	}

	while(fgets(file_buf,1024,input))
	{
		if(def_handle(file_buf ))
			continue;
		if(ifdef_handle(file_buf))
			continue;
		if(ifndef_handle(file_buf))
			continue;
		if(else_handle(file_buf))
			continue;
		if(endif_handle(file_buf))
			continue;
		if(code_in_valid_area)
			fputs(file_buf,output);
		else
		{
			fputc(';',output);
			fputs(file_buf,output);
		}	
	}

	for(int i;i<cur_key_word;i++)
		printf("%s\n", key_word[i]);

	getchar();

	
	fclose(output);
	
	
}



