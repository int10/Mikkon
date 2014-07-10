; MK7A21P.INC
;	This file contains the definition of registers for
;		MK7A21P microcontroller.

;==========Define Special Register(Define SFR) ==========

INDF		EQU	00H
PCL     	EQU	01H
PCH		EQU	02H
STATUS  	EQU	03H
FSR     	EQU	04H

PA_DIR  	EQU	05H	;I/O Control Register
PA_DAT      	EQU	06H
PB_DIR		EQU	07H
PB_DAT		EQU	08H
PC_DIR		EQU	09H
PC_DAT		EQU	0AH

TM1_CTL1	EQU	13H	;TM1:16-BIT TIMER & Capture
TM1_CTL2	EQU	1FH
CLR_CNT		EQU	21H
TM1L_LA		EQU	14H
TM1H_LA		EQU	15H
TM1L_CNT	EQU	16H
TM1H_CNT	EQU	17H

TM2_CTL1	EQU	18H	;TM2:8-BIT PWM(period)&Timer
TM2_CTL2	EQU	19H
TM2_LA		EQU	1AH
TM2_CNT		EQU	1CH

TM3_CTL		EQU	1EH	;TM3:8-BIT PWM(Duty)&Timer
TM3_LA		EQU	20H
TM3_CNT		EQU	22H

IRQM		EQU	25H	;IRQ Control Register
IRQF		EQU	26H

AD_CTL1		EQU	29H	;ADC Control Register
AD_CTL2		EQU	2AH
AD_CTL3		EQU	2BH
AD_DAT		EQU	2DH

PA_PLU		EQU	31H	;Other Control Register
PB_PLU		EQU	33H
PC_PLU		EQU	35H
PA_INTE		EQU	3AH
WDT_CTL		EQU	3DH
TAB_BNK		EQU	3EH
SYS_CTL		EQU	3FH

;==========Define [STATUS Register] Special Bit===========

C		EQU	0
DC		EQU	1
Z		EQU	2
PD		EQU	3
TO		EQU	4

;==========Define [TM1_CTL1 Register] Special Bit==========

PRE0		EQU	0
PRE1		EQU	1
PRE2		EQU	2
EDGE		EQU	3
SUR0		EQU	4
SUR1		EQU	5
WR_CNT		EQU	6
TM1_EN		EQU	7

;==========Define [TM1_CTL2 Register] Special Bit=========

E_CLR		EQU	7

;==========Define [TM2_CTL1 Register] Special Bit==========

PRE0		EQU	0
PRE1		EQU	1
PRE2		EQU	2
EDGE		EQU	3
SUR0		EQU	4
SUR1		EQU	5
WR_CNT		EQU	6
TM2_EN		EQU	7

;----------Define [TM2_CTL2 Register] Special Bit---------

POS0		EQU	0
POS1		EQU	1
POS2		EQU	2
POS3		EQU	3
TO_E		EQU	5
PWM_OS		EQU	6
MOD		EQU	7

;==========Define [TM3_CTL Register] Special Bit=========

PRE0		EQU	0
PRE1		EQU	1
PRE2		EQU	2
EDGE		EQU	3
SUR0		EQU	4
SUR1		EQU	5
WR_CNT		EQU	6
TM3_EN		EQU	7

;==========Define [IRQM Register] Special Bit===========

TM1M		EQU	1
TM2M		EQU	2
TM3M		EQU	3
PAM		EQU	4
ADCM		EQU	6
INTM		EQU	7

;==========Define [IRQF Register] Special Bit===========

TM1F		EQU	1
TM2F		EQU	2
TM3F		EQU	3
PAF		EQU	4
ADCF		EQU	6

;=========Define [AD_CTL1 Register] Special Bit=========

CHSEL0		EQU	0
CHSEL1		EQU	1
MODE		EQU	5
EN		EQU	7

;---------Define [AD_CTL2 Register] Special Bit---------

CKSEL0		EQU	0
CKSEL1		EQU	1
RSUT		EQU	7

;---------Define [AD_CTL3 Register] Special Bit---------

PBSEL0		EQU	0
PBSEL1		EQU	1
PBSEL2		EQU	2

;========Define [PA_PLU Register] Special Bit=========

UA0		EQU	0
UA1		EQU	1
UA2		EQU	2
UA3		EQU	3
UA4		EQU	4
UA5		EQU	5
UA6		EQU	6
UA7		EQU	7

;========Define [PB_PLU Register] Special Bit=========

UB0		EQU	0
UB1		EQU	1
UB2		EQU	2
UB3		EQU	3

;========Define [PC_PLU Register] Special Bit=========

UC0		EQU	0
UC2		EQU	2
UC3		EQU	3

;========Define [PA_INTE Register] Special Bit=========

EN0		EQU	0
EN1		EQU	1
EN2		EQU	2
EN3		EQU	3
EN4		EQU	4
EN5		EQU	5
EN6		EQU	6
EN7		EQU	7

;========Define [WDT_CTL Register] Special Bit=========

PRE0		EQU	0
PRE1		EQU	1
PRE2		EQU	2
WDTEN		EQU	7

;========Define [TAB_BNK Register] Special Bit=========

BNK0		EQU	0
BNK1		EQU	1
BNK2		EQU	2

;========Define [SYS_CTL Register] Special Bit=========

STP0		EQU	0
STP1		EQU	1
CLKS		EQU	7

;;;;;;;;;;;;;int10add
;========Define [PA Register] Special Bit=========

PA0		EQU	0
PA1		EQU	1
PA2		EQU	2
PA3		EQU	3
PA4		EQU	4
PA5		EQU	5
PA6		EQU	6
PA7		EQU	7

;========Define [PB Register] Special Bit=========

PB0		EQU	0
PB1		EQU	1
PB2		EQU	2
PB3		EQU	3
PB4		EQU	4
PB5		EQU	5
PB6		EQU	6
PB7		EQU	7

;========Define [PB Register] Special Bit=========

PC0		EQU	0
PC1		EQU	1
PC2		EQU	2
PC3		EQU	3
PC4		EQU	4
PC5		EQU	5
PC6		EQU	6
PC7		EQU	7


