.data
fmt_get: .asciz "Type a number to convert to Celsius: "
fmt_out: .asciz "The conversion is: %f  \n"
fmt_in: .asciz "%f"

value: .float 0.55555
.text

.global main
.func main
main:

push {r4, lr} 				@ align with 8 bytes
sub sp, sp, #8 				@ make room on the stack

ldr r1, addr_value	 		@ float part of equation
vldr s14, [r1] 				@ load r1 into s14
vcvt.f64.f32 d5, s14 		@ convert to 64 bit into d5
							@ d5 has float 5/9
ldr r0, addr_fmt_out 		@ Set message as the first parameter of printf
bl printf 					@ Call printf 

ldr r0, addr_fmt_in 	  	@ Set &format as the first parameter of scanf 
ldr r1, addr_value	 		@ set r1 as the input 
bl scanf 					@ scan integer onto r1

ldr r1,addr_value    		@ Get addr of value 
vldr s14,[r1]        		@ Move value to s14 
vcvt.f64.f32 d5, s14  		@ Convert to B64 into d4

@ldr r6, =1500000 			@ set register for loop
ldr r0, addr_fmt_out		@ temporary message
vmov r2, r3, d5				@ temporary!!!!!!!!
@vstr d4, [sp]				@ temp
bl printf					@ temp




add sp, sp, #8				@ adjust stack
pop {r4, lr} 				@ restore pc
bx lr

addr_fmt_in: .word fmt_in
addr_fmt_out: .word fmt_out
addr_fmt_get: .word fmt_get
addr_value: .word value
