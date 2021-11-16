#PURPOSE
#
#INPUT:
#	Parameter 1 - Number to find factorial of.
#
#OUTPUT:
#	Result in exit status.
#
#VARIABLES:
#	%eax = Current result.
#	%ebx = n - 1 of factorial number.
#
#NOTE:
#	1st argument should be at least 1.
#

.section .data

.section .text

.globl factorial_non

.type factorial_non, @function
factorial_non:
	pushl %ebp
	movl %esp, %ebp	# Make %ebp equal to %esp.

	movl 8(%ebp), %eax 	# Load the 1st parameter.
	movl 8(%ebp), %ebx	# Initialize %ebx.

	factorial_loop_start:
		cmpl $1, %ebx
		je factorial_loop_end
		decl %ebx	# Get n-1 of the factorial number.
		imull %ebx, %eax
		jmp factorial_loop_start

	factorial_loop_end:
		movl %ebp, %esp	# Restore %esp.
		popl %ebp
		ret
