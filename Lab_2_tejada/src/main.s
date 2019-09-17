.cpu cortex-m0
.thumb
.syntax unified
.fpu softvfp
.text
.global main
main:
	LDR R0, =size //Number of array elements
	LDR R0, [R0]
	LDR R1, =source //Holds source array
	MOVS R2, #0 //Holds current difference
	MOVS R3, #0 //Current array index
	MOVS R4, #0 //Array Offset
	MOVS R5, #0 //Current element_1
	MOVS R6, #0 //Current element_2
	LDR R7, =result //Holds results array

for_1:
	CMP R3, R0 //Determine if index >= size
	BCC done_1
if_1: //Determine if index is odd of even
	LSRS R2, R3, #1
	BEQ else_1//Index is even
then_1:
	LSLS R4, R3, #4 //Obtain array offset for element 2 [i+1]
	LDR R6, [R1, R4] //Load current element 2
	LSLS R4, R3, #2 //Obtain array offset for element 1 [i]
	LDR R5, [R1, R4] //Load current element 1
	SUBS R2, R5, R6   //Element 1 - Element 2
	STR R2,[R7, R4] //Store into results array
	MOVS R2, #0 //Reset for usage in condition
	ADDS R3, #1 //Increment index
	B for_1
else_1: //Index is even
	LSLS R4, R3, #4 //Obtain array offset for element 1 [i+1]
	LDR R5, [R1, R4] //Load current element 1
	LSLS R4, R3, #2 //Obtain array offset for element 2 [i]
	LDR R6, [R1, R4] //Load current element 2
	SUBS R2, R5, R6 //Element 1 - Element 2
	STR R2,[R7, R4] //Store into results array
	MOVS R2, #0 //Reset for usage in condition
	ADDS R3, #1 //Incrememnnt index
	B for_1
done_1:
	wfi





.data
.align 4
size: .word 4
result:
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
source:
	.word 2
	.word 3
	.word 5
	.word 7
	.word 11
	.word 13
	.word 17
	.word 19
	.word 23
	.word 29
	.word 31
	.word 37
	.word 41
	.word 43
	.word 47
	.word 53
	.word 59
