.data 
.align 4
float_array: .skip 148
 
.align 4
int_array: .skip 148

.align 4
disp_temp: .asciz "Temp %d fahrenheit = %d celsius\n"
message:     .asciz "Item has value %f \n" 
.text
.globl main

init_array:
    /* Parameters: 
           r0  Number of items
           r1  Address of the array
    */
    push {r5, lr}
 
    /* We have passed all the data by reference */
 
    /* r5 will be incremented from 0 to the end */
    mov r5, #0      /* r5 ? 0 */
 
    b check_loop_array_sum
    loop_array_sum:
	  vmov s0,r5                 /* Prepare for conversion to float */
	  vcvt.f32.s32 s1,s0         /* Convert to single precision float */
	  mov r2, #32		@ prepare to calculate where r2 = 32
	  vmov s2, r2		@ mov r2 into s2 to convert and subtract
	  vcvt.f32.s32 s2, s2	@ convert from single to float
	  vsub.f32 s1, s1, s2	@ subtract into s1=s1(positiont at r5)-s2
	  mov r2, #5		@ prepare to calculate where r2 = 5
	  vmov s2, r2		@ mov r2 into s2 t convert and multiply
	  vcvt.f32.s32 s2, s2	@ convert from single to float
	  vmul.f32 s1, s1, s2	@ mul into s1=s1*s2
	  mov r2, #9		@ prepare to calculate where r2 = 9
	  vmov s2, r2		@ mov r2 into s2 to convert and divide
	  vcvt.f32.s32 s2, s2	@ convert to float
	  vdiv.f32 s1, s1, s2	@ div into s1=s1/s2
	  vmov r6,s1                 /* Move the float back */
	  str r6, [r1, r5, LSL #2]   /*Inititialize the array 0..255 with floats*/
      add r5, r5, #1             /* r5 ? r5 + 1 */
    check_loop_array_sum:
      cmp r5, r0                 /* r5 - r0 and update cpsr */
      bne loop_array_sum       /* if r5 != r0 go to .Lloop_array_sum */
 
    pop {r5, lr}
 
    bx lr
 
@print_each_item_nhex:
@    push {r4, r5, r6, r7, r8, lr} /* r8 is unused */
 
    mov r4, #0      /* r4 ? 0 */
@    mov r5, r0@ r5 should have num of items, r6 should = farray, r7=iarray
@    mov r6, r0      /* r6 ? r0. Keep r0. r6 now has num of items */
@    mov r7, r1      /* r7 ? r1. Keep r1 because we will overwrite it */
@    b check_loop_print_items
@    loop_print_items:
@      ldr r5, [r7, r4, LSL #2]   /* r5 ? *(r7 + r4 * 4) */
@      /* Prepare the call to printf */
@      ldr r0, address_of_message_hex /* first parameter of the call to printf below */
@      mov r1, r4      /* second parameter: item position */
@      mov r2, r5      /* third parameter: item value */
@      bl printf       /* call printf */
 
@      str r5, [r7, r4, LSL #2]   /* *(r7 + r4 * 4) ? r5 */
@      add r4, r4, #1             /* r4 ? r4 + 1 */
@    check_loop_print_items:
@      cmp r4, r6                 /* r4 - r6 and update cpsr */
@      bne loop_print_items       /* if r4 != r6 goto .Lloop_print_items */
 
@    pop {r4, r5, r6, r7, r8, lr}
@    bx lr
	
print_each_item:
    push {r4, r5, r6, r7, r8, lr} /* r8 is unused */
 
    mov r4, #0      /* r4 ? 0 */
    @ mov r5, r0 cuz r5 should have copy of # of items
    mov r6, r0      /* r6 ? r0. Keep r0 because we will overwrite it */
    mov r7, r1      /* r7 ? r1. Keep r1 because we will overwrite it */
 
 
    b check_loop_print_items1
    loop_print_items1:
      ldr r5, [r7, r4, LSL #2]   /* r5 ? *(r7 + r4 * 4) */
	  vmov s0,r5                 /* Prepare for conversion of float */
	  vcvt.f64.f32 d1,s0         /* Convert single to double precision */
 
      /* Prepare the call to printf */
      ldr r0, addr_of_message /* first parameter of the call to printf below */
      vmov r2,r3,d1   /* Prepare to print the double */
      bl printf       /* call printf */
 
      str r5, [r7, r4, LSL #2]   /* *(r7 + r4 * 4) ? r5 */
      add r4, r4, #1             /* r4 ? r4 + 1 */
    check_loop_print_items1:
      cmp r4, r6                 /* r4 - r6 and update cpsr */
      bne loop_print_items1       /* if r4 != r6 goto .Lloop_print_items */
 
    pop {r4, r5, r6, r7, r8, lr}
    bx lr
 
main:
    push {r4, lr}
    /* we will not use r4 but we need to keep the function 8-byte aligned */
	
	/* first call print_each_item */
    mov r0, #256                   /* first_parameter: number of items */
    ldr r1, addr_float_array   /* second parameter: address of the array */
    bl init_array                  /* call to print_each_item */
 
    /* first call print_each_item in hex for float */
@    mov r0, #256                   /* first_parameter: number of items */
@    ldr r1, address_of_big_array   /* second parameter: address of the array */
@    bl print_each_item_nhex        /* call to print_each_item */
	
	/* second call print_each_item as a float */
    mov r0, #256                   /* first_parameter: number of items */
    ldr r1, addr_float_array   /* second parameter: address of the array */
    bl print_each_item             /* call to print_each_item */
 
    pop {r4, lr}
    bx lr
 
addr_float_array :   .word float_array
addr_disp_temp : .word disp_temp
addr_of_message:      .word message
