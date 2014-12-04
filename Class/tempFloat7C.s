.data
value:   .float 1.54321 
fmt_out: .asciz "Floating point value is: %f \n"
fmt_get: .asciz "Input a new floating point value \n"
fmt_in:  .asciz "%f"

.text
.global main 
.func main 
main: 
	push {r4,lr}         @ Align with 8 bytes
	sub sp, sp, #8       @ Make room for one 8 byte integer in the stack
	
	/* Convert the float to a double */
	ldr r1,addr_value    @ Get addr of value 
	vldr s14,[r1]        @ Move value to s14 
	vcvt.f64.f32 d5,s14  @ Convert to B64 
	
	/* Print the result */
	ldr r0, addr_fmt_out @ Point r0 to string 
	vmov r2, r3, d5      @ Load value 
	bl printf            @ Call function 
	
    /* Prompt for a new floating point variable */
	ldr r0, addr_fmt_get @ Point r0 to string
	bl printf            @ Call function 
	
    /* Input the value */
	ldr r0,addr_fmt_in   @ Single float format
	ldr r1, addr_value  @ place address of stack in r1
	@mov r1,sp            @ Place address of stack in r1
	bl scanf
	
	/* Store this value in the variable */
	/* or take this code out if using ldr r1, addr_value */
	@ldr r0,[sp]          @ Load the value in r0
	@ldr r1,addr_value    @ Where to store the value
	@str r0,[r1]          @ Store the new value
	
	/* Convert the float to a double again*/
	ldr r1,addr_value    @ Get addr of value 
	vldr s14,[r1]        @ Move value to s14 
	vcvt.f64.f32 d5,s14  @ Convert to B64 
	
	/* Print the result */
	ldr r0, addr_fmt_out @ Point r0 to string 
	vmov r2, r3, d5      @ Load value 
	bl printf            @ Call function 
	
	/* Remove from the stack and return */
	add sp, sp, #8      @ Discard the integer read by scanf
	pop {r4,lr}
	bx lr

addr_value:   .word value
addr_fmt_out: .word fmt_out
addr_fmt_get: .word fmt_get
addr_fmt_in:  .word fmt_in