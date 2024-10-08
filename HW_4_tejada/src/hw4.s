.cpu cortex-m0
.thumb
.syntax unified
.fpu softvfp

//============================================================================
// Q1: hello
//============================================================================
.global hello
hello:
	PUSH {LR}
	LDR R0, =hello_t
	BL printf
	POP {PC}

//============================================================================
// Q2: add2
//============================================================================
.global add2
add2: //Assume a in R0, b in R1
	PUSH {LR}
	MOVS R2, R1
	MOVS R1, R0
	ADDS R3, R1, R2
	LDR R0, =add2_f
	BL printf
	POP {PC}

//============================================================================
// Q3: add3
//============================================================================
.global add3
add3: //Assume a in R0, b in R1, c in R2
	PUSH {LR}
	MOVS R3, R2
	MOVS R2, R1
	MOVS R1, R0
	LDR R0, =add3_f
	MOVS R4, #0
	ADDS R4, R1
	ADDS R4, R2
	ADDS R4, R3
	PUSH {R4}
	BL printf
	POP {R4, PC}

//============================================================================
// Q4: rotate6
//============================================================================
.global rotate6 //Does not work
rotate6: //R0 = a, R1 = b, R2 = c, R3 = d, R4 = e, R5 = f
	PUSH {R4-R6, LR}

	LDR R5, [SP, #20] //f
  	LDR R4, [SP, #16] //e

	if1:
    	CMP R0, #0
    	BEQ continue
    	//Return
  		MOVS R6, R5
  		MOVS R5, R4
  		MOVS R4, R3
  		MOVS R3, R2
  		MOVS R2, R1
  		MOVS R1, R0
  		MOVS R0, R6
  		SUB SP, #4
  		STR R5, [SP]
  		SUB SP, #4
  		STR R4, [SP]
  		ADD SP, #8
  		B rotate6
  		B end_1
  	continue:
    	SUBS R5, R4
    	SUBS R5, R3
    	SUBS R5, R2
    	SUBS R5, R1
    	SUBS R5, R0
    	MOVS R0, R5
    end_1:

	POP {R4-R6, PC}

//============================================================================
// Q5: low_pattern
//============================================================================
.type compare, %function  // You knew you needed this line.  Of course you did!
compare:
        ldr  r0,[r0]
        ldr  r1,[r1]
        subs r0,r1
        bx lr

.global low_pattern
low_pattern: //nth = R0
	PUSH {R4-R7,LR}
  	MOVS R1, #0 //x
  	SUB SP, #400
  	SUB SP, #400
  	MOV R7, SP //Array starts at R7
  check1:
    CMP R1, #200
    BGE finish
  body:
    ADDS R2, R1, #1
    MOVS R3, #255
    MULS R3, R2
    LDR R4, =0xff
    ANDS R3, R4
    LSLS R6, R1, #2
    STR R3, [R7, R6]
    ADDS R1, #1
    B check1
  finish:
  	MOVS R5, R0 //Store nth
  	MOVS R0, R7
  	MOVS R1, #200
  	MOVS R2, #4
  	LDR R3, =compare
  	BL qsort
  	MOVS R0, R5
  	LDR R0, [R7, R0]
  	ADD SP, R2
    POP {R4-R7,PC}


//============================================================================
// Q6: get_name
//============================================================================
.global get_name
get_name:
	PUSH {LR}
	SUB SP, #308 //Allocate Memory for buffer
	LDR R0, =get_name_t
	BL printf
	MOV R0, SP
	BL gets
	MOVS R1, R0
	LDR R0, =get_name_f
	BL printf
	POP {PC}

//============================================================================
// Q7: random_sum
//============================================================================
.global random_sum
random_sum:
	PUSH {R4-R7,LR}
	SUB SP, #80
	MOV R3, SP //Array start
	MOVS R1,#0 //Sum
	MOVS R2, #1 //x
	BL random //Result in R0
	STR R0, [R3]
	for1:
		CMP R2, #20
		BGE endfor1
		SUBS R5, R2, #1
		LDR R4, [R3, R5]
		BL random //Result in R0
		SUBS R4, R0
		STR R4, [R3,R2]
		ADDS R2, #1
		B for1
	endfor1:
	MOVS R2, #0
	for2:
		CMP R2, #20
		BGE endfor2
		STR R6, [R3, R2]
		ADDS R1, R6
		ADDS R2, #1
		B for2
	endfor2:
	MOVS R0, R1
	POP {R4-R7,PC}
//============================================================================
// Q8: fibn
//============================================================================
.global fibn
fibn: //n = R0
	PUSH {R4-R7,LR}
	SUB SP, #400
	SUB SP, #80
	MOV R1, SP //Array Start
	MOVS R2, #0
	STR R2, [R1]
	MOVS R2, #1
	STR R2, [R1, #4]
	MOVS R2, #1 //x
	for1_f:
		CMP R2, #120
		BGE endfor
		SUBS R3, R2, #1
		LDR R4, [R1, R3]
		SUBS R3, #1
		LDR R5, [R1,R3]
		ADDS R4, R5
		STR R4, [R1, R2]
		ADDS R2, #1
		B for1_f
	endfor:

	POP {R4-R7,PC}
//============================================================================
// Q9: fun
//============================================================================
.global fun
fun: //A = R0, B = R1
	PUSH {R4-R7, LR}
	SUB SP, #400 //Make space for array
	MOV R2, SP //Array start
	MOVS R3, #1 //x
	MOVS R4, #0 //sum

	STR R4, [R2]
	for1_fu:
		CMP R3, #100
		BGE endfor1
		MOVS R6, #37
		ADDS R5, R3, #7
		MULS R5, R6
		MOVS R6, #1
		SUBS R7, R3, R6
		LDR R7, [R2, R7]
		ADDS R7, R5
		STR R7, [R2, R3]
		ADDS R3, #1
	endfor1_fu:

	MOVS R3, R0
	for2_fu:
		CMP R3, R1
		BGT endfor2_fu
		LDR R5, [R2, R3]
		ADDS R4, R5
		ADDS R3, #1
		B for2_fu
	endfor2_fu:


	POP {R4-R7,PC}

//============================================================================
// Q10: sick
//============================================================================
.global sick
sick:
	//R0 = start, R1=  end, R2= add, R3= mul, R4= step
	PUSH {R4-R7, LR}
	SUB SP,#400 //Save space array
	MOV R5, SP //Array
	MOVS R6, #0 //x
	MOVS R7, #0 //sum
	STR R7, [R5]
	//Put R0, R1 into stack for later use
	SUB SP, #4
	STR R0, [SP] //Push start
	SUB SP, #4
	STR R1, [SP]  //Push End
	for1_s:
		CMP R6, #100
		BGE endfor1_s
		MOVS R0, R6 //x
		ADDS R0, R2 //x+add
		MULS R0, R3 //(x+add) * mul -> R0
		SUBS R6, #1 //x-1
		LDR R1, [R5, R6]  //Load array[x-1]
		ADDS R6, #1 //x+1
		ADDS R0, R1 //arr[x-1] + (x + add) * mul;
		STR R6, [R5, R6] //Str array[x] = arr[x-1] + (x + add) * mul;
		ADDS R6, #1 //Increment
	endfor1_s:
	//Recover items from stack
	LDR R1, [SP] //Get end
	LDR R0, [SP] //Get start
	ADD SP, #8
	MOV R6, R0
	for2_s:
		CMP R6, R1
		BGE endfor_2_s
		LDR R2 [R5, R6]
		ADDS R7, R2
		ADDS R6
		B for2_s
	endfor_2_s:
		MOVS R0, R7

	endfor_2_s:
	POP {R4-R7,PC}

//Strings

hello_t:
	.string "Hello, World!\n"
	.align 2

add2_f:
	.string "%d + %d = %d\n"
	.align 2

add3_f:
	.string "%d + %d + %d = %d\n"
	.align 2

get_name_t:
	.string "Enter your name: "
	.align 2

get_name_f:
	.string "Hello, %s\n"
	.align 2

