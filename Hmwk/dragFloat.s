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
 
loop:
/* First calculation fHalf, fRho, fVel into fDynp (d0) */
ldr  r0, addr_value5 @ fHalf
vldr s0, [r0] @ load into s0
ldr  r0, addr_value0 @ fRho
vldr s1, [r0] @ load into s1
ldr  r0, addr_value6 @ fVel
vldr s2, [r0] @ load into s2
 
vmul.f32 s3,s0,s1 @ s3 = fHalf * fRho
vmul.f32 s3,s3,s2 @ s3 *= fVel
vmul.f32 s3,s3,s2 @ s3 *= fVel
 
ldr r0, addr_value6 @ dynp address into r0
vmov r1, s3 @ s3 into r1
str r1, [r0] @ r1 into r0

ldr r1, addr_value6 @ store fDynp to display later
vldr s0, [r1] @ load to s0
vcvt.f64.f32 d0, s0 @ convert to 64 bit into d0

/* second calculation fPi, fRad, fConv into fArea (d1)
ldr  r0, addr_value1 @ fPi
vldr s0, [r0] @ load into s0
ldr  r0, addr_value2 @ fRad
vldr s1, [r0] @ load into s1
ldr  r0, addr_value3 @ fConv
vldr s2, [r0] @ load into s2
 
vmul.f32 s3,s0,s1 @ s3 = fPi * fRad
vmul.f32 s3,s3,s1 @ s3 *= fRad
vmul.f32 s3,s3,s2 @ s3 *= fConv
 
ldr r0, addr_value7 @ area address into r0
vmov r1, s3 @ s3 into r1
str r1, [r0] @ r1 into r0

ldr r1, addr_value7 @ convert fArea to double format to display
vldr s0, [r1] @ load
vcvt.f64.f32 d1, s0 @ convert to 64 bit into d1
 
/* third calculation (d2) fDrag = fDynp (d0) * fArea (d1)
ldr r0, addr_value @ fCd
vldr s0, [r0] @ load into s0
vcvt.f64.f32 d2, s0 @ convert to 64bit into d2
vmul.f64 d2,d0,d1 @ fDrag = fDynp * fArea
 
sub r3, r3, #1 @ subtract counter
cmp r3, #0 @ compare and branch
bgt loop

/* Output the Dynamic Pressure in double format */
ldr r0, addr_msg1
vmov r2, r3, d0
bl printf

/* Output the Area in double format */
ldr r0, addr_msg2
vmov r2, r3, d1
bl printf

/* Output the Drag in double format */
ldr r0, addr_msg3
vmov r2, r3, d2
bl printf

/* Output Loops in Int format */
ldr r0, addr_msg4
mov r1, r3 @ r3 will be 0? 
bl printf

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
