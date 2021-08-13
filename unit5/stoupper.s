#PURPOSE:
#	To convert lower case letter into uppercase.
#

.equ STDIN, 0
.equ STDOUT, 1
.equ STDERROR, 2
.equ SYS_READ, 3
.equ SYS_WRITE, 4
.equ SYS_OPEN, 5
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1
.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z, 'z'
.equ UPPER_CONVERSION, 'A' - 'a'
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

.section .bss
.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

.globl read
.globl write
.globl to_uppercase

.globl _start
_start:
	call read
	pushl %eax	#Save the number of bytes read into the buffer.
	call close_fd
	call to_uppercase
	call write
	addl $4, %esp	#Restore esp.

	movl $SYS_EXIT, %eax
	movl $0, %ebx
	#movl 0(%esp), %ebx
	int $0x80

.type read, @function
read:
	pushl %ebp
	movl %esp, %ebp

	call open_fd
	pushl %eax	#FD
	movl $SYS_READ, %eax
	#movl $STDIN, %ebx
	movl (%esp), %ebx
	movl $BUFFER_DATA, %ecx
	movl $BUFFER_SIZE, %edx	
	int $0x80
	
	movl %ebp, %esp
	popl %ebp
	ret

.type write, @function
write:
	pushl %ebp
	movl %esp, %ebp

	movl $SYS_WRITE, %eax
	movl $STDOUT, %ebx
	movl $BUFFER_DATA, %ecx
	movl 8(%ebp), %edx
	int $0x80

	movl %ebp, %esp
	popl %ebp
	ret

.type to_uppercase, @function
to_uppercase:
	pushl %ebp
	movl %esp, %ebp

	movl $BUFFER_DATA, %edi
	movl $0, %esi
	cmpb $0, (%edi,%esi,1)
	je end_loop

	start_loop:
	cmpb $LOWERCASE_A, (%edi,%esi,1)
	jl next_byte
	cmpb $LOWERCASE_Z, (%edi,%esi,1)
	jg next_byte
	addb $UPPER_CONVERSION, (%edi,%esi,1)

next_byte:
	addl $1, %esi
	cmpb $0, (%edi,%esi,1)
	jne start_loop

	end_loop:
	movl %ebp, %esp
	popl %ebp
	ret

.type open_fd, @function
open_fd:
	pushl %ebp
	movl %esp, %ebp

	movl $SYS_OPEN, %eax
	movl 24(%ebp), %ebx #infile
	movl $O_RDONLY, %ecx
	movl $0666, %edx
	int $0x80

	movl %ebp, %esp
	popl %ebp
	ret

.type close_fd, @function
close_fd:
	pushl %ebp
	movl %esp, %ebp

	movl $SYS_CLOSE, %eax
	movl 8(%ebp), %ebx
	int $0x80

	movl %ebp, %esp
	popl %ebp
	ret
