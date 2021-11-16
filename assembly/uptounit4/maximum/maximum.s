#PURPOSE:
#
#VARIABLES:
#	The following memory locations are used:
#	data_items1 - Contains the item data list 1.
#	data_items2 - Contains the item data list 2.
#	data_items3 - Contains the item data list 3.
#
#NOTE:
#	A 0 is used to terminate the data.
#

.section .data

data_items1:
	.long 1,3,4,5,6,10,2,0
data_items2:
	.long 1,2,4,5,3,20,40,200,0
data_items3:
	.long 5,3,6,7,254,253,2,0

.section .text

.include "maximum-func.s"

.globl _start
_start:
	subl $4, %esp	# Push the first argument.
	movl $data_items1, (%esp)	#
	call maximum
	addl $4, %esp	# Restore the %esp.

	# Second call
	subl $4, %esp
	movl $data_items2, (%esp)
	call maximum
	addl $4, %esp

	# Third call
	subl $4, %esp
	movl $data_items3, (%esp)
	call maximum
	addl $4, %esp

	movl %eax, %ebx
	movl $1, %eax
	int $0x80
