.data
value:       .float 0
half:        .float 0.5      /* Just 1/2 constant */
x_zero:      .float 400		/* Just 600 constant */
msg1:  .asciz "This program solves a square root function by using the babylonian method\nInputs will be from 1 to 10^4:"
msg2: .asciz "The square root of %f"
msg3: .asciz " is %f\n"
scan_format:     .asciz "%f"

.text
.global square
.func square
square:
	push {r4,lr}           @ Align with 8 bytes

	ldr r0, =msg1
	bl printf

	ldr r0, =scan_format
	ldr r1, =value
	bl scanf

	ldr  r1, =value
	vldr s0,[r1]
	ldr r1, =half
	vldr s1, [r1]
	ldr r1, =x_zero
	vldr s2, [r1]
	mov r4, #0
	b check_loop
loop:
	vdiv.f32 s4, s0, s2 /* s6 = s1/s2; S/xi */
	vadd.f32 s4, s4, s2 /* s6+= s2; xi + S/xi */
	vmul.f32 s4, s4, s1 /* s6*=s3; (1/2)*(x0 + S/xi) */
	vcvt.f64.f32 d10,s4
	vmov s2, s4
	add r4, r4, #1
check_loop:
	cmp r4, #10
	bne loop

	ldr r1, =value
	vldr s0, [r1]
	vcvt.f64.f32 d11, s0
	ldr r0, =msg2
	vmov r2, r3, d11
	bl printf

	ldr r0, =msg3
	vmov r2,r3,d10
	bl printf

	/* Exit stage right */
	pop {r4,lr}
	bx lr

.global printf
.global scanf