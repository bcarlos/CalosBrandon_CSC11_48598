.data
msg1: .asciz " Integer dynamic pressure = %f lbs \n "
msg2: .asciz " Cross sectional area x 32 = %f ft^2 \n"
msg3: .asciz " Integer drag x 32 %f lbs \n"
msg4: .asciz " Loops : %d \n" @ loops is digit not float

value0: .float 0.00237 @ fRho
value1: .float 3.14159 @ fPi
value2: .float 6.0 @ fRad
value3: .float 455.0 @ fConv
value4: .float 0.4 @ fCd
value5: .float 0.5 @ fHalf
value6: .float 200.0 @ fVel
value7: .float 0 @ fDynp, convert to 64bit to display
value8: .float 0 @ fArea, convert to 64 bit to display
value9: .float 0 @ fDrag, convert to 64 bit to display
.text

.global main
.func main
main: 
push {r4, lr} @ align with 8 bytes
sub sp, sp, #8 @ make room for one 8 byte integer in the stack

mov r0, #0 @ declare registers
mov r1, #0 @ declare registers
mov r2, #0 @ declare registers
ldr r3, =10000000 @ set loop register to 10,000,000
 

/* First calculation fHalf, fRho, fVel into fDynp (d0) */
ldr  r0, addr_value5 @ fHalf
vldr s0, [r0] @ load into s0
ldr  r0, addr_value0 @ fRho
vldr s1, [r0] @ load into s1
ldr  r0, addr_value6 @ fVel
vldr s2, [r0] @ load into s2
 
/* Remove from the stack and return */
        add sp, sp, #8       @ Discard the integer read by scanf
        pop {r4,lr}
        bx lr
		
addr_value0: .word value0
addr_value1: .word value1
addr_value2: .word value2
addr_value3: .word value3
addr_value4: .word value4
addr_value5: .word value5
addr_value6: .word value6
addr_value7: .word value7
addr_value8: .word value8
addr_value9: .word value9

addr_msg1: .word msg1
addr_msg2: .word msg2
addr_msg3: .word msg3
addr_msg4: .word msg4