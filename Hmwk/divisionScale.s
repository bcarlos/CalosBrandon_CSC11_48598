	.global _start

_start:
	MOV R0, #0			@counter
	MOV R1, R2			@copy of variable to be moded
	MOV R2, #2222		@initialize variables to- 
	MOV R3, #5			@ be divided
	MOV R4, #0			@unused variable??
	MOV R5, #0			@empty variable to be used for a swap
	MOV R6, #0			@counter for scale 
	MOV R7, #0			@subtraction factor 
	MOV R8, #10			@scale factor
	MOV R9, #0			@subtraction factor to be taken out of r2
	CMP R1, R3			@swaps numbers if needed
	BLT _SWAP			@swap label if numbers are switched
	
	
_SCALE:					@scale r3 to be divided
	ADD R6, R6, #1		@scale counter
	MUL R7, R3, R6		@takes variable to be scaled
	MUL R9, R7, R8		@scales up variable
	CMP R1, R9			
	BGE _SCALELOOP
	
_SCALELOOP:				@scale r3 again before subtracting
	MUL R6, R6, R8		@increases scale factor
	MUL R7, R3, R6		@multiply variable with scale factor
	MUL R9, R7, R8		@scale again 
	CMP R1, R9			@checks the two variables and loops if-
	BGT _SCALELOOP		@variable is still too small
	
@	MOV R3, R3 LSL #1  NOTE!!Logical shift can be used here instead
	
_SUBTRACTLOOP:			@subtract label
	ADD R0, R0, R6		@adds into the counter
	SUB R1, R1, R7		@subtract the variable by the scaled number
	CMP R1, R7			@repeat subtraction until...
	BGE _SUBTRACTLOOP
	CMP R1, R7 			@..the scaled number is too big and has-
	BLT _FINALSUBTRACT	@ to be scaled down and subtract looped again
	
_FINALSUBTRACT:			@next subtract loop
	ADD R0, R0, #1		@adds into the counter
	SUB R1, R1, R3		@subtract the remaining with initial variable
	CMP R1, R3			@loop subtraction
	BGE _FINALSUBTRACT	
	BLT _END
	
_SWAP:					@swaps numbers if needed
	MOV R5, R0
	MOV R0, R1
	MOV R1, R5

_END:					@ends program
	MOV R7, #1
	SWI 0

		