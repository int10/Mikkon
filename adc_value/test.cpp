// test.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

int main(int argc, char* argv[])
{
	//unsigned char aa[] = {12,28,44,63,78,95,111,126,143};
	//unsigned char aa[] = {123,112,98,82,66,44,17};
	unsigned char aa[] = {124,113,100,84,67,49,27};
	for(int i=0 ;i<(sizeof(aa)/sizeof(unsigned char));i++)
		printf("0x%02x%02x\n",aa[i]-5,aa[i]+5);
	//printf("Hello World!\n");
	return 0;
}

//124	121		124
//113	112		113
//97	97		100
//81	81		84
//65	65		67
//48	44		49
//14	19		27