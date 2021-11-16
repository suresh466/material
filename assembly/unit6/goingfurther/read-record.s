.include "consts/linux.s"
.include "consts/record-def.s"

#PURPOSE:
#	To read a file descriptor into the buffer.
#
#INPUT:
#	First argument - file descriptor
#	second argument - buffer to write into
#	

#Stack_variables
.equ ST_READ_BUFFER, 8
.equ ST_FILEDES, 12

.section .text

.globl read_record
.type read_record, @function	
read_record:
	pushl %ebp
	movl %esp, %ebp

	#pushl %ebx
	movl $SYS_READ, %eax
	movl ST_FILEDES(%ebp), %ebx
	movl ST_READ_BUFFER(%ebp), %ecx
	movl $RECORD_SIZE, %edx
	int $LINUX_SYSCALL
	#popl %ebx

	movl %ebp, %esp
	popl %ebp
	ret
