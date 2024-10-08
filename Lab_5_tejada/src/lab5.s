.syntax unified
.cpu cortex-m0
.fpu softvfp
.thumb

//=============================================================================
// ECE 362 Lab Experiment 5
// Timers
//
//=============================================================================

.equ  RCC,      0x40021000
.equ  APB1ENR,  0x1C
.equ  AHBENR,   0x14
.equ  TIM6EN,	0x10
.equ  GPIOCEN,  0x00080000
.equ  GPIOBEN,  0x00040000
.equ  GPIOAEN,  0x00020000
.equ  GPIOC,    0x48000800
.equ  GPIOB,    0x48000400
.equ  GPIOA,    0x48000000
.equ  MODER,    0x00
.equ  PUPDR,    0x0c
.equ  IDR,      0x10
.equ  ODR,      0x14
.equ  PC0,      0x01
.equ  PC1,      0x04
.equ  PC2,      0x10
.equ  PC3,      0x40
.equ  PC8,      0x10000
.equ  PIN8,     0x00000100 //Wrong value!!!

// NVIC control registers...
.equ NVIC,		0xe000e000
.equ ISER, 		0x100
.equ ICER, 		0x180
.equ ISPR, 		0x200
.equ ICPR, 		0x280

// TIM6 control registers
.equ  TIM6, 	0x40001000
.equ  CR1,		0x00
.equ  DIER,		0x0C
.equ  PSC,		0x28
.equ  ARR,		0x2C
.equ  TIM6_DAC_IRQn, 17
.equ  SR,		0x10

//Student defined statments
.equ PSC_Val, 47999
.equ ARR_Val, 0
//Values to enable pull down resistance on PA4-7
.equ PD_PA4, 0x200
.equ PD_PA5, 0x800
.equ PD_PA6, 0x2000
.equ PD_PA7, 0x8000

.equ PD_PA_all, 0xAA00

//=======================================================
// 6.1: Configure timer 6
//=======================================================
.global init_TIM6
init_TIM6:
	PUSH {LR}
	//Enable TIM6 clock//
	LDR R0, =RCC
	LDR R1, [R0, #APB1ENR] //Load Location for Timers
	LDR R2, =TIM6EN //Value to enable bit 5, TIM6EN
	ORRS R1, R2
	STR R1, [R0, #APB1ENR]

	//Set the PSC and ARR values for update 1ms
	LDR R0, =TIM6
	LDR R1, =ARR_Val
	STR R1, [R0, #ARR] //Store ARR value
	LDR R1, =PSC_Val
	STR R1, [R0, #PSC] //Store PSC values

	//Enable UIE in the TIMER 6 DIER register
	LDR R1, [R0, #DIER]
	MOVS R2, #1
	ORRS R1, R2
	STR R1, [R0, #DIER]

	//Counter enable bit (Not in instructions)
	LDR R1, [R0, #CR1]
	MOVS R2, #1
	ORRS R1, R2
	STR R1, [R0, #CR1]

	//Enable TIM6 interrupt in NVIC's ISER register.
	LDR R0, =NVIC
	LDR R1, =ISER
	LDR R2, =(1<<TIM6_DAC_IRQn)
	STR R2, [R0, R1]

	//bx lr // Student may remove this instruction.

	POP {PC}


//=======================================================
// 6.2: Confiure GPIO
//=======================================================
.global init_GPIO
init_GPIO:
	PUSH {R4-R6,LR}
	//Enable clock to Port C and Port A. (Seems correct)
	LDR R0, =RCC
	LDR R1, [R0, #AHBENR]
	LDR R2, =GPIOCEN
	LDR R3, =GPIOAEN
	ORRS R2, R3
	ORRS R1, R2
	STR R1, [R0, #AHBENR]

	//Set PC0, PC1, PC2, PC3 and PC8 as outputs.
	LDR R0, =GPIOC
	LDR R1, [R0, #MODER] //Load Moder Registers of port C
	LDR R2, =PC0 //Load Value to Enable pin 0 of port C
	LDR R3, =PC1 //Load Value to Enable pin 1 of port C
	LDR R4, =PC2 //Load Value to Enable pin 2 of port C
	LDR R5, =PC3 //Load Value to Enable pin 3 of port C
	LDR R6, =PC8 //Load Value to Enable pin 8 of port C
	ORRS R2, R3
	ORRS R2, R4
	ORRS R2, R5
	ORRS R2, R6  //OR all port values to enable all ports
	ORRS R1, R2  //OR with MODER registers of port C
	STR R1, [R0, #MODER] //Store new bits


	//Set PA0, PA1, PA2 and PA3 as outputs. (Should I use the same values as Port C?
	LDR R0, =GPIOA
	LDR R1, [R0, #MODER] //Load Moder Registers of port A
	LDR R2, =PC0 //Load Value to Enable pin 0 of port A
	LDR R3, =PC1 //Load Value to Enable pin 1 of port A
	LDR R4, =PC2 //Load Value to Enable pin 2 of port A
	LDR R5, =PC3 //Load Value to Enable pin 3 of port A
	ORRS R2, R3
	ORRS R2, R4
	ORRS R2, R5 //OR all port values to enable all ports
	ORRS R1, R2 //OR with MODER registers of port A
	STR R1, [R0, #MODER] //Store new bits


	//Set up a pull down (10: Pull-down) resistance on pins PA4, PA5, PA6 and PA7.
	LDR R0,=GPIOA
	LDR R1, [R0, #PUPDR]
	LDR R2, =PD_PA4 //Load value for Pull down resistance on PA4
	LDR R3, =PD_PA5 //Load value for Pull down resistance on PA5
	LDR R4, =PD_PA6 //Load value for Pull down resistance on PA6
	LDR R5, =PD_PA7 //Load value for Pull down resistance on PA4
	ORRS R2, R3
	ORRS R2, R4
	ORRS R2, R5
	ORRS R1, R2	//OR with PUPDR registers of port A
	STR R1, [R0, #PUPDR] //Store new bits

	//bx lr // Student may remove this instruction.

	POP {R4-R6,PC}

//=======================================================
// 6.3 Blink blue LED using Timer 6 interrupt
// Write your interrupt service routine below.
//=======================================================
.type TIM6_DAC_IRQHandler, %function
.global TIM6_DAC_IRQHandler
TIM6_DAC_IRQHandler:
	PUSH {R4-R5, LR}

	//START 6.3

	//Acknowledge the interrupt
	LDR R0, =TIM6
    LDR R1, [R0, #SR]
   	MOVS R2, #1
   	BICS R1, R2
   	STR R1,[R0, #SR]

	//Increment a global variable 'tick'.
	LDR R0, =tick
	LDR R1, [R0]
	ADDS R1, #1
	STR R1, [R0]

	//Check if 'tick' is 1000.
	LDR R2, =1000
	CMP R1, R2
	BNE endxx

	//If so, toggle (hint: XOR) bit 8 of GPIOC's ODR and set 'tick' to 0.
	LDR R2, =GPIOC
	LDR R0, =tick
	LDR R3, [R2, #ODR] //Load GPIOC ODR
	LDR R4, =0x100 //Select bit 8
	EORS R3, R4 //Toggle bit 8
	STR R3, [R2, #ODR] //Store Value back into GPIOC ODR
	MOVS R1, #0 //Set tick to 0
	STR R1, [R0] //Store tick to 0

	endxx:

	//END 6.3

	// Update the selected column.
	LDR R0, =col
	LDR R1, [R0] //Value of Col
	ADDS R1, #1
	MOVS R2, #3
	ANDS R1, R2
	LDR R3, =GPIOA
	MOVS R4, #1
	LSLS R4, R1
	STR R4, [R3, #ODR]

	// index is the starting index of the four history variables
    // that represent the buttons in the selected column.
	MOVS R2, R1
	LSLS R2, #2 //Index

	// Left shift all of the history variables.
	// read history[index], shift left, store it back
	LDR R1, =history
	LDRSB R4, [R1, R2] //Index
	LSLS R4, #1
	STRB R4, [R1, R2]

	ADDS R2, #1
	LDRSB R4, [R1, R2] //Index + 1
	LSLS R4, #1
	STRB R4, [R1, R2]

	ADDS R2, #1
	LDRSB R4, [R1, R2] //Index + 2
	LSLS R4, #1
	STRB R4, [R1, R2]

	ADDS R2, #1 //Increment index
	LDRSB R4, [R1, R2] //Index + 3
	LSLS R4, #1
	STRB R4, [R1, R2]

	//
	// Read the row indicators for the selected column.
	LDR R3, =GPIOA
	LDR R1, [R3, #IDR]
	LSRS R1, #4
	LDR R4, =0xf
	ANDS R1, R4 //R1 = Row


	// OR the new key sample into the each history variable.
	//Decrement index by 3
	SUBS R2, #3
	LDR R5, =0x1

	LDRSB R4, [R1, R2] //Index
	ANDS R1, R5
	ORRS R4, r1
	STRB R4, [R1, R2]

	ADDS R2, #1
	LDRSB R4, [R1, R2] //Index + 1
	LSRS R1, #1
	ANDS R1, R5
	ORRS R4, r1
	STRB R4, [R1, R2]

	ADDS R2, #1
	LDRSB R4, [R1, R2] //Index + 2
	LSRS R1, #2
	ANDS R1, R5
	ORRS R4, r1
	STRB R4, [R1, R2]

	ADDS R2, #1
	LDRSB R4, [R1, R2] //Index + 3
	LSRS R1, #3
	ANDS R1, R5
	ORRS R4, r1
	STRB R4, [R1, R2]

  POP {R4-R5, PC}

//=======================================================
// 6.5 Debounce keypad
//=======================================================
.global getKeyPressed
getKeyPressed:
	PUSH {R4-R7, LR}
	while1:
	//Return i in R0
	MOVS R0, #0
	for_1:
		CMP R0, #16
		BGE while1
	statements:
		if1:
		LDR R1, =history
		LDRSB R2, [R1, R0]
		CMP R2, #1
		BNE else1
	// if(history[i] == 1)
		LDR R3, =tick
		MOVS R4, #0
		STR R4, [R3]
		POP {R4-R7, PC}
		else1:

	B while1

	//bx lr // Student may remove this instruction.

.global getKeyReleased
getKeyReleased:
	PUSH {R4-R7, LR}

	while1r:
	//Return i in R0
	MOVS R0, #0
	for_1r:
		CMP R0, #16
		BGE while1
	statementsr:
		if1r:
		LDR R1, =history
		LDRSB R2, [R1, R0]
		MOVS R5, #0
		SUBS R5, #2
		CMP R2, R5 //Compare Negative Value
		BNE else1r
		// if(history[i] == -2)
		LDR R3, =tick
		MOVS R4, #0
		STR R4, [R3]
		POP {R4-R7, PC}
		else1r:

	B while1r

	//bx lr // Student may remove this instruction.
