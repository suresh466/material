#PURPOSE:
#	To write record to a file descriptor.
#
#Input:
#	Parameter 1 - Pointer to the output buffer.
#	Parameter 2 - File Descriptor to write to.
#OUTPUT:
#	Number of bytes written or error code.
#

.include "consts/linux.s"
.include "consts/record-def.s"

.section .text

#Stack variables
.equ ST_WRITE_BUFFER, 8
.equ ST_FILEDES, 12

.globl write_record
.type write_record, @function
write_record:
	pushl %ebp
	movl %esp, %ebp

	pushl %ebx
	movl $SYS_WRITE, %eax
	movl ST_FILEDES(%ebp), %ebx
	movl ST_WRITE_BUFFER(%ebp), %ecx
	movl $RECORD_SIZE, %edx
	int $LINUX_SYSCALL
	popl %ebx

	movl %ebp, %esp
	popl %ebp
	ret
