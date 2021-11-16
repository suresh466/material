#PURPOSE:
#	Show how to calculate factorial without recursion.
#
#VARIABLES:
#
#NOTE:
#	1st argument should be at least 1.
#

.section .data

.section .text

.include "factorial-non-func.s"

.globl _start
_start:
	subl $4, %esp	# Push the 1st argument.
	movl $4, (%esp)	#
	call factorial_non
	addl $4, %esp	# Restore %esp.

	movl %eax, %ebx	# Move result to %ebx(it is the status code).
	movl $1, %eax
	int $0x80

