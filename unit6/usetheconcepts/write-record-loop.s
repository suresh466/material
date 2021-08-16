.include "consts/linux.s"
.include "consts/record-def.s"

.section .data
record1:
	.ascii "Suresh\0"
	.rept 33
	.byte 0
	.endr

	.ascii "Thagunna\0"
	.rept 31
	.byte 0
	.endr

	.ascii "77 Some address\n466, ST\0"
	.rept 216
	.byte 0
	.endr

	.long 80

	.ascii "Student\0"
	.rept 32
	.byte 0
	.endr

write_filename:
	.ascii "loop.dat\0"

.section .bss
.lcomm write_buffer, RECORD_SIZE

.equ ST_DESCRIPTOR, -4

.section .text

.globl _start
_start:
	movl %esp, %ebp
	subl $4, %esp

	movl $SYS_OPEN, %eax
	movl $write_filename, %ebx
	movl $0101, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL
	movl %eax, ST_DESCRIPTOR(%ebp)

	movl $0, %edi

	loop_start:
	cmpl $30, %edi
	jg loop_end
	pushl ST_DESCRIPTOR(%ebp)
	pushl $record1
	call write_record
	addl $8, %esp
	incl %edi
	jmp loop_start

	loop_end:
	movl %ebp, %esp	
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL
