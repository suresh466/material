#PURPOSE:
#	Show how to calculate factorial without recursion.
#
#VARIABLES:
#
#NOTE:
#	1st argument should be at least 1.
#

.section .data
fact_holder:
	.ascii "factorial is %d %s\0"
newline:
	.ascii "\n"

.section .text

.include "factorial-non-func.s"

.globl _start
_start:
	pushl $4	# Push the 1st argument.
	call factorial_non
	addl $4, %esp	# Restore %esp.

	pushl $newline
	pushl %eax
	pushl $fact_holder
	call printf
	pushl $0
	call exit

	#movl %eax, %ebx	# Move result to %ebx(it is the status code).
	#movl $1, %eax
	#int $0x80

