.data

msg_rules: .asciz "Problem 1. I have a number between 1 and 1000 You will be given 10 guesses."
msg_get_guess: .asciz "Please type your guess: \n"
msg_low: .asciz "Too low.  Try again.\n"
msg_high: .asciz "Too High. Try again.\n"
msg_win: .asciz "Congratulations, You guessed the number!\n"
msg_loose: .asciz "Too many tries.\n"
msg_again: .asciz "Would you like to play again(y or n)?"


rand: .word 0
guess: .word 0
scan_fmt: .asciz "%d"
scan_fmt2: .asciz  " %c"
again: .word 0

.text



make_rand:
	push {r4, lr}

	mov r0,#0			@ set time to 0
    	bl time 
	bl srand
	bl rand
	mov r2, r0, lsr #7		@ move rand into r2, shift right
	vmov s1, r2		@ move into s1
	vcvt.f32.s32 s1, s1 		@ convert

	mov r2, #1000		@ r2 = 1000
	vmov s2, r2 		@ move into s2
	vcvt.f32.s32 s2, s2 		@ convert

	vdiv.f32 s3, s1, s2 		@ s3=s1/s2 */
	 
	
	vmul.f32 s5, s1, s3 		@ multiply into s5 = 1000 * (rand/1000)
	vsub.f32 s6, s1, s5 		@ sub rand - s5 into s6

	vcvt.s32.f32 s6, s6 		@ convert
	vmov r1, s6 		@ move into r1
	str r1,[r6]

	pop {r4, lr}
	bx lr

.text
.align 4
.global guess
.func guess
guess:
	push {r4-r8, lr}
start:
	ldr r6, ad_rand		@ load address of rand
	bl make_rand		@ branch to generate random num

	ldr r0, msg_rules		@ display rules of game
	bl printf			@ print

	ldr r0, msg_get_guess	@ load message to enter a guess from user
	bl printf

	ldr r0, scan_fmt		@ load scan
	ldr r1, ad_guess		@ load into r1
	bl scanf			@ scan
	ldr r2, ad_guess		@ load input address
	ldr r2, [r2]			@ load into r2

	mov r7, #10		@ set number of tries to r7

loop:
	cmp r7, #0			@ compare
	beq exit			@ if equal then exit
	sub r7, r7, #1		@ subtract counter
	ldr r3, ad_rand		@ load address of rand
	ldr r3, [r3]			@ load into r3
	cmp r2, r3			@ compare input with rand
	beq win			@ branch if correct guess
	bne if_not_equal		@ if not then show appropriate message
	
	ldr r0, =msg_high
	bl printf


if_not_equal:
	cmp r2, r3			@ compare input with rand
	bgt too_high		@ if too high branch
	b too_low			@ too low then branch		
too_low:
	ldr r0, =msg_low		@  display too low message
	bl printf			@
	ldr r0, =scan_fmt		@ load scan
	ldr r1, ad_guess		@ load into r1
	bl scanf			@ scan
	ldr r2, ad_guess		@ load input into r2
	ldr r2, [r2]			@ load
	b loop			@ branch
too_high:			
	ldr, =msg_high		@ display too high message
	bl printf			@ print
	ldr r0, =scan_fmt		@ load scan
	ldr r1, ad_guess		@ load into r1
	bl scanf		
	ldr r2, ad_guess		@ load input
	ldr r2, [r2]			@ place into r2
	b loop			@ branch

play_again:
	ldr r0, =msg_again		@ ask user to play again
	bl printf

	ldr r0, =scan_fmt2		@ load scan for char
	ldr r1, ad_again		@ load into r1
	bl scanf			@ scan

	ldr r1, ag_again		@ load address
	ldr r1, [r1]			@ load input into r1

	cmp r1, #'y'		@ compare
	beq start			@ if yes then start over
exit:				@ if != yes then end
	pop {r4 - r8, lr}
	bx lr

win:
	ldr r0, =msg_win		@ display win message
	bl printf
	b play_again		@ branch



.global printf
.global scanf

ad_guess: .word guess
ad_rand: .word rand
ad_again: .word again