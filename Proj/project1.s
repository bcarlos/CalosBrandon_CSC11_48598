@This is a card game. The player and computer generate 2 cards with single digit numbers
@ Each player has a choice of attacking the opponent with a chosen card. An attack subtracts
@ itself from the card being attacked and leaves the remainder for the higher card. A player wins
@ when their opponent has no more cards
.data
message0: .asciz "User's cards: 1: %d , 2: %d  computer's cards: 1: %d , 2: %d "
message1: .asciz "Welcome to the card attack game"
message2: .asciz "Enter 1 to play, anything else to exit: "
message3: .asciz "Choose a card that you want to use to attack (1 or 2 respectively): "
message4: .asciz "Choose which card you want to attack (1 or 2 respectively): " 
message5: .asciz "Computer looses!"
message6: .asciz "You loose"
format: .asciz "%d"
 
.text
 
.globl main
 
main:
  push {lr, r4, r5, r6, r7}

  ldr r0, address_of_message1
  bl printf
  ldr r0, address_of_message2
  bl printf

  ldr r0, address_of_format  
  mov r1, sp
  bl scanf
  ldr r0, [sp]
  cmp r0, #1
  beq create_cards  
  b _end  
  
  
   random_num:
   mov r0, #0
   bl time
   bl srand
   bl rand
   mov r1, r0, asr #1
   mov r2, #7
   bl divMod
  
   create_cards:
   bl random_num
   mov r0, r1 
   and r0, r0, #5             /* user's cards r0 & r1 */
   bl random_num
   mov r1, r1
   and r1, r1, #5
   bl random_num   
   mov r2, r1
   and r2, r2, #5            /* computer's cards r2 & r3 */
   bl random_num
   mov r3, r1
   and r3, r3, #5
   ldr r4, address_of_message0
   bl printf   
   bl player_move

   player_move:
   cmp r0, #0
   ble user_card_check
   ldr r4, address_of_message3
   bl printf
   ldr r4, address_of_format
   mov r4, sp
   bl scanf
   ldr r4, [sp]
   cmp r4, #1
   beq attack_from_left
   bne attack_from_right

   user_card_check:
   cmp r1, #0
   ble user_loose

   attack_from_left:
   ldr r4, address_of_message4
   bl printf
   ldr r4, address_of_format
   mov r4, sp
   bl scanf
   ldr r4, [sp]
   cmp r4, #1
   subeq r2, r2, r0
   subne r3, r3, r0
   bl computer_move

   attack_from_right:
   ldr r4, address_of_message4
   bl printf
   ldr r4, address_of_format
   mov r4, sp
   bl scanf
   ldr r4, [sp]
   cmp r4, #1
   subeq r2, r2, r1
   subne r3, r3, r1
   bl computer_move

   computer_move:
   cmp r2, #0
   bgt computer_from_right
   cmp r3, #0
   bgt computer_from_left
   bl computer_loose 

   computer_from_right:
   mov r4, r1
   and r4, r4, #1
   cmp r4, #0
   adds r1, r1, #1
   subgt r1, r1, r3
   suble r0, r0, r3
   bl player_move    
   
   computer_from_left:
   mov r4, r1
   and r4, r4, #1
   cmp r4, #0
   adds r1, r1, #1
   subgt r1, r1, r2
   suble r0, r0, r2
   bl player_move 

   user_loose:
   ldr r0, address_of_message6
   bl printf
   bl end

   computer_loose:
   ldr r0, address_of_message5
   bl printf
   bl end

   
   
   
   _end:   
   pop {lr, r4, r5} 
   bx lr                       /* Return from main */
 
.align 4
address_of_message0: .word message0
address_of_message1: .word message1
address_of_message2: .word message2
address_of_message3: .word message3
address_of_message4: .word message4
address_of_message5: .word message5
address_of_message6: .word message6
address_of_format: .word format
