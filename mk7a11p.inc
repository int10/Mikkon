; MK7A11P.INC
;	This file contains the definition of registers for
;		MK7A11P microcontroller.

;==========Define Special Register(Define SFR) ==========

INDF		EQU	00H
TMR0     	EQU	01H
PC		EQU	02H
STATUS  	EQU	03H
FSR     	EQU	04H
;;;;;;;int10   datasheep prefer bsr to fsr...
BSR		EQU 04H

PORTA	  	EQU	05H	;I/O Control Register
PORTB		EQU	06H

IRQM		EQU	09H	;IRQ Control Register
IRQF		EQU	0AH

PA_PDM		EQU	0BH	;Other Control Register
PB_PUP		EQU	0CH
PB_PDM		EQU	0DH
PB_POD		EQU	0EH
WAKE_UP		EQU	0FH

;==========Define [STATUS Register] Special Bit===========

C		EQU	0
DC		EQU	1
Z		EQU	2
PD		EQU	3
TO		EQU	4

;========Define [PA Register] Special Bit=========

PA0		EQU	0
PA1		EQU	1
PA2		EQU	2
PA3		EQU	3

;========Define [PB Register] Special Bit=========

PB0		EQU	0
PB1		EQU	1
PB2		EQU	2
PB3		EQU	3
PB4		EQU	4
PB5		EQU	5
PB6		EQU	6
PB7		EQU	7

;==========Define [IRQM Register] Special Bit===========

TM0M		EQU	0
PB0M		EQU	1
INTM		EQU	7

;==========Define [IRQF Register] Special Bit===========

TM0F		EQU	0
PB0F		EQU	1

;========Define [PA_PDM Register] Special Bit=========

DA0		EQU	0
DA1		EQU	1
DA2		EQU	2
DA3		EQU	3

;========Define [PB_PUP Register] Special Bit=========

UB0		EQU	0
UB1		EQU	1
UB2		EQU	2
UB4		EQU	4
UB5		EQU	5
UB6		EQU	6
UB7		EQU	7

;========Define [PB_PDM Register] Special Bit=========

DB0		EQU	0
DB1		EQU	1
DB2		EQU	2
INTE		EQU	6
RTCCE		EQU	7

;========Define [PB_POD Register] Special Bit=========

OB0		EQU	0
OB1		EQU	1
OB2		EQU	2
OB4		EQU	4
OB5		EQU	5
OB6		EQU	6
OB7		EQU	7

;========Define [WAKEUP Register] Special Bit=========

EN0		EQU	0
EN1		EQU	1
EN2		EQU	2
EN3		EQU	3
EN4		EQU	4
EN5		EQU	5
EN6		EQU	6
EN7		EQU	7