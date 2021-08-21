#PURPOSE:
#	To convert lower case letter into uppercase.
#

.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z, 'z'
.equ UPPER_CONVERSION, 'A' - 'a'

.section .data
O_RDONLY:
	.ascii "r"
O_WRONLY:
	.ascii "w"

.section .bss
.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

.globl _start
_start:
	movl %esp, %ebp

	pushl $O_RDONLY
	pushl 8(%ebp)
	call fopen
	addl $8, %esp

	pushl %eax
	pushl $BUFFER_SIZE
	pushl $1
	pushl $BUFFER_DATA
	call fread
	addl $16, %esp

	pushl $BUFFER_DATA
	pushl %eax
	call uppercase
	addl $8, %esp

	pushl $O_WRONLY
	pushl 12(%ebp)
	call fopen
	addl $8, %esp

	pushl %eax
	pushl $BUFFER_SIZE
	pushl $1
	pushl $BUFFER_DATA
	call fwrite
	addl $16, %esp

	pushl $0
	call exit

.globl uppercase
.type uppercase, @function
uppercase:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %esi	#Load the first arg(number of data read).
	movl 12(%ebp), %edi	#Load the second arg(data items buffer).

	decl %esi	#Last byte is the null byte
	convert:
	cmpl $0, %esi
	jl end_uppercase
	cmpb $LOWERCASE_A, (%edi,%esi,1)
	jl continue
	cmpb $LOWERCASE_Z, (%edi,%esi,1)
	jg continue
	addb $UPPER_CONVERSION, (%edi,%esi,1)
	decl %esi
	jmp convert

	continue:
	decl %esi
	jmp convert
	
	end_uppercase:
	movl %ebp, %esp
	popl %ebp
	ret
