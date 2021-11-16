.include "consts/linux.s"

.section .data
hello:
	.ascii "Hello world no lib\0"
hello_end:
.equ hello_len, hello_end-hello

.section .text
.globl _start
_start:
	pushl %ebp
	movl %esp, %ebp

	movl $SYS_WRITE, %eax
	movl $STDOUT, %ebx
	movl $hello, %ecx
	movl $hello_len, %edx
	int $LINUX_SYSCALL

	movl %esp, %ebp
	popl %ebp
	movl $1, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL
