/* division of two numbers */

	.global _start
_start:
_read:
				@ READ SYSCALL
	MOV R7, #3		@ SYSCALL NUMBER
	MOV R0, #0		@ STDOUT IS MONITOR
	MOV R2, #5		@ READ FIRST 5 CHARACTERS
	LDR R1,=string 		@ STRING PLACED AT STRING:
	SWI 0

	

_write:
				@ WRITE SYSCALL
	MOV R7, #4		@ SYSCALL NUMBER
	MOV R0, #1		@ STDOUT IS MONITOR
	MOV R2, #28		@ STRING IS 28 CHARS LONG
	LDR R1,=string		@ STRING LOCATED AT STRING:
	SWI 0

_compare:
				@ COMPARE THE DIGITS TYPED
	CMP R2, R3		@ SET FLAGS FOR R2 MINUS R3
	BEQ ZEROFLAGSET		@ BRANCH IF ZERO FLAG IS SET
	CMN 
	

_ZEROFLAGSET:
				@ ZERO FLAG SET WHEN R2 MINUS R3
	MOV R7, #4		@ SYSCALL NUMBER
	MOV R0, #1		@ STDOUT IS MONITOR
	MOV R2, #28		@ STRING IS 28 CHARS LONG
	LDR R1,=string2		@ STRING LOCATED AT STRING2:
	SWI 0
	


_exit:
				@ EXIT SYSCALL
	MOV R7, #1
	SWI 0

.data
string:
.ascii "Type the numbers to divide:\n"
string2:
.ascii "These are the same numbers" 