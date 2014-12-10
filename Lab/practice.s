.data
msg_dyn_out: .asciz "The Float = %f \n"
num_32:		.float 32.0
five:         .float 5.0       @Velocity (ft/sec)
nine:        .float 9.0      @Just 1/2 constant
num: .float 62.0
.text

.global main
.func main
main:

push {r4, lr}

loop:
	ldr r0, =num
	vldr s0, [r0]
	ldr r0, =num_32
	vldr s1, [r0]
	ldr r0, =five
	vldr s2, [r0]
	ldr r0, =nine
	vldr s3, [r0]
	
	vsub.f32 s0, s0, s1
	vmul.f32 s0, s0, s2
	vdiv.f32 s0, s0, s3
	
	ldr r0, =num
	vmov r1, s0
	str r1, [r0]
	
	ldr r1, =num
	vldr s0, [r1]
	vcvt.f64.f32 d1, s0
	
	ldr r0, =msg_dyn_out
	vmov r2, r3, d1
	bl printf

/*
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
	*/	
		/* Store the dynamic pressure for later use */
         @       ldr r0, =num
          @		  vmov r1,s1
           @     str r1,[r0]
				
				
		 /* Output the Dynp, area, and drag in double format */		
		@ldr r0,ad_msg_dyn_out
        @vmov r2,r3,d1
        @bl printf
		
		
pop {r4, lr}
bx lr

ad_msg_dyn_out:.word msg_dyn_out