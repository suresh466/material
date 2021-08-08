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
#	% - Current result
#
#NOTE:
#	Data item should be 1 or greater than 1.
#

.section .data

.section .text

.globl maximum

.type maximum, @function
maximum:
	subl $4, %esp
	movl %ebp, (%esp)
	movl %esp, %ebp
	

	
