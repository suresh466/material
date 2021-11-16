#PURPOSE:
#	The purpose of this program is to show how recursive
#	function works.
#
#NOTE:
#

.section .data

.section .text

.globl _start
.globl factorial	# This is unneeded unless
			# we want to share this
			# function among other programs.

_start:
	subl $4, %esp	# Push the first argument.
	movl $4, (%esp)	#
	call factorial
	addl $4, %esp	# Reset the stack.

	movl $1, %eax	# Exit code	
	int $0x80 
#PURPOSE:
#	Calculates factorial of a number recursively.
#
#INPUT:
#	First argument - number to find factorial of.
#
#OUTPUT:
#	Result as a return value.
#
#Variables:
#	%ebx - Holds the n=1th number of the factorial.
#	%eax - Holds n-1th number of the factorial.
#
#NOTE:
#	Input factorial number should at least be 1 and
#	resulting number should be less than 255.
#

.type factorial, @function

factorial:
	#subl $4, %esp	# Preserve the value of %ebp
	#movl %ebp, (%esp)	#
	pushl %ebp
	movl %esp, %ebp	# Make %ebp equal to %esp

	movl 8(%ebp), %ebx	# Load the 1st argument.

	cmpl $1, %ebx	# Check to see if end factorial
	je factorial_end	# or base case.

	decl %ebx	# Get the first argument for
			# the next recursive call.
	#subl $4, %esp 	# Push the 1st argument for
	#movl %ebx, (%esp)	# the next resursive call.
	pushl %ebx
	call factorial
	movl 8(%ebp), %eax	# Get the n-1th number of the factorial.
	imull %eax, %ebx	# Multiply nth and n-1th factorial number.

	factorial_end:
		movl %ebp, %esp	# Restore %esp.
		movl (%esp), %ebp	# Reset or restore %ebp.	
		addl $4, %esp		#

		ret
