.include "consts/linux.s"
.include "consts/record-def.s"

.section .data
filename:
	.ascii "test.dat\0"
smallest_age:
	.long 200

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text
.equ ST_DESCRIPTOR, -4

.global _start
_start:
	movl %esp, %ebp
	subl $4, %esp

	movl $SYS_OPEN, %eax
	movl $filename, %ebx
	movl $0, %ecx
	movl $0101, %edx
	int $LINUX_SYSCALL
	movl %eax, ST_DESCRIPTOR(%ebp)

	start_loop:
		pushl ST_DESCRIPTOR(%ebp)
		pushl $record_buffer
		call read_record
		addl $8, %esp

		cmpl $RECORD_SIZE, %eax
		jne end_loop

		movl $RECORD_AGE+record_buffer, %eax
		movl (%eax), %eax
		cmpl smallest_age, %eax
		jge start_loop
		movl %eax, smallest_age	
		jmp start_loop

	end_loop:
		movl %ebp, %esp
		movl $SYS_EXIT, %eax
		movl smallest_age, %ebx
		int $LINUX_SYSCALL
