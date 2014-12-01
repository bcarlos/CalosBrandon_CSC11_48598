.data
message1: .asciz "Type a number to convert to Celsius: "
format: .asciz "%d"
message2: .asciz "The conversion is: %d   with remainder: %d\n"
message3: .asciz "Type a number between 32 and 212: \n"
.text

.global main
main:
push {lr}
ldr r0, address_of_message1		/* Set &message1 as the first parameter of printf */
bl printf                    	/* Call printf */

ldr r0, address_of_format    	/* Set &format as the first parameter of scanf */
mov r1, sp
bl scanf

ldr r0, [sp]
printf


pop {lr}
bx lr

address_of_message1: .word message1
address_of_message2: .word message2
address_of_format: .word format
address_of_message3: .word message3
.global printf
.global scanf