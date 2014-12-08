.data

.align 4
Farray: .skip 148 		@ skip 36*4 bytes and +4 bytes

.align 4
Carray: .skip 148		@ skip 36*4 bytes and +4 bytes

.align 4
msg: .asciz "Temperature %d F equals to :%f C\n"
@ first param should be int and second should be float

.text

F_array:
/* r0: # of items;
   r1: address of the array */
        push {r5, r6, r7, lr}
        mov r5, #0
        b check_loop_Farray
loop_Farray:
        mov r6, #32
        add r7, r5, r5, lsl #2
        add r6, r6, r7
        str r6, [r1, r5, lsl #2]
        add r5, r5, #1
check_loop_Farray:
        cmp r5, r0
        ble loop_Farray
        pop {r5, r6, r7, lr}
        bx lr

C_array:
/* r0: # of items;
    r1: address of the Carray, r3: address of Farray */
        push {r3, r4, r6, r7, lr}
        mov r4, #0
@		ldr r7, =0x8e38f
        b check_loop_Carray
loop_Carray:
        ldr r6, [r3, r4, lsl #2]	@ r3 has Farray
		@ perform calculation of temp
		vmov s0, r6					@ float conversion of num in array
		vcvt.f32.s32 s1, s0			@ convert to single precision f
		mov r2, #32					@ prepare sub calculation
		vmov s2, r2           		@ mov r2 into s2 to convert and sub
		vcvt.f32.s32 s3, s2   		@ convert from single to float
		vsub.f32 s1, s1, s3   		@ subtract into s1=s1(positiont at r4)-s3
		mov r2, #5            		@ prepare to vmul where r2 = 5
		vmov s2, r2           		@ mov r2 into s2 to convert
		vcvt.f32.s32 s3, s2   		@ convert from single to float
		vmul.f32 s1, s1, s3   		@ mul into s1=s1*s3
		mov r2, #9            		@ prepare to calculate where r2 = 9
		vmov s2, r2           		@ mov r2 into s2 to convert and divide
		vcvt.f32.s32 s3, s2   		@ convert to float
		vdiv.f32 s1, s1, s3   		@ div into s1=s1/s3
        vmov r6, s1
	
		str r6, [r1, r4, lsl #2]	@ r1 has Carray
        add r4, r4, #1
check_loop_Carray:
        cmp r4, r0
        ble loop_Carray
        pop {r3, r4, r6, r7, lr}
        bx lr

print_F_and_C:
        push {r4, r5, r6, r7, lr}
        mov r4, #0 					@ r4 = counter
		mov r5, r0 					@ copy of # of items
        mov r6, r1 					@ save a copy of array F
        mov r7, r2 					@ save a copy of array C
        b check_loop_print_array
loop_print_array:
		ldr r0, disp_msg
        ldr r1, [r6, r4, lsl #2]
		ldr r2, [r7, r4, lsl #2]
        bl printf
        add r4, r4, #1 				@ increase counter by 1
check_loop_print_array:
        cmp r4, r5
        ble loop_print_array
        pop {r4, r5, r6, r7, lr}
        bx lr

.global main
.func main
main:
	push {r4, lr}

	mov r0, #36						@ r0 = num of items
	ldr r1, ad_Farray				@ r1 contains array address
	bl F_array						@ branch to fill array function
	
	mov r0, #36						@ r0 = num of items	
	ldr r3, ad_Farray				@ r3 contains F array address
	ldr r1, ad_Carray				@ r1 contains C array address
	bl C_array						@ branch to fill array function

	mov r0, #36						@ r0 = num of items (counter)
	ldr r1, ad_Farray				@ r1 contains F array address
	ldr r2, ad_Carray				@ r2 contains C array address
	bl print_F_and_C				@ branch to print function
	
	pop {r4, lr}
	bx lr
.global scanf
.global printf
disp_msg: .word msg
ad_Farray: .word Farray
ad_Carray: .word Carray