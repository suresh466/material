#PURPOSE:
#	Write records to the file test-dat.
#

.include "consts/linux.s"
.include "consts/record-def.s"

.section .data

record1:
	.ascii "Fredrick\0"
	.rept 31	#Padding to 40 bytes
	.byte 0
	.endr

	.ascii "Bratlett\0"
	.rept 31
	.byte 0
	.endr

	.ascii "4242 S Prairie\nTulsa, OK 55555\0"
	.rept 209
	.byte 0
	.endr

	.long 45

record2:
	.ascii "Marilyn\0"
	.rept 32
	.byte 0
	.endr

	.ascii "Taylor\0"
	.rept 33
	.byte 0
	.endr
	
	.ascii "2224 S Johannan St\nChicago, IL 12345\0"
	.rept 203
	.byte 0
	.endr

	.long 29

record3:
	.ascii "Derrick\0"
	.rept 32
	.byte 0
	.endr

	.ascii "McIntire\0"
	.rept 31
	.byte 0
	.endr

	.ascii "500 W Oakland\nSan Diego, CA 54321\0"
	.rept 206
	.byte 0
	.endr

	.long 36

filename:
	.ascii "test.dat\0"

.equ ST_FILE_DESCRIPTOR, -4

.section .text
.globl _start
_start:
	movl %esp, %ebp
	subl $4, %esp	#Allocate space for the file descriptor.

	#Open the file
	movl $SYS_OPEN, %eax	#Assembler replaces the symbol with a value.
	movl $filename, %ebx	#Start of the adddress of null terminated filename.
	movl $0101, %ecx	#Create if doesn't exist and open for writing.
	movl $0666, %edx
	int $LINUX_SYSCALL
	movl %eax, ST_FILE_DESCRIPTOR(%ebp)	#Actual file Descriptor is stored
						# in the stack.
	#Write the first record
	pushl ST_FILE_DESCRIPTOR(%ebp)	#Direct addressing mode.
					#-4(%ebp) is sort of like a pointer here.
	pushl $record1	#Starting address of the record1.
	call write_record
	addl $8, %esp

	pushl ST_FILE_DESCRIPTOR(%ebp)
	pushl $record2
	call write_record
	addl $8, %esp

	pushl ST_FILE_DESCRIPTOR(%ebp)
	pushl $record3
	call write_record
	addl $8, %esp

	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL
