.include "consts/linux.s"
.include "consts/record-def.s"

.section .data

file_name:
	.ascii "test.dat\0"
newline:
	.ascii "\n"

.section .bss

.lcomm record_buffer, RECORD_SIZE

.section .text

.globl _start
_start:
	.equ ST_INPUT_DESCRIPTOR, -4
	.equ ST_OUTPUT_DESCRIPTOR, -8

	movl %esp, %ebp
	subl $8, %esp	#Allocate space for file descriptors.

	movl $SYS_OPEN, %eax
	movl $file_name, %ebx
	movl $0, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL

	movl %eax, ST_INPUT_DESCRIPTOR(%ebp)	#Input descriptor.
	#Even though it's a constant, we are
	# saving the output descriptor in a
	# local variable so that if we later
	# decide that it isn't always going
	# to be STDOUT, we can change it easily.
	movl $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)

	record_read_loop:
		pushl ST_INPUT_DESCRIPTOR(%ebp)
		pushl $record_buffer
		call read_record
		addl $8, %esp

		#Returns the number of bytes read.
		# If this isn't the same number we
		# requested, then it's either an
		# end of file, or an error, so we're
		# quitting.
		cmpl $RECORD_SIZE, %eax
		jne finished_reading

		#Otherwise, print out the first name.
		# But first, we must know it's size.
		#pushl $RECORD_FIRSTNAME + record_buffer
		#call count_chars
		#addl $4, %esp

		pushl $RECORD_FIRSTNAME+record_buffer
		call printf
		pushl $newline
		call printf

		#movl %eax, %edx
		#movl $SYS_WRITE, %eax
		#movl ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
		#movl $RECORD_FIRSTNAME + record_buffer, %ecx
		#int $LINUX_SYSCALL

		#pushl ST_OUTPUT_DESCRIPTOR(%ebp)
		#call write_newline
		#addl $4, %esp

		jmp record_read_loop

	finished_reading:
	#movl %ebp, %esp
	#movl $SYS_EXIT, %eax
	#movl $0, %ebx
	#int $LINUX_SYSCALL
	pushl $0
	call exit
