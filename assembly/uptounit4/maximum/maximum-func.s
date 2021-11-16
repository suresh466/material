#PURPOSE:
#	Find the greatest number from the given list.
#
#INPUT:
#	Parameter 1 - Pointer to a list of data items.
#
#OUTPUT:
#	Result as status code.
#
#VARIABLES:
#	%edi - Holds index of data items.
#	%eax - Holds current maximum.
#	%ebx - Holds current data item.
#	%ecx - Holds the initial address of data items.
#
#NOTE:
#	Data item should be 1 or greater than 1.
#	0 is used to signify end of data items.
#

.section .data

.section .text

.globl maximum

.type maximum, @function
maximum:
	# Initialize the function.
	subl $4, %esp	# Preserve old %ebp.
	movl %ebp, (%esp)	#
	movl %esp, %ebp	# Make %ebp equal to %esp.

	movl 8(%ebp), %ecx	# Pointer to data items.
	movl $0, %edi	# Index for the data items.
	movl (%ecx), %eax	# Since it is the first number.

	maximum_loop_start:
		incl %edi
		movl (%ecx, %edi, 4), %ebx # Load next data item.
		cmpl $0, %ebx	# Check to see if we hit the end.
		je maximum_loop_end

		cmpl %ebx, %eax
		jge maximum_loop_start
		movl %ebx, %eax
		jmp maximum_loop_start
	
	maximum_loop_end:
		movl %ebp, %esp
		movl (%esp), %ebp
		addl $4, %esp
		ret
