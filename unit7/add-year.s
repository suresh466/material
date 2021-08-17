.include "consts/linux.s"
.include "consts/record-def.s"

.section .data
input_filename:
	.ascii "test.dat\0"

output_filename:
	.ascii "testout.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.equ ST_INPUT_DESCRIPTOR, -4
.equ ST_OUTPUT_DESCRIPTOR, -8

.section .text

.globl _start
_start:
	movl %esp, %ebp
	subl $8, %esp

	movl $SYS_OPEN, %eax
	movl $input_filename, %ebx
	movl $0, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL
	movl %eax, ST_INPUT_DESCRIPTOR(%ebp)	#Input descriptor.

	cmpl $0, %eax
	jge continue_processing
		.section .data
		no_open_error_code:
			.ascii "0001\0"
		no_open_error_message:
			.ascii "Could not open the file\0"

		.section .text
		pushl $no_open_error_message
		pushl $no_open_error_code
		call error_exit

	continue_processing:
	movl $SYS_OPEN, %eax
	movl $output_filename, %ebx
	movl $0101, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL
	movl %eax, ST_OUTPUT_DESCRIPTOR(%ebp)	#Outpout descriptor.

	start_loop:
		pushl ST_INPUT_DESCRIPTOR(%ebp)
		pushl $record_buffer
		call read_record
		addl $8, %esp	

		cmpl $RECORD_SIZE, %eax
		jne end_loop

		incl record_buffer + RECORD_AGE

		pushl ST_OUTPUT_DESCRIPTOR(%ebp)
		pushl $record_buffer
		call write_record
		addl $8, %esp
		jmp start_loop

	end_loop:
		movl %ebp, %esp
		movl $SYS_EXIT, %eax
		movl $0, %ebx
		int $LINUX_SYSCALL
