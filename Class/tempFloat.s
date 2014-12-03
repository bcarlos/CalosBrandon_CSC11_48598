.data

message_get: .asciz "Type a number to convert to Celsius: "
message_out: .asciz "The conversion is: %f  \n"

format_in: .asciz "%f"
word1: .word 0				@ unused???
value1: .float 0.55555
return: .word 0
.text

.global main
.func main
main:

push {r4, r5, r6, lr} 				@ align with 8 bytes
@ldr r1, addr_return
@str lr, [r1]
sub sp, sp, #8 				@ make room on the stack

ldr r1, addr_value1 		@ float part of equation
vldr s14, [r1] 				@ load r1 into s14
vcvt.f64.f32 d5, s14 		@ convert to 64 bit into d5
							@ d5 has float 5/9
ldr r0, =message_get 		/* Set &message_get as the first parameter of printf */
bl printf 					/* Call printf */

/*
ldr r0, addr_format_in   	/* Set &format as the first parameter of scanf */
ldr r1, addr_value1 		@ set r1 as the input 
bl scanf 					@ scan integer onto r1

ldr r1,addr_value1    		@ Get addr of value 
vldr s16,[r1]        		@ Move value to s16 
vcvt.f64.f32 d6, s16  		@ Convert to B64 into d6
*/

@ldr r6, =1500000 			@ set register for loop
ldr r0, =message_out		@ temporary message
vmov r2, r3, d5				@ temporary!!!!!!!!
@ vstr d6, [sp]				@ temp
bl printf					@ temp
/*
loop:
@ ldr r0, address_of_word1 @ set r0 as integer read by scan
@ ldr r0, [r1] @ load r0
ldr r0, [r1] @ load r1(input) into r0
vldr s1, [r0] @ load r0 into s1
vcvt.f64.f32 d0, s1 @ convert to 64 bit into d0
@ d0 has user input in 64 bit
vsub.f64 d0, d0, #32 @ perform calculation (d0 - 32) 
sub r6, r6, #1 @ subtract 1 from counter r6
cmp r6, #0 @ branch if r6 > 0
bgt loop

 
@ d1 has float 0.5555 (5/9)
vmul d2, d1, d0 @ perform (5/9) * (user input - 32) into d2
@mov r1, r3, lsr #20 @ shift r3 into r1 ----- do i need to shift d2???

vmov r2, r3, d2 @ load d2 into r2 and r3 to print float
ldr r0, =message2 @ point r0 to message2, display result
bl printf
*/


add sp, sp, #8 				@ adjust stack
@ldr r0, addr_return
@ldr lr, [r0]
pop {r4, r5, r6, lr} 				@ restore pc
bx lr

addr_format_in: .word format_in
addr_word1: .word word1
addr_value1: .word value1
addr_return: .word return

.global printf
.global scanf