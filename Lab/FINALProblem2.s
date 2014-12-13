.data
.align 4
msg: .asciz "This is a program that fills an array then prints the result for the following.\n"
years: .word 0
interest_rate: .word 0
present_value: .word 0
msg1: .asciz "Enter the number of years, range => 1 to 20:"
msg2: .asciz "Enter the interest rate, range   => 5 percent to 10 percent:"
msg3: .asciz "Enter present value => $1000 to $5000 for the first year:"
scan_format: .asciz "%d"
msg4: .asciz "After %d year,"
msg5: .asciz " the Future Value is %f\n"
.align 4
array: .skip 84
.align 4
fill_array:
	push {r4-r8, lr}

	ldr r4, =years
	ldr r4, [r4]

	ldr r5, =interest_rate
	ldr r5, [r5]
	vmov s5, r5
	vcvt.f32.s32 s5, s5
	mov r5, #100
	vmov s4, r5
	vcvt.f32.s32 s4, s4 /* s4 has float 100 */
	vdiv.f32 s6, s5, s4 /* omyeresy rate as dicimal.factrial */

	ldr r5, =present_value
	ldr r5, [r5]
	vmov s7, r5
	vcvt.f32.s32 s7, s7 /* s7 has float pv of year 1 */

	mov r5, #1
	vmov s8, r5
	vcvt.f32.s32 s8, s8 /* s8 has float 1 */

	vadd.f32 s3, s8, s6 /* s3 = s8 + s6; the result is 1.05-1.10 */
	mov r5, #0
	b check_loop_array
loop_array:
	vmul.f32 s2, s7, s3 /* s2 = s7 * s3; FV = PV * (1+i) */
	vmov r7, s2
	str r7, [r6, r5, lsl #2]
	add r5, r5, #1
	vmov s7, s2
check_loop_array:
	cmp r5, r4
	bne loop_array

	pop {r4-r8, lr}
	bx lr

print_array:
	push {r4-r8, lr}

	ldr r4, =years
	ldr r4, [r4]

	mov r5, #0
	b check_print_loop_array
print_loop_array:
	ldr r7, [r6, r5, lsl #2]
	vmov s1, r7
	vcvt.f64.f32 d1, s1

	add r5, r5, #1
	mov r1, r5
	ldr r0, =msg4
	bl printf

	vmov r2, r3, d1
	ldr r0, =msg5
	bl printf
check_print_loop_array:
	cmp r5, r4
	bne print_loop_array

	pop {r4-r8, lr}
	bx lr

.text
.align 4
.global future
future:
	push {r4, lr}

	ldr r0, =msg
	bl printf

	ldr r0, =msg1
	bl printf

	ldr r0, =scan_format
	ldr r1, =years
	bl scanf

	ldr r0, =msg2
	bl printf

	ldr r0, =scan_format
	ldr r1, =interest_rate
	bl scanf

	ldr r0, =msg3
	bl printf

	ldr r0, =scan_format
	ldr r1, =present_value
	bl scanf

	ldr r6, =array
	bl fill_array

	ldr r6, =array
	bl print_array

	pop {r4, lr}
	bx lr
.global printf
.global scanf