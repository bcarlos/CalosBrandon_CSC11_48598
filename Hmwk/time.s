.data
message: .asciz "start time is %d"
message2: .asciz "end time is %d"
message3: .asciz "difference is %d"
.text

.global start_clock
start_clock:
mov r0, #0
bl time
mov r1, r0
ldr r0, address_of_message
bl printf
mov r5, r1
bx lr

.global end_clock
end_clock:
mov r0, #0
bl time
mov r6, r0
ldr r0, address_of_message2
bl printf
sub r1, r6, r5
ldr r1, [r1]
ldr r0, address_of_message3
printf
bx lr

address_of_message: .word message
address_of_message2: .word message2
address_of_message3: .word message3

.global time