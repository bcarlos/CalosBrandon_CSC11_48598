.data
cd:          .float 0.4      @ fCd value
conv:        .float 455.0    @ fConv value
rad:         .float 6.0      @ fRad value
pi:	     .float 3.14159  @ fPi value
vel:         .float 200.0    @ Velocity (ft/sec)
half:        .float 0.5      @ Just 1/2 constant
rho:         .float 0.00237  @ Density  slugs/ft^3
dynP:        .float 0        @ Dynamic Pressure (lbs/ft^2)
area:        .float 0 	     @ Area
drag:        .float 0        @ Drag
msg_drag_out:.asciz "The Float Drag X 32 = %f lbs \n"
msg_area_out:.asciz "The Float Area X 32 = %f ft^2 \n"
msg_dyn_out: .asciz "The Float Dynamic Pressure = %f (lbs/ft^2) \n"
msg_loop_out:.asciz "The number of loops = %d \n"
fmt_flt:     .asciz "%f"

@msg_vel_in: .asciz "Enter vel\n"
@msg_vel_out:.asciz "Dyn pressure = %f \n"
/* Start Main */
.text
.global main 
.func main 
main: 
	push {r4,lr}           @ Align with 8 bytes

	/* Prompt for the Velocity */
@	ldr r0,ad_msg_vel_in   @Message for velocity input
@	bl printf

	/* Input the Velocity */
@	ldr r0,ad_fmt_flt      @Single float format
@	ldr r1,ad_vel          @Load the velocity address
@	bl scanf               @Store value in the velocity address

	/* Test Convert the Velocity to a double format */
	ldr  r1,ad_vel
	vldr s0,[r1]
	vcvt.f64.f32 d1,s0
	
	/* set loop r3 to 10,000,000 */
	ldr r3, =10000000
		loop:
		/* Load 1/2 rho and vel into the floating registers */
		ldr  r0,ad_half
		vldr s0,[r0]
		ldr  r0,ad_rho
		vldr s1,[r0]
		ldr  r0,ad_vel
		vldr s2,[r0]
	
		/* Calculate 1/2 rho vel^2 */
		vmul.f32 s3,s0,s1	@ s3 = fHalf * fRho
		vmul.f32 s3,s3,s2	@ s3 *= fVel
		vmul.f32 s3,s3,s2	@ s3 *= fVel
	
		/* Store the dynamic pressure for later use */
		ldr r0,ad_dynP
		vmov r1,s3
		str r1,[r0]

		/* Load fPi, fRad, fConv, into fp registers */
		ldr r0, ad_pi
		vldr s0, [r0]
		ldr r0, ad_rad
		vldr s1, [r0]
		ldr r0, ad_conv
		vldr s2, [r0]

		/* Calculate */
		vmul.f32 s3, s0, s1	@ s3 = fPi * fRad
		vmul.f32 s3, s3, s1	@ s3 *= fRad
		vmul.f32 s3, s3, s2	@ s3 *= fConv

		/* Store Area */
		ldr r0, ad_area
		vmov r1, s3
		str r1, [r0]
	
		/* Convert the Dynp, area, drag to a double format */
		ldr  r1,ad_dynP
		vldr s0,[r1]
		vcvt.f64.f32 d1,s0
		ldr r1, ad_area
		vldr s0, [r1]
		vcvt.f64.f32 d2, s0
		ldr r1, ad_drag
		vldr s0, [r1]
		vcvt.f64.f32 d3, s0

		/* Vmul drag = dynp * area */
		vmul.f64 d3, d1, d2
	
		/* subtract loop counter and branch if != 0 */
		sub r3, r3, #1
		cmp r3, #0
		bgt loop

	/* Output the Dynp, area, and drag in double format */
	ldr r0,ad_msg_dyn_out
	vmov r2,r3,d1
	bl printf             
	
	ldr r0, ad_msg_area_out
	vmov r2, r3, d2
	bl printf

	ldr r0, ad_msg_drag_out
	vmov r2, r3, d3
	bl printf

	/* Exit stage right */
	pop {r4,lr}
	bx lr

.global printf
.global scanf

@ad_msg_vel_in: .word msg_vel_in
@ad_msg_vel_out:.word msg_vel_out

ad_msg_drag_out: .word msg_drag_out
ad_msg_area_out:.word msg_area_out
ad_msg_dyn_out:.word msg_dyn_out
ad_msg_loop_out:.word msg_loop_out
ad_fmt_flt:    .word fmt_flt
ad_vel:        .word vel
ad_half:       .word half
ad_rho:        .word rho
ad_dynP:       .word dynP
ad_pi:         .word pi
ad_rad:        .word rad
ad_conv:       .word conv
ad_cd:         .word cd
ad_area:       .word area
ad_drag:       .word drag
