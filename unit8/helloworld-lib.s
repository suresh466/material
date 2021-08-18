.include "consts/linux.s"

.section .data
hello:
	.ascii "Hello world\0"

.section .text
.globl _start
_start:
	pushl $hello
	call printf

	pushl $0
	call exit
