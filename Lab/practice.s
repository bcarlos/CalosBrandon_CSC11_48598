.data
msg_dyn_out: .asciz "The Float = %f \n"
num: .float 0
.text

.global main
.func main
main:

push {r4, lr}
 mov r0, #32
loop:
vmov s0, r0
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
vcvt.f64.f32 d1, s1
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