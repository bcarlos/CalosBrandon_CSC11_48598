.data
/* Fill an array of Fahrenheit values from 32 to 212 in increments of 5 degrees
   Which means skipping every 5 numbers -> (212-32)/5=36 items */
.align 4
array_F: .skip 148 /* Each integer requires 4 bytes, therefore skipping 36*4+4 bytes */

.align 4
array_C: .skip 148

.align 4
msg: .asciz "Temperature %d °F equals to :%d °C\n"
.text

Array_F:
/* r0: # of items;
   r1: address of the array */
        push {r5, r6, r7, lr}
        mov r5, #0
        b check_loop_array_F
loop_array_F:
        mov r6, #32
        add r7, r5, r5, lsl #2
        add r6, r6, r7
        str r6, [r1, r5, lsl #2]
        add r5, r5, #1
check_loop_array_F:
        cmp r5, r0
        ble loop_array_F
        pop {r5, r6, r7, lr}
        bx lr

Array_C:
/* r0: # of items;
    r1: address of the array */
        push {r3, r4, r6, r7, lr}
        mov r4, #0
		ldr r7, =0x8e38f
        b check_loop_array_C
loop_array_C:
        ldr r6, [r3, r4, lsl #2]
		sub r6, r6, #32
		mul r6, r6, r7
		mov r6, r6, lsr #20
		str r6, [r1, r4, lsl #2]
        add r4, r4, #1
check_loop_array_C:
        cmp r4, r0
        ble loop_array_C
        pop {r3, r4, r6, r7, lr}
        bx lr

print_F_and_C:
        push {r4, r5, r6, r7, lr}
        mov r4, #0 /* counter */
		mov r5, r0 /* save a copy of # of items */
        mov r6, r1 /* save a copy of the array F */
        mov r7, r2 /* save a copy of the array C */
        b check_loop_print_array
loop_print_array:
		ldr r0, =msg
        ldr r1, [r6, r4, lsl #2]
		ldr r2, [r7, r4, lsl #2]
        bl printf
        add r4, r4, #1 /* increase counter by 1 */
check_loop_print_array:
        cmp r4, r5
        ble loop_print_array
        pop {r4, r5, r6, r7, lr}
        bx lr

.global main
main:
        push {r4, lr}

/* fill array F */
        mov r0, #36
        ldr r1, =array_F
        bl Array_F


/* fill array C */
mov r0, #36
ldr r3, =array_F
ldr r1, =array_C
bl Array_C

/* print both arraies */
mov r0, #36
ldr r1, =array_F
ldr r2, =array_C
bl print_F_and_C

        pop {r4, lr}
        bx lr
.global printf