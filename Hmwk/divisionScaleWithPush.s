	.GLOBAL _START:

_START:
	MOV R0, #0			@ counter
	MOV R1, R3			@ copy of variable to be moded
	MOV R2, #6			@ initialize variables to- 
	MOV R3, #25			@ be divided

	CMP R1, R2			@ checks integers
	BLT _END			@ ends program if integers are swapped
	BGE _SCALELEFT
	
_SCALELEFT:				@ scale integers
	MOV R3, R3,	LSL #1	@ scale r3 
	MOV R2, R2, LSL #1	@ scale r2
	CMP R1, R2			@ repeat loop if r2 is larger
	BGE _SCALELEFT
	MOV R3, R3, LSR #1	@ scale back r3
	MOV R2, R2, LSR #1	@ scale back r2
	BL _SUBTRACTLOOP
	
_SCALERIGHT:			
	MOV R3, R3, LSR #1	@ division counter
	MOV R2, R2, LSR #1	@ remainder subtraction
	CMP R1, R2			@ checks the two variables and loops if-
	BLT _SCALERIGHT		@ r1 is smaller than r2
	
_SUBTRACTLOOP:			@ subtract label
	ADD R0, R0, R3		@ count the subtracted scale factor
	SUB R1, R1, R2		@ subtract the variable by the scaled number
	BL _SCALERIGHT
	CMP R3, #1 			
	BGE _SUBTRACTLOOP	@ to be scaled down and subtract looped again
	BLT _END	

_END:					@ ends program
	MOV R7, #1
	SWI 0

		