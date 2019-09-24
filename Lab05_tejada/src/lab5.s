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
.equ  PIN8,     0x00000100

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
	PUSH {R4-R7, LR}
	//Enable clock to Port C and Port A.
	LDR R0, =RCC
	LDR R1, [R0, #AHBENR]
	LDR R2, =GPIOCEN
	LDR R3, =GPIOAEN
	ORRS R2, R3 //Obtain number to enable ports B and C
	ORRS R1, R2 //Enable ports B and C
	STR R1, [R0, #AHBENR] //Store new bits

	//Set PC0, PC1, PC2, PC3 and PC8 as outputs.
	LDR R0, =GPIOC
	LDR R1, [R0, #MODER] //Load Moder Registers of port C
	LDR R2, =PC0 //Load Value to Enable pin 0 of port C
	LDR R3, =PC1 //Load Value to Enable pin 1 of port C
	LDR R4, =PC2 //Load Value to Enable pin 2 of port C
	LDR R5, =PC3 //Load Value to Enable pin 3 of port C
	LDR R6, =PIN8 //Load Value to Enable pin 8 of port C
	ORRS R2, R3
	ORRS R2, R4
	ORRS R2, R5
	ORRS R2, R6  //OR all port values to enable all ports
	ORRS R1, R2  //OR with MODER registers of port C
	STR R1, [R0, #MODER] //Store new bits

	//Set PA0, PA1, PA2 and PA3 as outputs.
	LDR R0, =GPIOA
	LDR R1, [R0, #MODER] //Load Moder Registers of port C
	LDR R2, =PC0 //Load Value to Enable pin 0 of port A
	LDR R3, =PC1 //Load Value to Enable pin 1 of port A
	LDR R4, =PC2 //Load Value to Enable pin 2 of port A
	LDR R5, =PC3 //Load Value to Enable pin 3 of port A
	ORRS R2, R3
	ORRS R2, R4
	ORRS R2, R5 //OR all port values to enable all ports
	ORRS R1, R2 //OR with MODER registers of port A
	STR R1, [R0, #MODER] //Store new bits

	//Set up a pull down resistance on pins PA4, PA5, PA6 and PA7.


	STR R1, [R0, #MODER] //Store new bits


	//bx lr // Student may remove this instruction.

	POP {R4-R7, PC}

//=======================================================
// 6.3 Blink blue LED using Timer 6 interrupt
// Write your interrupt service routine below.
//=======================================================


//=======================================================
// 6.5 Debounce keypad
//=======================================================
.global getKeyPressed
getKeyPressed:
	bx lr // Student may remove this instruction.

.global getKeyReleased
getKeyReleased:
	bx lr // Student may remove this instruction.
