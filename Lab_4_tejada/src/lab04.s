.cpu cortex-m0
.thumb
.syntax unified
.fpu softvfp

// External interrupt for pins 0 and 1 is IRQ 5.
.equ EXTI0_1_IRQn,5

// RCC registers
.equ RCC, 0x40021000
.equ AHBENR, 0x14
.equ GPIOAEN, 0x00020000
.equ GPIOBEN, 0x00040000
.equ GPIOCEN, 0x00080000
.equ APB2ENR, 0x18
.equ SYSCFGCOMPEN, 1

// SYSCFG constrol registers
.equ SYSCFG, 0x40010000
.equ EXTICR1, 0x8
.equ EXTICR2, 0xc
.equ EXTICR3, 0x10
.equ EXTICR4, 0x14

// External interrupt control registers
.equ EXTI, 0x40010400
.equ IMR, 0
.equ EMR, 0x4
.equ RTSR, 0x8
.equ FTSR, 0xc
.equ SWIER, 0x10
.equ PR, 0x14

// Variables to register things for pin 0
.equ EXTI_RTSR_TR0, 1
.equ EXTI_IMR_MR0, 1
.equ EXTI_PR_PR0, 1

// NVIC control registers...
.equ NVIC, 0xe000e000
.equ ISER, 0x100
.equ ICER, 0x180
.equ ISPR, 0x200
.equ ICPR, 0x280

// SysTick counter variables...
.equ SYST, 0xe000e000
.equ CSR, 0x10
.equ RVR, 0x14
.equ CVR, 0x18

//=======================================================
// Your translation of
// unsigned int slow_division(unsigned int numer, unsigned int denom)
// {
//    if (denom == 0)
//        return 0;
//    int quotient;
//    for(quotient = 0; numer >= denom; quotient++)
//        numer = numer - denom;
//    return quotient;
// }
//
.global slow_division
slow_division:
  // Student code goes here.
  //Numer => R0
  //demon => R1
  //quotient =>R2

	PUSH {LR}
	CMP R1, #0 //denom == 0
	BNE for1
	MOVS R0, #0//Return 0
	POP {PC}
	for1:
	MOVS R2, #0 //Quotient=0
	check1:
	CMP R1, R0 //denom =< numer
	BHI exit1 //denom > numer
	SUBS R0,R1 //R0 = R0 - R1
	ADDS R2, #1
	B check1
	exit1:
	MOVS R0, R2
	POP {PC}

	//bx lr// Student should remove this instruction.
  // End of student code.

//=======================================================
// Initialize the SysTick counter.
// You should set the SYST_RVR (reset value register)
// so an exception occurs once per second.
//
// Then set the SYST_CSR (control status register) so
// that it uses the CPU clock as the clock source, enable
// the SysTick exception request, and enable the counter.
//
//=======================================================
// Initialize the SysTick counter.
// You should set the SYST_RVR (reset value register)
// so an exception occurs once per 100 milliseconds.
//
// Then set the SYST_CSR (control status register) so
// that it uses the CPU clock as the clock source, enable
// the SysTick exception request, and enable the counter.
//
.global init_systick
init_systick:
        push {lr}
        // Student code goes here.
		LDR R1, =SYST //Load SYST base address
		LDR R0, =1500000 //Value for exception 100ms (Assuming 48Mhz Clock)
		STR R0, [R1, #RVR] //Reset value
		MOVS R0, #7
		STR R0, [R1, #CSR] //Enable
  		// End of student code.
        pop {pc}

//=======================================================
// Your implementation of a SysTick interrupt handler.
// This is an interrupt service routine.
// Increment the value of the global variable tick_counter
// Display that value with a call to display_led().
//
.type SysTick_Handler, %function
.global SysTick_Handler
SysTick_Handler:
        push {lr}
        // Student code goes here.
		LDR R0, =tick_counter
		LDR R1, [R0]
		ADDS R1, #1
		STR R1, [R0] //Store tick counter
		if1:
			LDR R2, =0xf
			ANDS R1, R2
			CMP R1, R2
			BNE end1
		continue:
			LDR R3, =seconds
			LDR R4, [R3]
			ADDS R4, #1
			STR R4, [R3]
			MOVS R0, R4 //Asume R0 as argument for display_led
			BL display_led
		end1:


		///New systick code for step 5
		/*LDR R0, =tick_counter
		LDR R1, [R0]
		ADDS R1, #1
		STR R1, [R0] //Store tick counter
		MOVS R0, R1 //Asume R0 as argument for display_led
		BL display_led
		*/
  		// End of student code.
  pop {pc}

//=======================================================
// The interrupt handler for Pins 0 and 1.
// The handler should increment the global variable named
// 'button_presses' and call display_led with that value.
// Then it should write EXTI_PR_PR0 to the EXTI_PR register to
// clear the interrupt.
//
// Optionally, you may also call micro_wait() for a
// while to debounce the button press.
//
.type EXTI0_1_IRQHandler, %function
.global EXTI0_1_IRQHandler
EXTI0_1_IRQHandler: //Not working
        push {R4, LR}
        // Student code goes here.
		LDR R1, =button_presses
		LDR R2, [R1]
		ADDS R2, #1
		STR R2, [R1]
		MOVS R0, R2 //Assume R0 as argument to display_led
		BL display_led


		//Write values
		LDR R3, =EXTI
		LDR R4, =EXTI_PR_PR0
		STR R4, [R3, #PR]

  		// End of student code.
  		pop {R4, pc}

//=======================================================
// OR the value EXTI_RTSR_TR0 into the EXTI_RTSR
// (rising trigger selection register).
// This will tell the EXTI system to flag an interrupt
// on the rising edge of Pin 0.
//
.global init_rtsr
init_rtsr:
        push {lr}
        // Student code goes here.
		LDR R0, =EXTI
		LDR R1, [R0, #RTSR]
		LDR R2, =EXTI_RTSR_TR0
		ORRS R1, R2
		STR R1, [R0, #RTSR]
  		// End of student code.
  pop {pc}

//=======================================================
// OR the value EXTI_IMR_MR0 into EXTI_IMR
// (Interrupt mask register).
// This will unmask the external interrupt for Pin 0.
//
.global init_imr
init_imr:
       	push {lr}
        // Student code goes here.
		LDR R0, =EXTI
		LDR R1, [R0, #IMR]
		LDR R2, =EXTI_IMR_MR0
		ORRS R1, R2
		STR R1, [R0, #IMR]
  		// End of student code.
  pop {pc}

//=======================================================
// Write (1 << EXTI0_1_IRQn) into the NVIC_ISER
// (Interrupt set enable register).
// (This value is '1' shifted left by EXTI0_1_IRQn bits.)
// This action will enable the external interrupt for pins 0 and 1.
//
.global init_iser
init_iser: //Not working
        push {R4,lr}
        // Student code goes here.
		LDR R0, =NVIC
		LDR R1, =ISER
		//LDR R1, [R1]
		LDR R2, [R0, R1]
		LDR R3, =0x1
		LDR R4, =EXTI0_1_IRQn
		LSLS R3, R4
		STR R2, [R0, R1]

  // End of student code.
  pop {R4, pc}


//=======================================================
// Set the SYSCFGCOMPEN bit in the RCC APB2ENR.
// SYSCFG_EXTICR1 &= ~0xf
// SYSCFG_EXTICR1 |= 1
// Set GPIOBEN in the RCC AHBENR.
//
.global enable_pb0
enable_pb0:
        push {lr}
        // Student code goes here.
		LDR R0, =RCC
		LDR R1, [R0, #APB2ENR]

  // End of student code.
  pop {pc}
