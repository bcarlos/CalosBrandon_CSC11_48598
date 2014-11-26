.data
message1: .asciz " divMod = %d "
message2: .asciz " Float %d conversion = %d "
message3: .asciz " Integer conversion = %d "
message4: .asciz " Integer conversion %d times took: "
message5: .asciz " divMod conversion %d times took: "
message6: .asciz " Float conversion %d times took:"
format: .asciz "%d"

.text

loop:
push { r4, lr}
sub r1, r4, #32				@ counter r4 - 32 goes into r1
mov r0, #5				@ set r0 to mul r1 for numerator
mul r1, r0, r1				@ r1 has numerator for divMod
mov r2, #9				@ r2 has denominator for divMod
bl divMod				@ branch to Divmod
ldr r0, address_of_message1		@ after divMod results displayed r1 can be used
ldr r1, [r0]				@ load result r0 from divMod into r1
bl printf

/*
bl fTemp
ldr r0, address_of_message2
ldr r1, [r4]				@ load counter r4 into r1 / or does it have to be mov??
mov r2, r3				@ mov r3 into r2 for printf
bl printf
*/

bl iTemp
ldr r0, address_of_message3
mov r1, r3				@ mov r3 from iTemp into r1
bl printf
add r4, r4, #5				@ add 5 to counter r4
cmp r4, #212				@ loop till 212
ble loop
pop {r4, lr}
bx lr

/*
fTemp:
push {r4, lr}
mov r0, float(5.0)/9			@ fix
sub r3, r4, #32				@ r3 has (r4(int i) - 32)
mul r3, r0, r3				@ r3 has float c * r3
pop {r4, lr}
bx lr
*/

iTemp:
push {r4, lr}
ldr r1, =0x8E38F
sub r2, r4, #32 			@ r2 has (r4(int i) -32)
mul r3, r1, r2				@ r3 has r1 * r2  >>20???
pop {r4, lr}

iTemp_timed_loop:			@ r0 has counter
push {r4, lr}
mov r4, #212
bl iTemp			
sub r0, r0, #1				@ sub 1 from r0 (counter)
cmp r0, #0 				@ loop with counter r0 til 0????
bgt iTemp_timed_loop
pop {r4, lr}
bx lr

divMod_timed_loop:
push {r4, lr}			
mov r2, #9				@ set the divisor
ldr r1, =900				@ set the numerator
bl divMod 
sub r4, r4, #1				@ sub 1 from the counter
cmp r4, #0
bgt divMod_timed_loop  			@ loop til counter reaches 0
pop {r4, lr}
bx lr

@ divMod- r0 gets #0, r1 has # to be divided, r2 has divisor, r3 gets a 1
@ results are: r0 has the result, r1 the remainder, r2 subtracts r1, r3 has division counter -> r0

/*
fTemp_timed_loop:
push {r4, lr}
mov r4, #212
bl iTemp			
sub r0, r0, #1			@ sub 1 from r0 (counter)
cmp r0, #0 			@ loop with counter r0 til 0????
bgt fTemp_timed_loop
pop {r4, lr}
bx lr
*/

.global main
main:
push {r4, lr}
mov r0, #0				@ empty reg
mov r1, #0				@ r1 has numerator for divMod
mov r2, #9				@ empty reg
mov r3, #0				@ empty reg
mov r4, #32				@ r4 has count for loop (int i), don't change

bl loop

ldr r1, =200000			@ set counter for printf 
ldr r0, address_of_message4
bl start_time			@ branch to start_time where r2 has start time
str r2, [r0]			@ store r2 into r0. need to add #4 to make room for 4 byte int???
ldr r0, =200000			@ set counter for loop function
bl iTemp_timed_loop		@ branch to get time of function
ldr r2, [r0]			@ load r0 into r2
bl end_time			@ branch to end_time where r2 must have start time

ldr r1, =2000			@ set counter for printf (200,000 / 100)
ldr r0, address_of_message5
bl start_time			@ branch to start_time where r2 has start time
str r2, [r0]			@ store r2 into r0. need to add #4 to make room for 4 byte int???
ldr r4, =2000			@ set counter for loop function (200,000 / 100)
bl divMod_timed_loop		@ branch to get time of function
ldr r2, [r0]			@ load r0 into r2
bl end_time			@ branch to end_time where r2 must have start time

/*
ldr r1, =200000			@ set counter for printf
ldr r0, address_of_message6
bl start_time			@ branch to start_time where r2 has start time
str r2, [r0]			@ store r2 into r0. need to add #4 to make room for 4 byte int???
ldr r0, =200000			@ set counter for loop function
bl fTemp_timed_loop		@ branch to get time of function
ldr r2, [r0]			@ load r0 into r2
bl end_time			@ branch to end_time where r2 must have start time
*/

pop {r4, lr}
bx lr

address_of_message1: .word message1
address_of_message2: .word message2
address_of_message3: .word message3
address_of_message4: .word message4
address_of_message5: .word message5
address_of_message6: .word message6
address_of_format: .word format

.global printf
.global start_clock
.global end_clock
.global divMod
