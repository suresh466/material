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
.globl uppercase

.globl _start
_start:
	pushl 8(%esp)
	pushl 4(%esp)
	call open_fd_in
	addl $8, %esp

	pushl $BUFFER_SIZE
	pushl $BUFFER_DATA
	pushl %eax
	#pushl $STDIN
	call read
	addl $12, %esp

	pushl $0
	pushl $BUFFER_DATA
	pushl %eax
	call uppercase
	addl $12, %esp

	movl %eax, %esi	#Sotre number of  data items read.

	pushl 12(%esp)
	pushl 4(%esp)
	call open_fd_out
	addl $8, %esp

	pushl %esi	#Preserved across calls.
	pushl $BUFFER_DATA
	pushl %eax	#FD
	#pushl $STDOUT
	call write
	addl $12, %esp

	movl $SYS_EXIT, %eax
	movl 0(%esp), %ebx
	#movl $0, %ebx
	int $0x80

.type read, @function
read:
	pushl %ebp
	movl %esp, %ebp
	movl $SYS_READ, %eax
	movl 8(%ebp), %ebx
	movl 12(%ebp), %ecx
	movl 16(%ebp), %edx	
	int $0x80

	pushl %eax
	call close_fd
	popl %eax
	
	movl %ebp, %esp
	popl %ebp
	ret

.type write, @function
write:
	pushl %ebp
	movl %esp, %ebp
	movl $SYS_WRITE, %eax
	movl 8(%ebp), %ebx
	movl 12(%ebp), %ecx
	movl 16(%ebp), %edx
	int $0x80

	pushl %eax
	call close_fd
	popl %eax

	movl %ebp, %esp
	popl %ebp
	ret

.type uppercase, @function
uppercase:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %esi	#Load the first arg(number of data read).
	movl 12(%ebp), %edi	#Load the second arg(data items buffer).
	movl 16(%ebp), %eax	#Load the third arg(recursion counter).

	cmpl $0, %esi	#Impossible to be valid after a recursion call due to the base case.
	je convert

	decl %esi
	incl %eax
	pushl %eax
	pushl %edi
	pushl %esi
	call uppercase

	convert:
	cmpb $LOWERCASE_A, (%edi,%esi,1)
	jl end_uppercase
	cmpb $LOWERCASE_Z, (%edi,%esi,1)
	jg end_uppercase
	addb $UPPER_CONVERSION, (%edi,%esi,1)
	incl %esi	#Index the next item.

	end_uppercase:
	movl %ebp, %esp
	popl %ebp
	ret

.type open_fd, @function
open_fd_in:
	pushl %ebp
	movl %esp, %ebp

	cmpl $3, 8(%ebp)
	movl 8(%ebp), %eax
	jne std_in

	movl $SYS_OPEN, %eax
	movl 12(%ebp), %ebx
	movl $O_RDONLY, %ecx
	movl $0666, %edx
	int $0x80

	movl %ebp, %esp
	popl %ebp
	ret

	std_in:
	movl %ebp, %esp
	popl %ebp
	movl $STDIN, %eax
	ret

.type open_fd_out, @function
open_fd_out:
	pushl %ebp
	movl %esp, %ebp

	cmpl $3, 8(%ebp)
	jne std_out

	movl $SYS_OPEN, %eax
	movl 12(%ebp), %ebx
	movl $O_CREAT_WRONLY_TRUNC, %ecx
	movl $0666, %edx
	int $0x80

	movl %ebp, %esp
	popl %ebp
	ret

	std_out:
	movl %ebp, %esp
	popl %ebp
	movl $STDOUT, %eax
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
