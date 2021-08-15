.include linux.s
.include record-def.s

#PURPOSE:
#	To read a file descriptor into the buffer.
#
#INPUT:
#	First argument - file descriptor
#	second argument - buffer to write into
#	

#Stack_variables
.equ READ_BUFFER, 8
.equ FILEDES, 12

.section .text
.globl read_record
.type read_record, @function	
read_record:
	pushl %ebx
	movl %esp, %ebp

	pushl %ebx
	movl $SYS_READ, %eax
	movl ST_FILEDES, %ebx
	movl ST_READ_BUFFER(%ebp), %ecx
	movl $RECORD_SIZE(%ebp), %edx
	int $LINUX_SYSCALL
	popl %ebx

	movl %ebp, %esp
	popl %ebx
	ret
