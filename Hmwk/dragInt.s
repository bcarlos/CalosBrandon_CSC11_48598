.data

message1: .asciz " Integer dynamic pressure = %d lbs \n "
message2: .asciz " Cross sectional area x 32 = %d ft^2 \n"
message3: .asciz " Integer drag x 32 %d lbs \n"
message4: .asciz " Loops : %d \n"
message5: .asciz " Time = %d secs \n"

word1: .word 0x9B5		@ iRho
word2: .word 0x3243F7		@ iPi
word3: .word 0x1C7		@ iConv
word4: .word 0x666		@ iCd

.text

.global main
main:
push {r4, r5, r6, lr}

mov r0, #0
mov r1, #0 			@ declare endTime variable
mov r2, #0			@ declare begTime variable
mov r3, #0			@ declare iDynp
mov r4, #0 			@ declare iArea
mov r5, #0 			@ declare iDrag
mov r6, #0 			@ empty reg

@ bl start_clock

@ mov r0, #10			@ nLoops
@ loop:
@  push {r4, r5, r6, lr}
@  sub sp, sp, #4
mov r3, #1
ldr r6, address_of_word1	@ iRho
ldr r6, [r6]
mul r3, r6, r3 			@ iRho * r3 (iDynp)
mov r6, #200	 		@ iVel = 200
mul r3, r6, r3 			@ iVel * r3
mul r3, r6, r3 			@ iVel * r3
mov r3, r3, lsr #12 		@ shift right by 12

ldr r4, address_of_word2	@ iArea = iPi
ldr r4, [r4]
mov r6, #6			@ iRad
mul r4, r6, r4 			@ iRad * r4 (iArea)
mul r4, r6, r4 			@ iRad * r4 (iArea)
mov r4, r4, lsr #12 		@ shift right by 12

ldr r6, address_of_word3	@ iConv
ldr r6, [r6]
mul r4, r6, r4 			@ r4 * iConv
mov r4, r4, lsr #16 		@ shift right by 16
mul r5, r4, r3 			@ iDrag = iArea * iDynp
mov r5, r5, lsr #12 		@ shift right by 12

ldr r6, address_of_word4	@ iCd
ldr r6, [r6]
mul r5, r6, r5 			@ iCd * iDrag

@ sub r0, r0, #1
@ cmp r0, #0
@ bgt loop
@  add sp, sp, #4
@  pop {r4, r5, r6, lr}

@ bl end_clock
@ str r1, [r1]			@ store end time in r1

ldr r0, address_of_message1 	@ display iDynp
mov r1, r3
bl printf

ldr r0, address_of_message2 	@ display iArea
mov r1, r4
bl printf

ldr r0, address_of_message3 	@ display iDrag
mov r1, r5
bl printf

@ ldr r0, address_of_message4 	@ display nLoops
@ mov r1, r0
@ bl printf

@ ldr r0, address_of_message5 	@ display time
@ ldr r1, [r1]			@r1 has endTime - begTime  
@ bl printf

pop {r4, r5, r6, lr}
bx lr

address_of_message1: .word message1
address_of_message2: .word message2
address_of_message3: .word message3
address_of_message4: .word message4
address_of_message5: .word message5

address_of_word1: .word word1
address_of_word2: .word word2
address_of_word3: .word word3
address_of_word4: .word word4

.global printf
.global start_clock
.global end_clock
