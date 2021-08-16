.include "consts/linux.s"

#PURPOSE:
#	Write a new line to file descriptor.
#
#INPUT:
#	Parameter 1 - File descriptor to write to.
#
#OUTPUT:
#	Bytes written or error code.
#

.section .data

newline:
.ascii "\n"

.section .text

.equ ST_FILEDES, 8

.globl write_newline
.type write_newline, @function
write_newline:
	pushl %ebp
	movl %esp, %ebp

	movl $SYS_WRITE, %eax
	movl ST_FILEDES(%ebp), %ebx
	movl $newline, %ecx
	movl $1, %edx
	int $LINUX_SYSCALL

	movl %ebp, %esp
	popl %ebp
	ret
