.data
message: .asciz " Start time is %d "
message2: .asciz " End time is %d "
message3: .asciz " Difference is %d "
.text

.global start_clock
start_clock:
mov r0, #0				@ set r0 for time
bl time
mov r1, r0				@ move time into r1
ldr r0, address_of_message
bl printf
mov r2, r1				@ r2 has start time
bx lr

.global end_clock
end_clock:
mov r0, #0				@ set r0 for time
bl time
mov r1, r0				@ move time into r1
ldr r0, address_of_message2		@ print r1 end time
bl printf
sub r1, r0, r2			@ subtract r0 (end) - r2 (start) into r1 
ldr r0, address_of_message3
bl printf				@ print r1 (difference in time)
bx lr

address_of_message: .word message
address_of_message2: .word message2
address_of_message3: .word message3

.global time
.global printf