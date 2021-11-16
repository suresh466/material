.include "consts/linux.s"
.include "consts/record-def.s"

.section .data
input_filename:
	.ascii "wrongtest.dat\0"
output_filename:
	.ascii "testout.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text
.equ ST_INPUT_DESCRIPTOR, -4
.equ ST_OUTPUT_DESCRIPTOR, -8

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
	jg continue_processing
	.section .data
	no_open_error_code:
		.ascii "0001\0"
	no_open_error_message:
		.ascii "Could not open the file\0"

	.section .text
	pushl $no_open_error_message
	pushl $no_open_error_code
	call error_exit
	addl $8, %esp

	movl $SYS_READ, %eax
	movl $STDIN, %ebx
	movl $record_buffer, %ecx
	movl $RECORD_SIZE, %edx
	int $LINUX_SYSCALL

	###Manually replace last byte of the filename with 0###
	#decl %eax
	#movb $0, record_buffer(,%eax,1)

	movl $SYS_OPEN, %eax
	movl $record_buffer, %ebx
	movl $0, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL
	movl %eax, ST_INPUT_DESCRIPTOR(%ebp)	#Recovery input descriptor.

	continue_processing:
	movl $SYS_OPEN, %eax
	movl $output_filename, %ebx
	movl $0101, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL
	movl %eax, ST_OUTPUT_DESCRIPTOR(%ebp)	#Output descriptor.

	start_inc_age_loop:
		pushl ST_INPUT_DESCRIPTOR(%ebp)
		pushl $record_buffer
		call read_record
		addl $8, %esp	

		cmpl $RECORD_SIZE, %eax
		jne end_inc_age_loop
		incl record_buffer + RECORD_AGE

		pushl ST_OUTPUT_DESCRIPTOR(%ebp)
		pushl $record_buffer
		call write_record
		addl $8, %esp
		jmp start_inc_age_loop
	end_inc_age_loop:
		movl %ebp, %esp
		movl $SYS_EXIT, %eax
		movl $0, %ebx
		int $LINUX_SYSCALL
