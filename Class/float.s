.data
value:   .float 0.55555 
value2:  .float 32.0
fmt_out: .asciz "The conversion is: %f \n"
fmt_get: .asciz "Type a number to convert to Celsius: \n"
fmt_in:  .asciz "%f"

.text
.global main 
.func main 
main: 
	push {r4,lr}         @ Align with 8 bytes
	sub sp, sp, #8       @ Make room for one 8 byte integer in the stack
	
	/* Convert the float to a double */
	ldr r1,addr_value    @ Get addr of value (5/9) 
	vldr s14,[r1]        @ Move value to s14 
	vcvt.f64.f32 d4,s14  @ Convert to b64 into d4 
				@ d4 has float 5/9

    /* Prompt for a new floating point variable */
	ldr r0, addr_fmt_get @ Point r0 to string
	bl printf            @ Call function 
	
    /* Input the value */
	ldr r0,addr_fmt_in   @ Single float format
	ldr r1, addr_value   @ place address of stack in r1
	bl scanf
	
	/* Convert the input to float and into a double*/
	ldr r1,addr_value    @ Get addr of value 
	vldr s14,[r1]        @ Move value to s14 
	vcvt.f64.f32 d5,s14  @ Convert to B64 into d5

	/* set counter and load 32 into d0 */
	ldr r3, =10000000    @ loop 10,000,000 times
	ldr r1, addr_value2  @ load value 32
	vldr s14, [r1]       @ move value to s14
	vcvt.f64.f32 d0, s14 @ convert to b64 into d0

	loop:
	ldr r1, addr_value   @ get addr of value
	vldr s14, [r1]       @ move value to s14
	vcvt.f64.f32 d5, s14 @ convert to b64 into d5
	vsub.f64 d5, d5, d0  @ calculate d5 - 32
	sub r3, r3, #1       @ subtract from counter
	cmp r3, #0           @ compare and branch if != 0
	bgt loop
	
	vmul.f64 d5, d4, d5  @ d4(float 5/9) * d5(user input - 32)

	/* Print the result */
	ldr r0, addr_fmt_out @ Point r0 to string 
	vmov r2, r3, d5      @ Load value 
	bl printf            @ Call function 
	
	/* Remove from the stack and return */
	add sp, sp, #8      @ Discard the integer read by scanf
	pop {r4,lr}
	bx lr

addr_value:   .word value
addr_value2:   .word value2
addr_fmt_out: .word fmt_out
addr_fmt_get: .word fmt_get
addr_fmt_in:  .word fmt_in
