.data
vel:         .float 0        @Velocity (ft/sec)
half:        .float 0.5      @Just 1/2 constant
rho:         .float 0.00237  @Density  slugs/ft^3
dynP:        .float 0        @Dynamic Pressure (lbs/ft^2)
msg_vel_in:  .asciz "Enter the Velocity in (ft/sec) \n"
msg_vel_out: .asciz "The Velocity = %f (ft/sec) \n"
msg_dyn_out: .asciz "The Dynamic Pressure = %f (lbs/ft^2) \n"
fmt_flt:     .asciz "%f"

/* Start Main */
.text
.global main 
.func main 
main: 
	push {r4,lr}           @ Align with 8 bytes

	/* Prompt for the Velocity */
	ldr r0,ad_msg_vel_in   @Message for velocity input
	bl printf

	/* Input the Velocity */
	ldr r0,ad_fmt_flt      @Single float format
	ldr r1,ad_vel          @Load the velocity address
	bl scanf               @Store value in the velocity address

	/* Test Convert the Velocity to a double format */
	ldr  r1,ad_vel
	vldr s0,[r1]
	vcvt.f64.f32 d1,s0
	
	/* Output the Velocity in double format */
	ldr r0,ad_msg_vel_out
	vmov r2,r3,d1
	bl printf
	
	/* Load 1/2 rho and vel into the floating registers */
	ldr  r0,ad_half
	vldr s0,[r0]
	ldr  r0,ad_rho
	vldr s1,[r0]
	ldr  r0,ad_vel
	vldr s2,[r0]
	
	/* Calculate 1/2 rho vel^2 */
	vmul.f32 s3,s0,s1
	vmul.f32 s3,s3,s2
	vmul.f32 s3,s3,s2
	
	/* Store the dynamic pressure for later use */
	ldr r0,ad_dynP
	vmov r1,s3
	str r1,[r0]
	
	/* Test Convert the Dynamic Pressure to a double format */
	ldr  r1,ad_dynP
	vldr s0,[r1]
	vcvt.f64.f32 d1,s0
	
	/* Output the Dynamic Pressure in double format */
	ldr r0,ad_msg_dyn_out
	vmov r2,r3,d1
	bl printf             

	/* Exit stage right */
	pop {r4,lr}
	bx lr

.global printf
.global scanf

ad_msg_vel_in: .word msg_vel_in
ad_msg_vel_out:.word msg_vel_out
ad_msg_dyn_out:.word msg_dyn_out
ad_fmt_flt:    .word fmt_flt
ad_vel:        .word vel
ad_half:       .word half
ad_rho:        .word rho
ad_dynP:       .word dynP