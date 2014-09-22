/* multiply two numbers together */

	.global _start
_start:
	
	MOV R1, #20		@ R1=20
	MOV R2, #5		@ R2=5
	MUL R3, #10		@ R3=10
	MLA R0, R1, R2, R3	@ R0=(R1*R2)+R3

	MOV R7, #1		@ EXIT THROUGH SYSCALL
	SWI 0