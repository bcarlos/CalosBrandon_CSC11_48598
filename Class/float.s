.data
value:   .float 1.54321 
fmt_out: .asciz "Floating point value is: %f \n"
fmt_get: .asciz "Input a floating point value \n"
fmt_in:  .asciz "%f"

.text
.global main 
.func main 
main: 
	push {r4,lr}         @Align with 8 bytes
	
	/* Convert the float to a double */
	ldr r1,addr_value    @ Get addr of value 
	vldr s14,[r1]        @ Move value to s14 
	vcvt.f64.f32 d5,s14  @ Convert to B64 
	
	/* Print the result */
	ldr r0, addr_fmt_out @ point r0 to string 
	vmov r2, r3, d5      @ Load value 
	bl printf            @ call function 
	
	/* Remove from the stack and return */
	pop {r4,lr}
	bx lr

addr_value:   .word value
addr_fmt_out: .word fmt_out
addr_fmt_get: .word fmt_get
addr_fmt_in:  .word fmt_in