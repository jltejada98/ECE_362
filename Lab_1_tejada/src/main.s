.syntax unified
.cpu cortex-m0
.fpu softvfp
.thumb

/******************************************************************************

Arithmetic operations

Exercise 1
Description:
    R0, R1, R2, and R3 will be initialized with values. Fill in the provided
    subroutine body with assembly language instructions to set the value in R0
    to be (R0 * R1) + R2 - R3. Don't change any registers other than R0 - R3 to
    accomplish this.

******************************************************************************/
.global codeSegment1
codeSegment1:
    /*Student code goes here*/
	MULS R0,R1
	ADDS R0,R2
	SUBS R0,R3


    /*End of student code*/
    bx lr

/******************************************************************************
Exercise 2
Description:
    R0, R1, R2, and R3 will be initialized with values. Fill in the provided
    subroutine body with assembly language instructions to set the value in R0
    to be ((-R0) * (R3 + R2)) - R1. Don't change any registers other than
    R0 - R3 to accomplish this.

******************************************************************************/
.global codeSegment2
codeSegment2:
    /*Student code goes here*/
	ADDS R3, R2
	RSBS R0, R0, #0
	MULS R0, R3
	SUBS R0, R1
    /*End of student code*/
    bx lr

/******************************************************************************
Exercise 3
Description:
    R0, R1, R2, and R3 will be initialized with values. Fill in the provided
    subroutine body with assembly language instructions to set the value in
    R0 to be R3 - R2 - R1 - R0. Don't change any registers other than
    R0 - R3 to accomplish this.

******************************************************************************/
.global codeSegment3
codeSegment3:
    /*Student code goes here*/
	SUBS R3, R2
	SUBS R3, R1
	SUBS R3, R0
	MOVS R0, R3

    /*End of student code*/
    bx lr

/******************************************************************************

Logical operations
Exercise 4
Description:
    R0, R1, R2, and R3 will be initialized with values. Fill in the provided
    subroutine body with assembly language instructions to set the value in R0
    to be (R0 | R1) & (R2 ^ R3). Don't change any registers other than R0 - R3 to
    accomplish this.

******************************************************************************/
.global codeSegment4
codeSegment4:
    /*Student code goes here*/
	ORRS R0, R1
	EORS R2, R3
	ANDS R0, R2

    /*End of student code*/
    bx lr

/******************************************************************************

Exercise 5
Description:
    R0, R1, R2, and R3 will be initialized with values. Fill in the provided
    subroutine body with assembly language instructions to set the value in R0
    to be (R0 << R3) | (R2 >> R1).
    Don't change any registers other than R0 - R3 to accomplish this.

******************************************************************************/
.global codeSegment5
codeSegment5:
    /*Student code goes here*/
	ASRS R2, R1
	LSLS R0, R3
	ORRS R0, R2

    /*End of student code*/
    bx lr

.equ Data1, 0x5
/******************************************************************************

Immediate load operations
Exercise 6
Description:
    R0, R1, R2, and R3 are to be initialized to values specified. R0 to Data1,
    R1 to 255 (base 10), R2 to 510 (base 10), R3 to 0

******************************************************************************/
.global codeSegment6
codeSegment6:
    /*Student code goes here*/
    MOVS R0,Data1
	MOVS R1,#255
	LDR R2,=0x000001fe
	MOVS R3,#0


    /*End of student code*/
    bx lr

//=====================================================================
// Put all of the .equ statements for codeSegment7 below:
//=====================================================================
.equ	RCC,    	0x40021000
.equ 	AHBENR, 	0x14
.equ 	GPIOCEN,	0x00080000
.equ 	GPIOC,  	0x48000800
.equ 	MODER,  	0x00
.equ 	ODR,    	0x14
.equ 	PIN8MOD,	0x00010000
.equ 	PIN8,   	0x00000100
//=====================================================================
// Fill in codeSegment7
//=====================================================================
.global codeSegment7
codeSegment7:
    // Student code goes here
	LDR R2, =RCC
	LDR R3, =AHBENR
	LDR R1, =GPIOCEN
	LDR R0, [R2, R3]
	ORRS R0, R1
	STR R0, [R2, R3]


	LDR R2, =GPIOC
	LDR R3, =MODER
	LDR R1, =PIN8MOD
	LDR R0, [R2,R3]
	ORRS R0,R1
	STR R0, [R2,R3]

	LDR R2, =GPIOC
	LDR R3, =ODR
	LDR R1, =PIN8
	LDR R0, [R2,R3]

	LDR R4, =PIN8
	ORRS R0, R4
	STR R0, [R2, R3]

loop_inf:
	BL delay
	EORS R0, R4
	STR R0, [R2,R3]
	B loop_inf

delay:
	LDR R1,=6000000

delay_loop:
	SUBS R1, R1, #1
	BNE delay_loop




    // End of student code
    bx lr

