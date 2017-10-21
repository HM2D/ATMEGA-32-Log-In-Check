
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _machineState=R4
	.DEF _machineState_msb=R5
	.DEF _enteredCombination=R6
	.DEF _enteredCombination_msb=R7
	.DEF _Col=R8
	.DEF _Col_msb=R9
	.DEF _Row=R10
	.DEF _Row_msb=R11
	.DEF _found=R12
	.DEF _found_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x0:
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x55,0x73
	.DB  0x65,0x72,0x0,0x45,0x6E,0x74,0x65,0x72
	.DB  0x20,0x4E,0x65,0x77,0x20,0x50,0x61,0x73
	.DB  0x73,0x0,0x6C,0x6F,0x67,0x20,0x69,0x6E
	.DB  0x20,0x66,0x69,0x72,0x73,0x74,0x0,0x75
	.DB  0x3A,0x25,0x64,0x20,0x70,0x3A,0x25,0x64
	.DB  0x0,0x65,0x6E,0x74,0x65,0x72,0x20,0x70
	.DB  0x61,0x73,0x73,0x0,0x6E,0x6F,0x20,0x75
	.DB  0x73,0x65,0x72,0x0,0x61,0x63,0x63,0x65
	.DB  0x73,0x73,0x20,0x67,0x72,0x61,0x6E,0x74
	.DB  0x65,0x64,0x0,0x69,0x6E,0x63,0x6F,0x72
	.DB  0x72,0x65,0x63,0x74,0x20,0x70,0x61,0x73
	.DB  0x73,0x77,0x6F,0x72,0x64,0x0
_0x2060060:
	.DB  0x1
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2080003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0B
	.DW  _0xA
	.DW  _0x0*2

	.DW  0x0B
	.DW  _0xA+11
	.DW  _0x0*2

	.DW  0x0F
	.DW  _0xA+22
	.DW  _0x0*2+11

	.DW  0x0D
	.DW  _0xA+37
	.DW  _0x0*2+26

	.DW  0x0B
	.DW  _0xA+50
	.DW  _0x0*2+49

	.DW  0x08
	.DW  _0xA+61
	.DW  _0x0*2+60

	.DW  0x0F
	.DW  _0xA+69
	.DW  _0x0*2+68

	.DW  0x13
	.DW  _0xA+84
	.DW  _0x0*2+83

	.DW  0x01
	.DW  __seed_G103
	.DW  _0x2060060*2

	.DW  0x02
	.DW  __base_y_G104
	.DW  _0x2080003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 7/5/2016
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <string.h>
;#include <stdio.h>
;#include <math.h>
; #include <assert.h>
;#include <stdlib.h>
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
; void ScanRow();
; void ScanCol();
; //void prepend(char* s, const char* t);
; int machineState=0;
; //0 = entering user
; //1 = entering pass
; //2 = userLoggedIn
; //3 = changing pass
; //4 = entering pass again
;        char temp[10];
;        char temp2[10];
;        int enteredCombination=0;
;        int Col=0;
;        int  Row=0;
;        int found =0;
;        int userIndex=0;
;        int userLoggedIn=0;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0037 {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
; 0000 0038 // Place your code here
; 0000 0039 
; 0000 003A }
	RETI
; .FEND
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 003E {
_ext_int1_isr:
; .FSTART _ext_int1_isr
; 0000 003F // Place your code here
; 0000 0040 
; 0000 0041 }
	RETI
; .FEND
;
;void main(void)
; 0000 0044 {
_main:
; .FSTART _main
; 0000 0045 // Declare your local variables here
; 0000 0046         int users[10][10];
; 0000 0047 
; 0000 0048         int keypad[4][4];
; 0000 0049         int combination[4]={0,0,0,0};
; 0000 004A         int counter0=0;
; 0000 004B         int tens=1;
; 0000 004C         int i=0,j=0;
; 0000 004D         for(i=0;i<10;i++){
	SBIW R28,63
	SBIW R28,63
	SBIW R28,63
	SBIW R28,53
	LDI  R24,10
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x3*2)
	LDI  R31,HIGH(_0x3*2)
	CALL __INITLOCB
;	users -> Y+42
;	keypad -> Y+10
;	combination -> Y+2
;	counter0 -> R16,R17
;	tens -> R18,R19
;	i -> R20,R21
;	j -> Y+0
	__GETWRN 16,17,0
	__GETWRN 18,19,1
	__GETWRN 20,21,0
	__GETWRN 20,21,0
_0x5:
	__CPWRN 20,21,10
	BRGE _0x6
; 0000 004E         for(j=0;j<10;j++){
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
_0x8:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRGE _0x9
; 0000 004F         users[i][j]=0;
	CALL SUBOPT_0x0
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
; 0000 0050         }
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0x8
_0x9:
; 0000 0051 
; 0000 0052 
; 0000 0053         }
	__ADDWRN 20,21,1
	RJMP _0x5
_0x6:
; 0000 0054         users[0][0] = 0000; //users username
	LDI  R30,LOW(0)
	STD  Y+42,R30
	STD  Y+42+1,R30
; 0000 0055         users[0][1] = 1111; //users password
	LDI  R30,LOW(1111)
	LDI  R31,HIGH(1111)
	STD  Y+44,R30
	STD  Y+44+1,R31
; 0000 0056         users[1][0] = 1111;
	STD  Y+62,R30
	STD  Y+62+1,R31
; 0000 0057         users[1][1] = 1111;
	MOVW R30,R28
	ADIW R30,62
	ADIW R30,2
	LDI  R26,LOW(1111)
	LDI  R27,HIGH(1111)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0058         users[2][0] = 2222;
	LDI  R30,LOW(2222)
	LDI  R31,HIGH(2222)
	__PUTW1SX 82
; 0000 0059         users[2][1] = 3333;
	MOVW R30,R28
	ADIW R30,42
	ADIW R30,42
	LDI  R26,LOW(3333)
	LDI  R27,HIGH(3333)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 005A 
; 0000 005B         keypad[0][0] = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 005C         keypad[0][1] = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 005D         keypad[0][2] = 9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0000 005E         keypad[0][3] = -1; //changePass
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STD  Y+16,R30
	STD  Y+16+1,R31
; 0000 005F         keypad[1][0] = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	STD  Y+18,R30
	STD  Y+18+1,R31
; 0000 0060         keypad[1][1] = 5;
	MOVW R30,R28
	ADIW R30,20
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0061         keypad[1][2] = 4;
	MOVW R30,R28
	ADIW R30,22
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0062         keypad[1][3] = -4;       //Log Out
	MOVW R30,R28
	ADIW R30,24
	LDI  R26,LOW(65532)
	LDI  R27,HIGH(65532)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0063         keypad[2][0] = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STD  Y+26,R30
	STD  Y+26+1,R31
; 0000 0064         keypad[2][1] = 2;
	MOVW R30,R28
	ADIW R30,28
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0065         keypad[2][2] = 1;
	MOVW R30,R28
	ADIW R30,30
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0066         keypad[2][3] = -99;
	MOVW R30,R28
	ADIW R30,32
	LDI  R26,LOW(65437)
	LDI  R27,HIGH(65437)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0067         keypad[3][0] = -2; //enter
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	STD  Y+34,R30
	STD  Y+34+1,R31
; 0000 0068         keypad[3][1] = 0;
	MOVW R30,R28
	ADIW R30,36
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0069         keypad[3][2] = -3;      //clear
	MOVW R30,R28
	ADIW R30,38
	LDI  R26,LOW(65533)
	LDI  R27,HIGH(65533)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 006A         keypad[3][3] = -99;
	MOVW R30,R28
	ADIW R30,40
	LDI  R26,LOW(65437)
	LDI  R27,HIGH(65437)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 006B // Input/Output Ports initialization
; 0000 006C // Port A initialization
; 0000 006D // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 006E DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 006F // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0070 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0071 
; 0000 0072 // Port B initialization
; 0000 0073 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0074 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0075 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0076 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0077 
; 0000 0078 // Port C initialization
; 0000 0079 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 007A // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 007B PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 007C 
; 0000 007D // Port D initialization
; 0000 007E // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 007F DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0080 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0081 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0082 
; 0000 0083 // Timer/Counter 0 initialization
; 0000 0084 // Clock source: System Clock
; 0000 0085 // Clock value: Timer 0 Stopped
; 0000 0086 // Mode: Normal top=0xFF
; 0000 0087 // OC0 output: Disconnected
; 0000 0088 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0089 TCNT0=0x00;
	OUT  0x32,R30
; 0000 008A OCR0=0x00;
	OUT  0x3C,R30
; 0000 008B 
; 0000 008C // Timer/Counter 1 initialization
; 0000 008D // Clock source: System Clock
; 0000 008E // Clock value: Timer1 Stopped
; 0000 008F // Mode: Normal top=0xFFFF
; 0000 0090 // OC1A output: Disconnected
; 0000 0091 // OC1B output: Disconnected
; 0000 0092 // Noise Canceler: Off
; 0000 0093 // Input Capture on Falling Edge
; 0000 0094 // Timer1 Overflow Interrupt: Off
; 0000 0095 // Input Capture Interrupt: Off
; 0000 0096 // Compare A Match Interrupt: Off
; 0000 0097 // Compare B Match Interrupt: Off
; 0000 0098 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0099 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 009A TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 009B TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 009C ICR1H=0x00;
	OUT  0x27,R30
; 0000 009D ICR1L=0x00;
	OUT  0x26,R30
; 0000 009E OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 009F OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00A0 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00A1 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00A2 
; 0000 00A3 // Timer/Counter 2 initialization
; 0000 00A4 // Clock source: System Clock
; 0000 00A5 // Clock value: Timer2 Stopped
; 0000 00A6 // Mode: Normal top=0xFF
; 0000 00A7 // OC2 output: Disconnected
; 0000 00A8 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00A9 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00AA TCNT2=0x00;
	OUT  0x24,R30
; 0000 00AB OCR2=0x00;
	OUT  0x23,R30
; 0000 00AC 
; 0000 00AD // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00AE TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00AF 
; 0000 00B0 // External Interrupt(s) initialization
; 0000 00B1 // INT0: On
; 0000 00B2 // INT0 Mode: Low level
; 0000 00B3 // INT1: On
; 0000 00B4 // INT1 Mode: Low level
; 0000 00B5 // INT2: Off
; 0000 00B6 GICR|=(1<<INT1) | (1<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 00B7 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00B8 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 00B9 GIFR=(1<<INTF1) | (1<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 00BA 
; 0000 00BB // USART initialization
; 0000 00BC // USART disabled
; 0000 00BD UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 00BE 
; 0000 00BF // Analog Comparator initialization
; 0000 00C0 // Analog Comparator: Off
; 0000 00C1 // The Analog Comparator's positive input is
; 0000 00C2 // connected to the AIN0 pin
; 0000 00C3 // The Analog Comparator's negative input is
; 0000 00C4 // connected to the AIN1 pin
; 0000 00C5 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00C6 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00C7 
; 0000 00C8 // ADC initialization
; 0000 00C9 // ADC disabled
; 0000 00CA ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00CB 
; 0000 00CC // SPI initialization
; 0000 00CD // SPI disabled
; 0000 00CE SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00CF 
; 0000 00D0 // TWI initialization
; 0000 00D1 // TWI disabled
; 0000 00D2 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00D3 
; 0000 00D4 // Alphanumeric LCD initialization
; 0000 00D5 // Connections are specified in the
; 0000 00D6 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00D7 // RS - PORTA Bit 0
; 0000 00D8 // RD - PORTA Bit 1
; 0000 00D9 // EN - PORTA Bit 2
; 0000 00DA // D4 - PORTA Bit 3
; 0000 00DB // D5 - PORTA Bit 4
; 0000 00DC // D6 - PORTA Bit 5
; 0000 00DD // D7 - PORTA Bit 6
; 0000 00DE // Characters/line: 16
; 0000 00DF lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00E0   lcd_gotoxy(0,0);
	CALL SUBOPT_0x2
; 0000 00E1   lcd_puts("Enter User");
	__POINTW2MN _0xA,0
	CALL _lcd_puts
; 0000 00E2 
; 0000 00E3 // Global enable interrupts
; 0000 00E4 #asm("sei")
	sei
; 0000 00E5     DDRC = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 00E6    // PORTC = 0x0F;//enable pull up
; 0000 00E7 while (1)
_0xB:
; 0000 00E8       {
; 0000 00E9       enteredCombination =0;
	CLR  R6
	CLR  R7
; 0000 00EA       // Place your code here
; 0000 00EB 
; 0000 00EC  DDRC=0xf0;
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 00ED 
; 0000 00EE     PORTC=0x0f;    //enable pull up
	LDI  R30,LOW(15)
	OUT  0x15,R30
; 0000 00EF 
; 0000 00F0     while((PORTC&PINC)==0x0f);{
_0xE:
	IN   R30,0x15
	MOV  R26,R30
	IN   R30,0x13
	AND  R30,R26
	CPI  R30,LOW(0xF)
	BREQ _0xE
; 0000 00F1     ScanRow();
	RCALL _ScanRow
; 0000 00F2                                }
; 0000 00F3     DDRC=0x0f;
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 00F4 
; 0000 00F5     PORTC=0xf0;
	LDI  R30,LOW(240)
	OUT  0x15,R30
; 0000 00F6 
; 0000 00F7     while((PORTC&PINC)==0xf0);  {
_0x11:
	IN   R30,0x15
	MOV  R26,R30
	IN   R30,0x13
	AND  R30,R26
	CPI  R30,LOW(0xF0)
	BREQ _0x11
; 0000 00F8     ScanCol();
	RCALL _ScanCol
; 0000 00F9 
; 0000 00FA 
; 0000 00FB     }
; 0000 00FC     //log Out
; 0000 00FD     if(keypad[Row][Col]== -4){
	CALL SUBOPT_0x3
	CALL __GETW1P
	CPI  R30,LOW(0xFFFC)
	LDI  R26,HIGH(0xFFFC)
	CPC  R31,R26
	BRNE _0x14
; 0000 00FE    sprintf(temp,"");
	CALL SUBOPT_0x4
; 0000 00FF    counter0=0;
	__GETWRN 16,17,0
; 0000 0100    machineState=0;
	CLR  R4
	CLR  R5
; 0000 0101    lcd_clear();
	CALL SUBOPT_0x5
; 0000 0102    lcd_gotoxy(0,0);
; 0000 0103    lcd_puts("Enter User");
	__POINTW2MN _0xA,11
	CALL _lcd_puts
; 0000 0104    continue;
	RJMP _0xB
; 0000 0105 
; 0000 0106     }
; 0000 0107     //Clear
; 0000 0108     if(keypad[Row][Col]== -3){
_0x14:
	CALL SUBOPT_0x3
	CALL __GETW1P
	CPI  R30,LOW(0xFFFD)
	LDI  R26,HIGH(0xFFFD)
	CPC  R31,R26
	BRNE _0x15
; 0000 0109     counter0=0;
	__GETWRN 16,17,0
; 0000 010A     sprintf(temp,"");
	CALL SUBOPT_0x4
; 0000 010B     lcd_clear();
	CALL _lcd_clear
; 0000 010C 
; 0000 010D     continue;
	RJMP _0xB
; 0000 010E 
; 0000 010F 
; 0000 0110     }
; 0000 0111     //ChangePass
; 0000 0112     if(keypad[Row][Col] == -1){
_0x15:
	CALL SUBOPT_0x3
	CALL __GETW1P
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x16
; 0000 0113 
; 0000 0114     if(machineState == 2){
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x17
; 0000 0115 
; 0000 0116     lcd_clear();
	CALL SUBOPT_0x5
; 0000 0117     lcd_gotoxy(0,0);
; 0000 0118     lcd_puts("Enter New Pass");
	__POINTW2MN _0xA,22
	CALL _lcd_puts
; 0000 0119     machineState++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 011A     counter0=0;
	RJMP _0x4E
; 0000 011B     sprintf(temp,"");
; 0000 011C 
; 0000 011D 
; 0000 011E 
; 0000 011F     }else if(machineState <2) {
_0x17:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x19
; 0000 0120     lcd_clear();
	CALL SUBOPT_0x5
; 0000 0121     lcd_gotoxy(0,0);
; 0000 0122     lcd_puts("log in first");
	__POINTW2MN _0xA,37
	CALL _lcd_puts
; 0000 0123     machineState=0;
	CLR  R4
	CLR  R5
; 0000 0124     counter0=0;
_0x4E:
	__GETWRN 16,17,0
; 0000 0125     sprintf(temp,"");
	CALL SUBOPT_0x4
; 0000 0126 
; 0000 0127 
; 0000 0128     }
; 0000 0129 
; 0000 012A     continue;
_0x19:
	RJMP _0xB
; 0000 012B 
; 0000 012C 
; 0000 012D     }
; 0000 012E     //submit new password
; 0000 012F      if((keypad[Row][Col]== -2) && (machineState==3) && (counter0 == 4)){
_0x16:
	CALL SUBOPT_0x3
	CALL SUBOPT_0x6
	BRNE _0x1B
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x1B
	CALL SUBOPT_0x7
	BREQ _0x1C
_0x1B:
	RJMP _0x1A
_0x1C:
; 0000 0130 
; 0000 0131       for(i=0;i<=3;i++){
	__GETWRN 20,21,0
_0x1E:
	__CPWRN 20,21,4
	BRGE _0x1F
; 0000 0132         for(j=3;j>i;j--){
	CALL SUBOPT_0x8
_0x21:
	CALL SUBOPT_0x9
	BRGE _0x22
; 0000 0133             tens = 10*tens;
	CALL SUBOPT_0xA
; 0000 0134         }
	CALL SUBOPT_0xB
	RJMP _0x21
_0x22:
; 0000 0135         enteredCombination += tens* combination[i];
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 0136 
; 0000 0137         tens = 1;
; 0000 0138     }
	__ADDWRN 20,21,1
	RJMP _0x1E
_0x1F:
; 0000 0139 
; 0000 013A      users[userIndex][1] = enteredCombination;
	CALL SUBOPT_0xE
	MOVW R26,R28
	ADIW R26,42
	ADD  R30,R26
	ADC  R31,R27
	__PUTWZR 6,7,2
; 0000 013B      lcd_clear();
	CALL SUBOPT_0x5
; 0000 013C      lcd_gotoxy(0,0);
; 0000 013D      sprintf(temp,"u:%d p:%d",users[userIndex][0],users[userIndex][1]);
	LDI  R30,LOW(_temp)
	LDI  R31,HIGH(_temp)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,39
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xE
	MOVW R26,R28
	ADIW R26,46
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0xF
	CALL SUBOPT_0xE
	MOVW R26,R28
	ADIW R26,50
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	CALL SUBOPT_0xF
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 013E      lcd_puts(temp);
	LDI  R26,LOW(_temp)
	LDI  R27,HIGH(_temp)
	CALL _lcd_puts
; 0000 013F     counter0 = 0;
	__GETWRN 16,17,0
; 0000 0140     machineState=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 0141     sprintf(temp,"");
	CALL SUBOPT_0x4
; 0000 0142 
; 0000 0143     continue;
	RJMP _0xB
; 0000 0144 
; 0000 0145     }
; 0000 0146     //check users
; 0000 0147      if((keypad[Row][Col]== -2) && (machineState==0) && (counter0 == 4)){
_0x1A:
	CALL SUBOPT_0x3
	CALL SUBOPT_0x6
	BRNE _0x24
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BRNE _0x24
	CALL SUBOPT_0x7
	BREQ _0x25
_0x24:
	RJMP _0x23
_0x25:
; 0000 0148     lcd_clear();
	CALL SUBOPT_0x5
; 0000 0149     lcd_gotoxy(0,0);
; 0000 014A 
; 0000 014B     for(i=0;i<=3;i++){
	__GETWRN 20,21,0
_0x27:
	__CPWRN 20,21,4
	BRGE _0x28
; 0000 014C         for(j=3;j>i;j--){
	CALL SUBOPT_0x8
_0x2A:
	CALL SUBOPT_0x9
	BRGE _0x2B
; 0000 014D             tens = 10*tens;
	CALL SUBOPT_0xA
; 0000 014E         }
	CALL SUBOPT_0xB
	RJMP _0x2A
_0x2B:
; 0000 014F         enteredCombination += tens* combination[i];
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 0150 
; 0000 0151         tens = 1;
; 0000 0152     }
	__ADDWRN 20,21,1
	RJMP _0x27
_0x28:
; 0000 0153     lcd_clear();
	CALL SUBOPT_0x5
; 0000 0154     lcd_gotoxy(0,0);
; 0000 0155    // sprintf(temp,"%d",enteredCombination);
; 0000 0156     //lcd_puts(temp);
; 0000 0157     //delay_ms(500);
; 0000 0158     for(i=0;i<10;i++){
	__GETWRN 20,21,0
_0x2D:
	__CPWRN 20,21,10
	BRGE _0x2E
; 0000 0159       if(users[i][0] == enteredCombination){
	CALL SUBOPT_0x0
	CALL __GETW1P
	CP   R6,R30
	CPC  R7,R31
	BRNE _0x2F
; 0000 015A 
; 0000 015B       found = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 015C       machineState++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 015D       counter0=0;
	__GETWRN 16,17,0
; 0000 015E       userIndex = i;
	__PUTWMRN _userIndex,0,20,21
; 0000 015F       sprintf(temp,"");
	CALL SUBOPT_0x4
; 0000 0160     lcd_clear();
	CALL SUBOPT_0x5
; 0000 0161     lcd_gotoxy(0,0);
; 0000 0162     lcd_puts("enter pass");
	__POINTW2MN _0xA,50
	CALL _lcd_puts
; 0000 0163     break;
	RJMP _0x2E
; 0000 0164 
; 0000 0165       }
; 0000 0166     }
_0x2F:
	__ADDWRN 20,21,1
	RJMP _0x2D
_0x2E:
; 0000 0167     if(found == 0){
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x30
; 0000 0168       sprintf(temp,"");
	CALL SUBOPT_0x4
; 0000 0169       lcd_clear();
	CALL SUBOPT_0x5
; 0000 016A       lcd_gotoxy(0,0);
; 0000 016B       lcd_puts("no user");
	__POINTW2MN _0xA,61
	CALL _lcd_puts
; 0000 016C       counter0=0;
	__GETWRN 16,17,0
; 0000 016D 
; 0000 016E     }
; 0000 016F     found =0;
_0x30:
	CLR  R12
	CLR  R13
; 0000 0170     }
; 0000 0171     //check password
; 0000 0172      if((keypad[Row][Col]== -2) && (machineState==1) && (counter0 == 4)){
_0x23:
	CALL SUBOPT_0x3
	CALL SUBOPT_0x6
	BRNE _0x32
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x32
	CALL SUBOPT_0x7
	BREQ _0x33
_0x32:
	RJMP _0x31
_0x33:
; 0000 0173     lcd_clear();
	CALL SUBOPT_0x5
; 0000 0174     lcd_gotoxy(0,0);
; 0000 0175 
; 0000 0176     for(i=0;i<=3;i++){
	__GETWRN 20,21,0
_0x35:
	__CPWRN 20,21,4
	BRGE _0x36
; 0000 0177         for(j=3;j>i;j--){
	CALL SUBOPT_0x8
_0x38:
	CALL SUBOPT_0x9
	BRGE _0x39
; 0000 0178             tens = 10*tens;
	CALL SUBOPT_0xA
; 0000 0179         }
	CALL SUBOPT_0xB
	RJMP _0x38
_0x39:
; 0000 017A         enteredCombination += tens* combination[i];
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 017B 
; 0000 017C         tens = 1;
; 0000 017D     }
	__ADDWRN 20,21,1
	RJMP _0x35
_0x36:
; 0000 017E     if(users[userIndex][1] == enteredCombination){
	CALL SUBOPT_0xE
	MOVW R26,R28
	ADIW R26,42
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	CALL __GETW1P
	CP   R6,R30
	CPC  R7,R31
	BRNE _0x3A
; 0000 017F 
; 0000 0180     lcd_clear();
	CALL SUBOPT_0x5
; 0000 0181     lcd_gotoxy(0,0);
; 0000 0182     lcd_puts("access granted");
	__POINTW2MN _0xA,69
	CALL _lcd_puts
; 0000 0183     machineState++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0184 
; 0000 0185     }else{
	RJMP _0x3B
_0x3A:
; 0000 0186     lcd_clear();
	CALL SUBOPT_0x5
; 0000 0187     lcd_gotoxy(0,0);
; 0000 0188     lcd_puts("incorrect password");
	__POINTW2MN _0xA,84
	CALL _lcd_puts
; 0000 0189 
; 0000 018A 
; 0000 018B     }
_0x3B:
; 0000 018C     sprintf(temp,"");
	CALL SUBOPT_0x4
; 0000 018D     counter0=0;
	__GETWRN 16,17,0
; 0000 018E     continue;
	RJMP _0xB
; 0000 018F     // sprintf(temp,"%d",enteredCombination);
; 0000 0190     //lcd_puts(temp);
; 0000 0191     //delay_ms(500);
; 0000 0192 
; 0000 0193 
; 0000 0194     }
; 0000 0195 
; 0000 0196 
; 0000 0197 
; 0000 0198 
; 0000 0199    // combination += pow(10,(float)counter0)*keypad[Row][Col];
; 0000 019A     if(keypad[Row][Col] != -2 && counter0<4){
_0x31:
	CALL SUBOPT_0x3
	CALL SUBOPT_0x6
	BREQ _0x3D
	__CPWRN 16,17,4
	BRLT _0x3E
_0x3D:
	RJMP _0x3C
_0x3E:
; 0000 019B 
; 0000 019C     lcd_gotoxy(0,0);
	CALL SUBOPT_0x2
; 0000 019D     lcd_clear();
	CALL _lcd_clear
; 0000 019E     combination[counter0]= keypad[Row][Col];
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,2
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	CALL SUBOPT_0x3
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 019F     sprintf(temp2,"%d",combination[counter0++]);
	LDI  R30,LOW(_temp2)
	LDI  R31,HIGH(_temp2)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,46
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	__ADDWRN 16,17,1
	MOVW R26,R28
	ADIW R26,6
	CALL SUBOPT_0x1
	CALL SUBOPT_0xF
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 01A0     strcat(temp,temp2);
	LDI  R30,LOW(_temp)
	LDI  R31,HIGH(_temp)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_temp2)
	LDI  R27,HIGH(_temp2)
	CALL _strcat
; 0000 01A1 
; 0000 01A2    // sprintf(temp,"%d%d%d%d t:",combination[3],combination[2],combination[1],combination[0]);
; 0000 01A3       //prepend(temp2,temp);
; 0000 01A4     //sprintf(temp,"%d",combination);
; 0000 01A5 
; 0000 01A6     lcd_puts(temp);
	LDI  R26,LOW(_temp)
	LDI  R27,HIGH(_temp)
	CALL _lcd_puts
; 0000 01A7     //check user exist
; 0000 01A8     }
; 0000 01A9 
; 0000 01AA     //counter0++;
; 0000 01AB 
; 0000 01AC     delay_ms(500);
_0x3C:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 01AD      }
	RJMP _0xB
; 0000 01AE }
_0x3F:
	RJMP _0x3F
; .FEND

	.DSEG
_0xA:
	.BYTE 0x67
;void ScanRow()
; 0000 01B0 
; 0000 01B1 {

	.CSEG
_ScanRow:
; .FSTART _ScanRow
; 0000 01B2 
; 0000 01B3     switch(PINC & 0x0f)
	IN   R30,0x13
	ANDI R30,LOW(0xF)
; 0000 01B4 
; 0000 01B5     {
; 0000 01B6 
; 0000 01B7        case 0x07:Row=3;break;
	CPI  R30,LOW(0x7)
	BRNE _0x43
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R10,R30
	RJMP _0x42
; 0000 01B8 
; 0000 01B9        case 0x0b:Row=2;break;
_0x43:
	CPI  R30,LOW(0xB)
	BRNE _0x44
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R10,R30
	RJMP _0x42
; 0000 01BA 
; 0000 01BB        case 0x0d:Row=1;break;
_0x44:
	CPI  R30,LOW(0xD)
	BRNE _0x45
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
	RJMP _0x42
; 0000 01BC 
; 0000 01BD        case 0x0e:Row=0;break;
_0x45:
	CPI  R30,LOW(0xE)
	BRNE _0x42
	CLR  R10
	CLR  R11
; 0000 01BE 
; 0000 01BF     }
_0x42:
; 0000 01C0 
; 0000 01C1 }
	RET
; .FEND
;
;
;
;void ScanCol()
; 0000 01C6 
; 0000 01C7 {
_ScanCol:
; .FSTART _ScanCol
; 0000 01C8 
; 0000 01C9     switch(PINC & 0xf0)
	IN   R30,0x13
	ANDI R30,LOW(0xF0)
; 0000 01CA 
; 0000 01CB     {
; 0000 01CC 
; 0000 01CD                 case 0x70:Col=3;break;
	CPI  R30,LOW(0x70)
	BRNE _0x4A
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R8,R30
	RJMP _0x49
; 0000 01CE 
; 0000 01CF                 case 0xb0:Col=2;break;
_0x4A:
	CPI  R30,LOW(0xB0)
	BRNE _0x4B
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R8,R30
	RJMP _0x49
; 0000 01D0 
; 0000 01D1                 case 0xd0:Col=1;break;
_0x4B:
	CPI  R30,LOW(0xD0)
	BRNE _0x4C
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
	RJMP _0x49
; 0000 01D2 
; 0000 01D3                 case 0xe0:Col=0;break;
_0x4C:
	CPI  R30,LOW(0xE0)
	BRNE _0x49
	CLR  R8
	CLR  R9
; 0000 01D4 
; 0000 01D5             }
_0x49:
; 0000 01D6 
; 0000 01D7 }
	RET
; .FEND

	.CSEG
_strcat:
; .FSTART _strcat
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcat0:
    ld   r22,x+
    tst  r22
    brne strcat0
    sbiw r26,1
strcat1:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcat1
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x10
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x10
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x11
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x12
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x10
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x10
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x12
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x10
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x12
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x15
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x15
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0002:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G104:
; .FSTART __lcd_write_nibble_G104
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2080004
	SBI  0x1B,3
	RJMP _0x2080005
_0x2080004:
	CBI  0x1B,3
_0x2080005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2080006
	SBI  0x1B,4
	RJMP _0x2080007
_0x2080006:
	CBI  0x1B,4
_0x2080007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2080008
	SBI  0x1B,5
	RJMP _0x2080009
_0x2080008:
	CBI  0x1B,5
_0x2080009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x208000A
	SBI  0x1B,6
	RJMP _0x208000B
_0x208000A:
	CBI  0x1B,6
_0x208000B:
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x20C0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G104
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G104
	__DELAY_USB 133
	RJMP _0x20C0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G104)
	SBCI R31,HIGH(-__base_y_G104)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x16
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x16
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2080011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2080010
_0x2080011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2080013
	RJMP _0x20C0001
_0x2080013:
_0x2080010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x20C0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2080014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2080016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2080014
_0x2080016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x1A,3
	SBI  0x1A,4
	SBI  0x1A,5
	SBI  0x1A,6
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G104,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G104,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x17
	CALL SUBOPT_0x17
	CALL SUBOPT_0x17
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G104
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.DSEG
_temp:
	.BYTE 0xA
_temp2:
	.BYTE 0xA
_userIndex:
	.BYTE 0x2
__seed_G103:
	.BYTE 0x4
__base_y_G104:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	__MULBNWRU 20,21,20
	MOVW R26,R28
	ADIW R26,42
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x3:
	MOVW R30,R10
	CALL __LSLW3
	MOVW R26,R28
	ADIW R26,10
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R8
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(_temp)
	LDI  R31,HIGH(_temp)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,10
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x5:
	CALL _lcd_clear
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	CALL __GETW1P
	CPI  R30,LOW(0xFFFE)
	LDI  R26,HIGH(0xFFFE)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R16
	CPC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LD   R26,Y
	LDD  R27,Y+1
	CP   R20,R26
	CPC  R21,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	MOVW R30,R18
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	MOVW R30,R20
	MOVW R26,R28
	ADIW R26,2
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xD:
	CALL __GETW1P
	MOVW R26,R18
	CALL __MULW12
	__ADDWRR 6,7,30,31
	__GETWRN 18,19,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xE:
	LDS  R26,_userIndex
	LDS  R27,_userIndex+1
	LDI  R30,LOW(20)
	CALL __MULB1W2U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	CALL __GETW1P
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G104
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
