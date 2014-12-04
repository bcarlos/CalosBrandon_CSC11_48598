.global main
.func main
main: 
push {r4, lr} @ align with 8 bytes
sub sp, sp, #8 @ make room for one 8 byte integer in the stack

mov r0, #0 @ declare registers
mov r1, #0 @ declare registers
mov r2, #0 @ declare registers
ldr r3, =10000000 @ set loop register to 10,000,000
 
 
/* Remove from the stack and return */
        add sp, sp, #8       @ Discard the integer read by scanf
        pop {r4,lr}
        bx lr