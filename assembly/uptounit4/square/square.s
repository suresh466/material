#PURPOSE:
#	To show how to call external functions.
#
#VARIABLES:
#
#NOTE:
#

.section .data

.section .text

.include "square-func.s"

.globl _start
_start:
	movl $4, (%esp)
	call square
	addl $4, %esp
	movl %eax, %ebx

	movl $1, %eax
	int $0x80
