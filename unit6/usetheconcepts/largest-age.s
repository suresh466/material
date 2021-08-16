.include "consts/linux.s"
.include "consts/record-def.s"
#PURPOSE:
#	Find the largest age in a file.
#

.section .data

read_filename:
	.ascii "test.dat\0"

largest_age:
	.long 0

.section .bss
.lcomm read_buffer, RECORD_SIZE

.equ ST_DESCRIPTOR, -4

.section .text

.globl _start
_start:
	movl %esp, %ebp
	subl $8, %esp

	movl $SYS_OPEN, %eax
	movl $read_filename, %ebx
	movl $0, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL
	movl %eax, ST_DESCRIPTOR(%ebp)

	start_loop:
	pushl ST_DESCRIPTOR(%ebp)
	pushl $read_buffer
	call read_record
	addl $8, %esp

	cmpl $RECORD_SIZE, %eax
	jne end_loop

	movl $RECORD_AGE+read_buffer, %eax	#Load the address of age.
	movl (%eax), %eax	#Load the age.
	cmpl largest_age, %eax
	jle start_loop
	movl %eax, largest_age
	jmp start_loop

	end_loop:
	movl %ebp, %esp
	movl $SYS_EXIT, %eax
	movl largest_age, %ebx
	int $LINUX_SYSCALL
