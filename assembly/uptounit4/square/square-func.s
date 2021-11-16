.section .data

.section .text

.globl square	# Uneeded unless you want to share
		# this function with other programs.

#PURPOSE:
#	Find the square of a number.
#
#INPUT:
#	First parameter - Number to be squared.
#
#OUTPUT:
#	Result as a return value.
#
#VARIABLES:
#	%eax - Holds the number to be squared.
#
#NOTE:
#

.type square, @function
square:
	subl $4, %esp	# Preserve old %epb.
	movl %ebp, (%esp)	#
	movl %esp, %ebp	# Make %ebp equal to %esp.
	movl 8(%ebp), %eax
	imul %eax, %eax
	movl %ebp, %esp	# Restore %esp.
	movl (%esp), %ebp # Restore the %ebp.
	addl $4, %esp	#
	ret
