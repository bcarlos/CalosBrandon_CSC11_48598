	.global _start

_start:
	MOV R0, #0	
	MOV R1, R2
	MOV R2, #111
	MOV R3, #5
	MOV R4, #0
	MOV R5, #0
	CMP R1, R3
	BLT _SWAP

_LOOP:
	ADD R0, R0, #1
	SUB R1, R1, R2
	CMP R1, R2
	BGE _LOOP
	BLT _END

_SWAP:
	MOV R5, R3
	MOV R3, R1
	MOV R1, R5

_END:
	MOV R7, #1
	SWI 0

		