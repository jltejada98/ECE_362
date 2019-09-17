.syntax unified
.cpu cortex-m0
.fpu softvfp
.thumb

//===================================================================
// ECE 362 Lab Experiment 3
// General Purpose I/O
//===================================================================

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
.equ  PIN8,     0x00000100


/*
 STUDENT DEFINED BRR/BSRR
*/
.equ  BSRR,     0x18 //Remember that we can use upper 16-bits of BSRR to turn bits off and lower 16 bits to turn bits on.
.equ  BRR,      0x28



//===========================================================
// Enable Ports B and C in the RCC AHBENR
// No parameters.
// No expected return value.
.global enable_ports
enable_ports:
    push    {lr}
    // Student code goes here
	//Enable Port B
	LDR R0, =RCC
	LDR R1, [R0, #AHBENR]
	LDR R2, =GPIOCEN
	LDR R3, =GPIOBEN
	ORRS R2, R3 //Obtain number to enable ports B and C
	ORRS R1, R2 //Enable ports B and C
	STR R1, [R0, 0x14] //Store new bits

    // End of student code
    pop     {pc}

//===========================================================
// Set bits 0-3 of Port C to be outputs.
// No parameters.
// No expected return value.
.global port_c_output
port_c_output:
    push    {lr}
    // Student code goes here
	LDR R0, =GPIOC //Load GPIOC base Address
	LDR R1, [R0, #MODER] //Load Moder Registers of port C
	LDR R2, =PC0 //Load Value to Enable pin 0 of port C
	LDR R3, =PC1 //Load Value to Enable pin 1 of port C
	LDR R4, =PC2 //Load Value to Enable pin 2 of port C
	LDR R5, =PC3 //Load Value to Enable pin 3 of port C
	ORRS R2, R3
	ORRS R2, R4
	ORRS R2, R5  //OR all port values to enable all ports
	ORRS R1, R2  //OR with MODER registers of port C
	STR R1, [R0, #MODER] //Store new bits
    // End of student code
    pop     {pc}

//===========================================================
// Set the state of a single output pin to be high.
// Do not affect the other bits of the port.
// Parameter 1 is the GPIOx base address. (R0)
// Parameter 2 is the bit number of the pin. (R1)
// No expected return value.
.global setpin
setpin:
    push    {lr}
    // Student code goes here
	//Consider Using BSRR
	LDR R2, =0x1 //Load Hexadecimal 1
	LSLS R2, R1 //Shift by Bit number of Pin
	STR R2, [R0, #BSRR] //Set pin value using BSRR

	/*
	ORRS R2, R3 //OR Current ODR registers and set pin
	STR R2, [R0, #ODR] //Store new bits
	*/

    // End of student code
    pop     {pc}

//===========================================================
// Set the state of a single output pin to be low.
// Do not affect the other bits of the port.
// Parameter 1 is the GPIOx base address. (R0)
// Parameter 2 is the bit number of the pin. (R1)
// No expected return value.
.global clrpin
clrpin:
    push    {lr}
    // Student code goes here
	//Consider using BRR
	LDR R2, =0x1 //Load Hexadecimal 1
	LSLS R2, R1 //Shift by Bit number of Pin
	STR R2, [R0, #BRR] //Set pin value using BRR

	/*
	BICS R2, R3 //OR Current ODR registers and set pin
	STR R2, [R0, #ODR] //Store new bits
	*/

    // End of student code
    pop     {pc}

//===========================================================
// Get the state of the input data register of
// the specified GPIO.
// Parameter 1 is GPIOx base address.(R0)
// Parameter 2 is the bit number of the pin. (R1)
// The subroutine should return 0x1 if the pin is high
// or 0x0 if the pin is low.
.global getpin
getpin:
    push    {lr}
    // Student code goes here
    LDR R3, =0x1 //Create Mask
	LDR R2, [R0, #IDR] //Load IDR Registers from Port
	LSRS R2, R1 //Right shift by bit number
	ANDS R2, R3 //Only obtain desired bit
	CMP R2, #0
	BGT high
	BEQ low

high:
	MOVS R0, #1
	B finish
low:
	MOVS R0, #0
	B finish
finish:


    // End of student code
    pop     {pc}

//===========================================================
// Get the state of the input data register of
// the specified GPIO.
// Parameter 1 is GPIOx base address. (R0)
// Parameter 2 is the direction of the shift  (R1)
//
// Perfroms the following logic
// 1) Read the current content of GPIOx-ODR
// 2) If R1 = 1
//      (a) Left shift the content by 1
//      (b) Check if value exceeds 8
//      (c) If so set it to 0x1
// 3) If R1 != 0
//      (a) Right shift the content by 1
//      (b) Check if value is 0
//      (c) If so set it to 0x8
// 4) Store the new value in ODR
// No return value
.global seq_led
seq_led:
    push    {lr}
    // Student code goes here
	LDR R2, [R0, #ODR]
	CMP R1, #1
	BEQ one_b
	BNE not_one_b

one_b:
	LSLS R2, #1
	CMP R2, #8
	BGT set_one_b
	BLE done
set_one_b:
	LDR R2, =0x1
	B done

not_one_b:
	LSRS R2, #1
	CMP R2, #0
	BEQ set_eight
	BNE done
set_eight:
	LDR R2, =0x8

done:
	STR R2, [R0, #ODR]



    // End of student code
    pop     {pc}

.global main
main:
    // Uncomment the line below to test "enable_ports"
    //bl  test_enable_ports

    // Uncomment the line below to test "port_c_output"
    //bl  test_port_c_output

    // Uncomment the line below to test "setpin and clrpin"
    //bl  test_set_clrpin

    // Uncomment the line below to test "getpin"
    //bl  test_getpin

    // Uncomment the line below to test "getpin"
    //bl  test_wiring

    // Uncomment to run the LED sequencing program
    bl run_seq

inf_loop:
    b inf_loop

