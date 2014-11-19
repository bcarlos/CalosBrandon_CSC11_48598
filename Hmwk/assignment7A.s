.data
message1: .asciz "Type a number to convert to Celsius: "
format: .asciz "%d"
message2: .asciz "The conversion is: %d   with remainder: %d\n"
message3: .asciz "Type a number between 32 and 212: \n"
.text

try_again:
push {lr}
ldr r0, address_of_message3		/* Set &message3 as the first parameter of printf */
bl printf						/* call printf */ 
ldr r0, address_of_format    	/* Set &format as the first parameter of scanf */
mov r1, sp                  	/* Set the top of the stack as the second parameter */
								/* of scanf */
bl scanf                     	/* Call scanf */
ldr r4, [sp]                 	/* Load the integer read by scanf into r4 */
cmp r4, #32
blt try_again
cmp r4, #212
bgt try_again
pop{lr}
bx lr							/* leave function try_again

.global main
main:
push {lr}
ldr r0, address_of_message1		/* Set &message1 as the first parameter of printf */
bl printf                    	/* Call printf */
 
ldr r0, address_of_format    	/* Set &format as the first parameter of scanf */
mov r1, sp                  	/* Set the top of the stack as the second parameter */
								/* of scanf */
bl scanf                     	/* Call scanf */
ldr r4, [sp]                 	/* Load the integer read by scanf into r4 */
cmp r4, #32						/* If input is lower than 32 branch to try_again */
blt try_again
cmp r4, #212					/* if input is higher than 212 branch to try_again */
bgt try_again

mov r1, #5
mov r2, #9
sub r4, r4, #32
mul r1, r1, r4
bl divMod 						/* Branch to divMod with input in r1, divisor in r2 */
								/* result will be in r0 with remainder in r1 */
								/* r1 has remainder */

ldr r0, address_of_message2 	/* Set &message2 as the first parameter of printf */
ldr r1, [r0] 					/* load results onto registers */
ldr r2, [r1]
bl printf                     	/* Call printf */
 
pop {lr}
bx lr

address_of_message1: .word message1
address_of_message2: .word message2
address_of_format: .word format
address_of_message3: .word message3