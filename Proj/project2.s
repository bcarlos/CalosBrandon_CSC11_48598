.data

user_cards: .asciz "User's cards: 1: %f , 2: %f \n"
cp_cards: .asciz "Computer's cards: 1: %f , 2: %f \n"
msg_welcome: .asciz "Welcome to card attack. Enter 1 to play, anything else to exit: \n"
msg_choose1: .asciz "Choose your card that you want to use to attack (1 or 2 respectively): \n"
msg_choose2: .asciz "Choose computer's card you want to attack (1 or 2 respectively): \n" 
cp_loose: .asciz "Computer looses! \n"
user_loose: .asciz "You loose \n"
int_format: .asciz "%d"
flt_format: .asciz "%f"
user_lt_card: .float 0.0 		@ user's first card (left card)
user_rt_card: .float 0.0 		@ user's second card (right card)
cp_lt_card: .float 0.0 			@ computer's first card (left card)
cp_rt_card: .float 0.0 			@ computer's second card (right card)
zero: .float 0.0 				@ set to 0 to compare

.text
 
.global main
.func main
main:
  push {r4, r5, r6, r7, lr}
sub sp, sp, #16 @ make room on the stack

ldr r0, addr_msg_welcome @ display welcome message
bl printf

ldr r0, addr_int_format   @ take users input as int format
mov r1, sp @ set r1 as input
bl scanf @ scan user int
ldr r1, [sp] @ load integer 
cmp r1, #1 @ compare with 1
beq create_cards   @ if input = 1 then start program
bne _end   @ if r1!=1 then end program

@ break here and check code

rand_num:
mov r0, #0 @ Set time to 0
bl time @ Call time
bl srand @ Call srand
bl rand @ Call rand 
mov r1, r0, ASR #1 @ in case random return is negative
mov r2,#90 @ move 90 to r2
                        /* We want rand()%90+10 so cal divMod with rand()%90 */
bl divMod @ call divMod function to get remainder
add r1,#10 @ remainder in r1 so add 10 giving between 10 and 99 -> 2 digits
@ check if random number gen works by displaying the digit
bx lr @ leave rand_num

create_cards:
    bl rand_num
mov r4, r1 @ user's card r4 moded by 5
    and r4, r4, #5             @ user's cards r4 & r5
ldr r0, addr_user_lt_card @ load address for user card float
vmov r1, r4 @ vmov r4 into r1
str r1, [r0]   @ store r1 into float address

bl rand_num
mov r5, r1 @ user's card r5
and r5, r5, #5 @ mod by 5
ldr r0, addr_user_rt_card @ load address for user card float
vmov r1, r5 @ vmov r5 into r1
str r1, [r0] @ store r1 into float address
 
bl rand_num
mov r6, r1 @ computer's card r6
and r6, r6, #5 @ mod by 5
ldr r0, addr_cp_lt_card @ load address for cp card float
vmov r1, r6 @ vmov r6 into r1
str r1, [r0] @ store r1 into float address

bl rand_num
mov r7, r1 @ computer's card r7
and r7, r7, #5 @ computer's cards r6 & r7
ldr r0, addr_cp_rt_card @ load address for cp card float
vmov r1, r7 @ vmov r7 into r1
str r1, [r0] @ store r1 into float address
   
ldr  r1, addr_user_lt_card @ load address for user left card
vldr s0, [r1] @ load into s0
vcvt.f64.f32 d1, s0 @ convert to double format into d1
ldr  r1, addr_user_rt_card @ load address for user right card
vldr s0, [r1] @ load into s0
vcvt.f64.f32 d2, s0 @ convert to double format into d2
ldr  r1, addr_user_lt_card @ load address for cp left card
vldr s0, [r1] @ load into s0
vcvt.f64.f32 d3, s0 @ convert to double format into d3
ldr  r1, addr_user_rt_card @ load address for cp right card
vldr s0, [r1] @ load into s0
vcvt.f64.f32 d4, s0 @ convert to double format into d4
 
ldr r0, disp_user_cards @ load display user cards message
vmov r2, r3, d1 @ vmov d1 to display
str d2, [sp] @ store d2 onto the stack to display
bl printf
ldr r0, disp_cp_cards @ load display cp cards message
vmov r2,r3,d3 @ vmov d3 to display
str d4, [sp] @ store d4 onto the stack to display
bl printf
   
ldr r0, addr_user_lt_card
vldr s0,[r0] @ load user lt card into s0
ldr r0, addr__user_rt_card
vldr s1, [r0] @ load user rt card into s1
ldr r0, addr_cp_lt_card
vldr s2, [r0] @ load cp lt card into s2
ldr r0, addr_cp_rt_card
vldr s3, [r0] @ load cp rt card into s3

bl player_move
@ break here and check if code works

 

    player_move:
@ ldr r0, =zero @ load float 0 to compare
@ vldr s4, [r0] @ load into s4
@ load float 0 or just set to 0?? @vmov s4, #0
@ just cmp to 0 or float 0?? vcmp.f32 s0, #0 @ check user's lt card in s0
@ vcmp.f32 s0, s4 @ check user's lt card with 0 (s4)
  ble user_card_check @ if 0 then branch to check other card
    ldr r0, addr_msg_choose1 @ load message to choose user card
    bl printf @ display message
    ldr r0, address_of_format
    mov r1, sp @ set r1 to take input
    bl scanf
    ldr r1, [sp] @ load int to check user input
    cmp r1, #1
    beq attack_from_left @ if r1 = 1 then left card chosen
    bne attack_from_right @ if r1 != 1 right card chosen

    user_card_check:
vcmp.f32 s1, s4 @ check other card
@ load or just cmp to 0??   vcmp.f32 s1, #0 @ check other card
    ble user_loose @ branch if both empty
bx lr @ leave if s1 not empty
   
attack_from_left: @ user's car (r4) to attack
    ldr r0, addr_msg_choose2 @ load message to choose enemy card
    bl printf @ print message
    ldr r0, addr_int_format @ int format input
    mov r1, sp @ set r1 to take input
    bl scanf @ call scanf
    ldr r1, [sp] @ load input into r1
    cmp r1, #1 @ check user input
    vsubeq.f32 s2, s2, s0 @ if r1 = 1 then sub computer's card s2
    vsubne.f32 s3, s3, s0 @ if r1!=1 then sub computers card s3
    bl computer_move @ computer's turn

    attack_from_right: @ user's card (r5) to attack
    ldr r0, addr_msg_choose2 @ load message to choose enemy card
    bl printf @ print message
    ldr r0, addr_int_format @ int format input
    mov r1, sp @ set r1 to take input
    bl scanf
    ldr r1, [sp] @ load input into r1
    cmp r1, #1 @ check user input
    vsubeq.f32 s2, s2, s1 @ if r1 = 1 then sub computer's card s2
    vsubne.f32 s3, s3, s1 @ if r1!=1 then sub computer's card s3
    bl computer_move

  computer_move:
    vcmp.f32 s2, s3 @ check computer's card for larger int
    bgt computer_from_left @ if s2 > s3 then branch to attack
@load addr_zero into s4????
    vcmp.f32 s3, s4 @ at this point s3 > s2 so check if s3 > 0
ble computer_loose @ if not then branch to end
    bl computer_from_right @ otherwise attack from right (r7)
   
    computer_from_left: @ use s2 (computer's card) to attack
    vcmp.f32 s0, s1 @ check user's larger int
    vsubgt.f32 s0, s0, s2 @ if s0 > s1 then attack s0
    suble s1, s1, s2 @ otherwise attack s1 by s2
    bl display_cards @ display cards

computer_from_right: @ use s3 (computer's card) to attack
    vcmp.f32 s0, s1 @ check user's larger int 
    subgt s0, s0, s3 @ if s0 > s1 then attack s0
    suble s1, s1, s3 @ otherwise attack s1 by s3
    bl display_cards @ display cards

display_cards:
ldr r0, addr_user_lt_card @ store values in fp addresses
vmov r1, s0
str r1, [r0]
ldr r0, addr_user_rt_card
vmov r1, s1
str r1, [r0]
ldr r0, addr_cp_lt_card
vmov r1, s2
str r1, [r0]
ldr r0, addr_cp_rt_card
vmov r1, s3
str r1, [r0]

ldr  r1, addr_user_lt_card @ convert to display
vldr s0, [r1]
vcvt.f64.f32 d1, s0
ldr  r1, addr_user_rt_card
vldr s1, [r1]
vcvt.f64.f32 d2, s1
ldr  r1, addr_cp_lt_card
vldr s2, [r1]
vcvt.f64.f32 d3, s2
ldr  r1, addr_cp_rt_card
vldr s3, [r1]
vcvt.f64.f32 d4, s3

ldr r0, disp_user_cards @ display user's cards
    vmov r2, r3, d1 @ second param of printf
vstr d2, [sp] @ next to display on stack
bl printf   
ldr r0, disp_cp_cards   @ display computer's cards
mov r1, r2, d3 @ second param of printf
vstr d4, [sp] @ next to display on stack
bl printf
    bl player_move

ldr r0, addr_user_lt_card
vldr s0,[r0] @ load user lt card into s0
ldr r0, addr__user_rt_card
vldr s1, [r0] @ load user rt card into s1
ldr r0, addr_cp_lt_card
vldr s2, [r0] @ load cp lt card into s2
ldr r0, addr_cp_rt_card
vldr s3, [r0] @ load cp rt card into s3

    user_loose:
    ldr r0, addr_user_loose @ load user loose message
    bl printf @ print message
    bl end @ branch to end program

    computer_loose:
    ldr r0, addr_cp_loose @ load computer loose message
bl printf @ print message
bl end @ branch to end program

end:   
  pop {r4, r5, r6, r7, lr} @ readjust the stack and registers 
  bx lr   @ return from main
 
.align 4
disp_user_cards: .word user_cards
disp_cp_cards: .word cp_cards
addr_msg_welcome: .word msg_welcome
addr_msg_choose1: .word msg_choose1
addr_msg_choose2: .word msg_choose2
addr_cp_loose: .word cp_loose
addr_user_loose: .word user_loose
addr_int_format: .word int_format
addr_flt_format: .word flt_format
addr_user_lt_card: .word user_lt_card @ user's first card (left card)
addr_user_rt_card: .word user_rt_card @ user's second card (right card)
addr_cp_lt_card: .word cp_lt_card @ computer's first card (left card)
addr_cp_rt_card: .word cp_rt_card @ computer's second card (right card)
addr_zero: .word zero @ set to 0 to compare single precision float

.global scanf
.global printf
.global time
.global srand
.global rand?