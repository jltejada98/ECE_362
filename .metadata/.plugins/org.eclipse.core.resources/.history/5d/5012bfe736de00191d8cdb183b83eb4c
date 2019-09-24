// Full program
.cpu cortex-m0
.thumb
.syntax unified
.equ SYST, 0xe000e000
.equ CSR, 0x10
.equ RVR, 0x14



.equ  RCC,      0x40021000
.equ  AHBENR,   0x14
.equ  GPIOCEN,  0x00080000
.equ  GPIOBEN,  0x00040000
.equ  GPIOAEN,  0x00020000
.equ  GPIOC,    0x48000800
.equ  GPIOB,    0x48000400
.equ  GPIOA,    0x48000000
.equ  MODER,    0x00
.equ  IDR,      0x10
.equ  ODR,      0x14
.equ  PC0,      0x01
.equ  PC1,      0x04
.equ  PC2,      0x10
.equ  PC3,      0x40
.equ  PC8,      0x10000
.equ  PIN8,     0x00000100


/*
 STUDENT DEFINED BRR/BSRR
*/
.equ  BSRR,     0x18 //Remember that we can use upper 16-bits of BSRR to turn bits off and lower 16 bits to turn bits on.
.equ  BRR,      0x28
.equ EXTI, 0x40010400



.global main
main:
    // Setting up...
    ldr r3, =SYST
    ldr r0, =16000000
    str r0, [r3, #RVR]  // Reset
    movs r0, #7
    str r0, [r3, #CSR]  // Enable
    //Enable Port C for output
    LDR R0, =RCC
    LDR R1, [R0, #AHBENR]
    LDR R2, =GPIOCEN
    ORRS R1, R2
    STR R1, [R0, #ODR] //Store new bits
    //Enable Pin 8 for output
    LDR R0, =GPIOC //Load GPIOC base Address
	LDR R1, [R0, #MODER] //Load Moder Registers of port C
	LDR R2, =PC8
	ORRS R2, R1
	STR R2, [R0, #MODER]

loop:
	b loop  // Endless loop


//Return from interrupt

.type SysTick_Handler, %function
.global SysTick_Handler
SysTick_Handler:
    push {lr}
    //Determine whether current value is low of high
	LDR R0, =GPIOC
	LDR R2, =0x1 //Load Hexadecimal 1
	MOVS R1, #8 //Pin 8
	LDR R3, [R0, #IDR]
	LSRS R3, R1
	ANDS R3, R2
	CMP R3, #0
	BEQ low
	BGT high
low:
	//Set pin value to be high
	LSLS R2, R1 //Shift by Bit number of Pin
	STR R2, [R0, #BSRR] //Set pin value using BSRR
	B end
high:
	//Set pin value to be low
	LSLS R2, R1 //Shift by Bit number of Pin
	STR R2, [R0, #BRR] //Set pin value using BSRR
end:

	//How to acknowledge and interrupt????

    pop {pc}

