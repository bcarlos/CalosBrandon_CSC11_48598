.data
message1: .asciz "Type a number to convert to Celsius: "
format: .asciz "%d"
message2: .asciz "The conversion is: %d   with remainder: %d\n"
message3: .asciz "Type a number between 32 and 212: \n"

.text

try_again:
push {lr}
sub sp, sp, #4
ldr r0, address_of_message3
bl printf

ldr r0, address_of_format
mov r1, sp
bl scanf
ldr r4, [sp]
/*
cmp r4, #32
blt try_again
cmp r4, #212
bgt try_again
*/
add sp, sp, #4
pop {lr}
bx lr

.global main
main:
push {lr}
sub sp, sp, #4			@ make room for a word on the stack

ldr r0, address_of_message1	/* Set &message1 as the first parameter of printf */
bl printf                    	/* Call printf */

ldr r0, address_of_format    	/* Set &format as the first parameter of scanf */
mov r1, sp			@ set r1 as the input 
bl scanf

ldr r4, [sp]			@ r4 contains input
cmp r4, #32
blt try_again
cmp r4, #212
bgt try_again

mov r3, #0
mov r1, #5
sub r4, r4, #32
mul r0, r4, r1
mov r1, r0
mov r2, #9
mov r0, #0
bl divMod
/* branch to divmod with input in r1, divisor in r2
result will be in r0 with remainder in r1 */

ldr r1, [r0]
ldr r2, [r1]
ldr r0, address_of_message2
bl printf


add sp, sp, #4			@ adjust stack
pop {lr}			@ restore pc
bx lr

address_of_message1: .word message1
address_of_message2: .word message2
address_of_format: .word format
address_of_message3: .word message3
.global printf
.global scanf
.global divMod
