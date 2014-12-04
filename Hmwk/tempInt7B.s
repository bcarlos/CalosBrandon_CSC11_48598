.data
message1: .asciz "Type a number to convert to Celsius: "
format: .asciz "%d"
message2: .asciz "The conversion is: %d  \n"
word1: .word 0
word2: .word 0x8E38F

.text

scale:
add r5, r5, #1
bl loop

.global main
main:
push {lr}
sub sp, sp, #4			@ make room for a word on the stack

ldr r0, address_of_message1	/* Set &message1 as the first parameter of printf */
bl printf                   	/* Call printf */

ldr r0, address_of_format  	/* Set &format as the first parameter of scanf */
ldr r1, address_of_word1	@ set r1 as the input 
bl scanf

mov r5, #1			@ set loop
ldr r6, =10000000		@ end loop

loop:
ldr r0, address_of_word1	@ load integer read into r0
ldr r0, [r0]			@ load into r0
sub r0, r0, #32			@ calculate f - 32
cmp r6, r5			@ compare and loop
bgt scale

ldr r1, address_of_word2	@ load 5/9 integer
ldr r1, [r1]			@ load
mul r3, r1, r0			@ multiply input by r1
mov r1, r3, lsr #20		@ mov to first scanf parameter and shift

ldr r0, address_of_message2
bl printf


add sp, sp, #4			@ adjust stack
pop {lr}			@ restore pc
bx lr

address_of_message1: .word message1
address_of_message2: .word message2
address_of_format: .word format
address_of_word1: .word word1
address_of_word2: .word word2
.global printf
.global scanf
