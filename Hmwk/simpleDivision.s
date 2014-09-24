	.global _start

_start:
	MOV R0, #0	
	MOV R1, #100
	MOV R2, #5
	

_LOOP:
	ADD R0, R0, #1
	SUBS R1, R1, R2
	BEQ _END;
	BGE _LOOP


_END:
	MOV R7, #1
	SWI 0

		