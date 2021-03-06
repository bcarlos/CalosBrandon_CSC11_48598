/* division.s with push and pop implemented */

.GLOBAL _MAIN
_MAIN:
	STR LR, [SP,#-4]!	@ PUSH LR ONTO THE TOP OF THE STACK
	SUB SP, SP, #4		@ MAKE ROOM FOR ONE 4 BYTE INTEGER
		
	MOV R0, #111		@ VARIABLE TO BE DIVIDED
	MOV R1, #0			@ COUNTER
	MOV R2, #0			@ EMPTY VARIABLE TO SWAP
	MOV R3, #5			@ VARIABLE TO DIVIDE R0 BY	
	MOV R4, R0			@ COPY OF R0 TO BE USED AS REMAINDER
	CMP R0, R3			@ CHECK THE INTEGERS IF SWAP NEEDED
	BLT _SWAP
	BGE _LOOP

_LOOP:
	STMDB SP!, {R4, LR}	@ PUSH R4 AND LR ONTO THE STACK
						@ TO MAKE IT 8 BYTE ALIGNED
	
	ADD R1, R1, #1		@ ADD TO THE COUNTER
	SUB R4, R4, R3		@ R4 <- R4 - R3
	CMP R4, R3			@ IF R4 IS GREATER THAN R3 THEN
	BGE _LOOP			@ BRANCH TO _LOOP TO SUBTRACT MORE OTHERWISE
	BLT _END			@ BRANCH TO _END TO END THE PROGRAM

_SWAP:					@ SWAP THE REGISTERS IF R0 < R3
	MOV R2, R0
	MOV R0, R3
	MOV R3, R2
	B _LOOP				@ CONTINUE PROGRAM AFTER SWAP

_END:					@ END PROGRAM
	LDMIA SP!, {R4, LR}	@ POP LR AND R4 FROM THE STACK
	BX LR

		
