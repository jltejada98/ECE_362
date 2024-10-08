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



.global main
main:
    //Enable Port C
    LDR R0, =RCC
    LDR R1, [R0, #AHBENR]
    LDR R2, =GPIOCEN
    ORRS R1, R2
    STR R1, [R0,#AHBENR] //Store new bits

    //Enable Pin 8 for output
    LDR R0, =GPIOC
    LDR R1, [R0, #MODER]
    LDR R2, =(3<<(2*8))
    BICS R1, R2
    LDR R2, =(1<<(2*8))
    ORRS R1, R2
    STR R1, [R0, #MODER]

    LDR R1, [R0, #ODR]
    LDR R2, =0x100
    BICS R1, R2
    STR R1, [R0, #ODR]


	//Enable TIM6 clock//
	LDR R0, =RCC
	LDR R1, [R0, #APB1ENR] //Load Location for Timers
	LDR R2, =TIM6EN //Value to enable bit 5, TIM6EN
	ORRS R1, R2
	STR R1, [R0, #APB1ENR]

	//Set the PSC and ARR values for update 1ms
	LDR R0, =TIM6
	LDR R1, =2345
	STR R1, [R0, #ARR] //Store ARR value
	LDR R1, =3456
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

	bx lr


//Return from interrupt

.type TIM6_DAC_IRQHandler , %function
.global TIM6_DAC_IRQHandler
TIM6_DAC_IRQHandler:
    	LDR R0, =GPIOC
    	LDR R1, [R0, #ODR]
    	LDR R2, =0x100
    	EORS R1, R2
    	STR R1, [R0, #ODR]

    	LDR R0, =TIM6
    	LDR R1, [R0, #SR]
    	MOVS R2, #1
    	BICS R1, R2
    	STR R1,[R0, #SR]

    bx lr

