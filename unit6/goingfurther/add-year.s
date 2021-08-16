.include "consts/linux.s"
.include "consts/record-def.s"

.section .data
input_filename:
	.ascii "test.dat\0"

output_filename:
	.ascii "tesout.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.equ ST_DESCRIPTOR, -4

.section .text

.globl _start
_start:
	movl %esp, %ebp
	subl $8, %esp

	movl $SYS_OPEN, %eax
	movl $input_filename, %ebx
	movl $2, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL
	movl %eax, ST_DESCRIPTOR(%ebp)	#Input descriptor.

	start_loop:
		pushl ST_DESCRIPTOR(%ebp)
		pushl $record_buffer
		call read_record
		addl $8, %esp	

		cmpl $RECORD_SIZE, %eax
		jne end_loop

		incl record_buffer + RECORD_AGE

		pushl ST_DESCRIPTOR(%ebp)
		pushl $record_buffer
		call write_record
		addl $8, %esp
		jmp start_loop

	end_loop:
		movl %ebp, %esp
		movl $SYS_EXIT, %eax
		movl $0, %ebx
		int $LINUX_SYSCALL
