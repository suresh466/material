.include "consts/linux.s"

.section .text
.equ ST_ERROR_CODE, 8
.equ ST_ERROR_MESSAGE, 12

.globl error_exit
.type error_exit, @function
error_exit:
	pushl %ebp
	movl %esp, %ebp

	pushl ST_ERROR_CODE(%ebp)
	call count_chars
	addl $4, %esp
	movl %eax, %edx
	movl $SYS_WRITE, %eax
	movl $STDERR, %ebx
	movl ST_ERROR_CODE(%ebp), %ecx
	int $LINUX_SYSCALL

	pushl $STDERR
	call write_newline
	addl $4, %esp
	pushl ST_ERROR_MESSAGE(%ebp)
	call count_chars
	addl $4, %esp
	movl %eax, %edx

	movl $SYS_WRITE, %eax
	movl $STDERR, %ebx
	movl ST_ERROR_MESSAGE(%ebp), %ecx
	int $LINUX_SYSCALL
	pushl $STDERR
	call write_newline
	addl $4, %esp

	movl %ebp, %esp
	popl %ebp
	movl $SYS_EXIT, %eax
	movl $1, %ebx
	int $LINUX_SYSCALL
