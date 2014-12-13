.data
message: .asciz "The generated number is:%d\n"
rand_number: .word 0
msg: .asciz "I have a number between 1 and 1000\nCan you guess my number?  You will be given a maximum of 10 guesses.\n"
msg1: .asciz "Please type your 1st guess:"
msg2: .asciz "Please type your 2nd guess:"
msg3: .asciz "Please type your 3rd guess:"
msg4: .asciz "Please type your %dth guess:"
msg5: .asciz "Too low.  Try again.\n"
msg6: .asciz "Too High. Try again.\n"
msg7: .asciz "Congratulations, You guessed the number!\n"
msg8: .asciz "Too many tries.\n"
msg9: .asciz "Would you like to play again(y or n)?"
entered: .word 0
scan_format: .asciz "%d"
scan_format2: .asciz  " %c"
option: .word 0
msg10: .asciz "You entered an invalid value: %c\n"

generate_number:
	push {r4, lr}

	mov r0,#0                    /* Set time(0) */
    	bl time                      /* Call time */
	bl srand                     /* Call srand */
	bl rand			     /* Call rand */
	mov r2, r0, lsr #7
	vmov s1, r2	/* Bit copy from integer register r2 to s1 */
	vcvt.f32.s32 s1, s1 /* Converts s1 signed integer value to a single-precision value and stores it in s1 */

	mov r2, #1000	 /* The goal is to generate 1000 intege so the denominator is 7 */
	vmov s2, r2 	/* Bit copy from integer register r2 to s2 */
	vcvt.f32.s32 s2, s2 	/* Converts s2 signed integer value to a single-precision value and stores it in s2 */

	vdiv.f32 s3, s1, s2 /* s3 is the result of dividing by 7; s3=s1/s2 */

	vcvt.s32.f32 s3, s3 /* Converts s3 single-precision value to a signed integer and stores it in s3, in other words only keep the integer part of the float */
	vmov r3, s3 /*Bit copy from s3 to r3 */

	vmov s4, r3 /* Bit copy from integer register r3 to s4 */
	vcvt.f32.s32 s4, s4 /* Converts s4 signed integer value to a single-precision value and stores it in s4 */
	vmul.f32 s5, s4, s2 /* multiply the integer part of the float of division with float 7' s5=s4*s2 */
	vsub.f32 s6, s1, s5 /* subtract the integer part of the float of division will leave us the remainder; s6=s1*s5 */

	vcvt.s32.f32 s6, s6 /* Convert s6 single-precision value to a signed integer and stores it in s6 */
	vmov r1, s6 /* Bit copy from s6 to r1 */
	str r1,[r6]

	pop {r4, lr}
	bx lr

read_and_load_number:
	push {lr}

	ldr r0, =scan_format
        ldr r1, =entered
        bl scanf

        ldr r2, =entered
        ldr r2, [r2]
        ldr r3, =rand_number
        ldr r3, [r3]

	pop {lr}
	bx lr
.text
.align 4
.global guess
guess:
	push {r4-r6, lr}
start:
	ldr r6, =rand_number
	bl generate_number

	ldr r0, =message
	ldr r1, =rand_number
	ldr r1, [r1]
	bl printf

	ldr r0, =msg
	bl printf

	ldr r0, =msg1
	bl printf

	bl read_and_load_number

	cmp r2, r3
	beq case_win
	blt case_less1
	ldr r0, =msg6
	bl printf

	ldr r0, =msg2
	bl printf
second:
	bl read_and_load_number

	cmp r2, r3
	beq case_win
	blt case_less2
	ldr r0, =msg6
	bl printf

	ldr r0, =msg3
	bl printf
third:
	bl read_and_load_number

	cmp r2, r3
	beq case_win
	blt case_less3
	ldr r0, =msg6
	bl printf

	mov r4, #4
fourth:
	mov r1, r4
	ldr r0, =msg4
	bl printf
	bl read_and_load_number
	cmp r2, r3
	beq case_win
	blt less
	ldr r0, =msg6
	bl printf
	add r4, r4, #1
	cmp r4, #10
	bne fourth
lose:
	ldr r0, =msg8
	bl printf
exit:
	ldr r0, =msg9
	bl printf

	ldr r0, =scan_format2
	ldr r1, =option
	bl scanf

	ldr r1, =option
	ldr r1, [r1]

	cmp r1, #'Y'
	beq case_Y
	cmp r1, #'y'
	beq case_y
	cmp r1, #'N'
	beq case_N
	cmp r1, #'n'
	beq case_n

	ldr r0, =msg7
	bl printf
	b exit
ending:
	pop {r4-r6, lr}
	bx lr

less:
	ldr r0, =msg5
	bl printf
	add r4, r4, #1
        cmp r4, #10
        bne fourth
	b lose
case_win:
	ldr r0, =msg7
	bl printf
	b exit
case_less1:
	ldr r0, =msg5
	bl printf
	ldr r0, =msg2
	bl printf
	b second
case_less2:
	ldr r0, =msg5
	bl printf
	ldr r0, =msg3
	bl printf
	b third
case_less3:
	ldr r0, =msg5
	bl printf
	mov r4, #4
	b fourth

case_Y:
	b start
case_y:
	b start
case_N:
	b ending
case_n:
	b ending
.global printf
.global scanf