/************************************************************************
/ Copyright 2003, ShenZhen Startech Development Ltd.
/ Created by Linjie, 2003.03.12
/ File name: 	bios.h
/ Ver:	1.0
/ Project: RDVD 4000 mcu software
/ Description: General define file.
************************************************************************/

#ifndef	_BIOS_H
#define	_BIOS_H

//#include <reg52.h>
//#include <intrins.h>
//#include <string.h>
//#include <stdio.h>


/*==================================================
	type define
==================================================*/
typedef char 				Int8;
typedef short int			Int16;
typedef long 				Int32;

typedef unsigned char		Byte;
typedef unsigned char 		Uint8;
typedef unsigned short int	Uint16;
typedef unsigned long 		Uint32;

typedef unsigned char* 	String;

/*==================================================
	bool symbol define
==================================================*/
//#define NULL			0
#define ENABLE		1
#define DISABLE		0
#define OPEN			1
#define CLOSE		0
#define START		1
#define STOP 		0
#define ACTIVE		1
#define INACTIVE 	0
#define TRUE  		1
#define FALSE 		0
#define PLUS  		1
#define MINUS 		0
#define ON  			1
#define OFF 			0
#define DONT_CARE8		0xff
#define DONT_CARE16	0xffff

#define RET_CMD_IGNORE 	0
#define RET_CMD_EXECUTED	1

#define B0			(1<<0)
#define B1			(1<<1)
#define B2			(1<<2)
#define B3			(1<<3)
#define B4			(1<<4)
#define B5			(1<<5)
#define B6			(1<<6)
#define B7			(1<<7)

/*==================================================
	Macro define
==================================================*/
#define NOP			_nop_()
#define TESTBIT		_testbit_

#define HIBYTE(w)		(((Uint8*)&w)[0])
#define LOBYTE(w)		(((Uint8*)&w)[1])
#define HIWORD(w)		(((Uint16*)&w)[0])
#define LOWORD(w)		(((Uint16*)&w)[1])

#endif

