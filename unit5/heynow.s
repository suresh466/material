#PURPOSE:
#
#VARIABLES:
#	filename - Stores the file name.
#	message - Stores the message to write.
#

.section .data
filename:
	.ascii "heynow.txt\0"
message:
	.ascii "diddle Diddle\0"

.section .bss
.lcomm FD_OUT, 4

.section .text

.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1
.equ LINUX_SYSCALL, 0x80
.equ O_CREAT_WRONLY_TRUNC, 03101


.globl _start
_start:
	#Open a file
	open_fd_out:
	movl $SYS_OPEN, %eax	#Code for open syscall.
	movl $filename, %ebx	#Momory location of filename.
	movl $O_CREAT_WRONLY_TRUNC, %ecx	#File open open if not exist flag.
	movl $0666, %edx	#Permission to create the files with.
	int $LINUX_SYSCALL	#Cause the interupt for systemcall.
	#save the fd in the stack.
	movl %eax, FD_OUT
	
	begin_write:
		movl $SYS_WRITE, %eax
		movl FD_OUT, %ebx
		movl $message, %ecx	#Address of the data buffer(static in this case).
		movl $0, %edx
	count_characters:
		cmpb $0, (%ecx,%edx,1)
		je end_write
		incl %edx
		jmp count_characters
	end_write:
	int $LINUX_SYSCALL

	#Close the file.
	movl $SYS_CLOSE, %eax
	movl $FD_OUT, %ebx
	int $LINUX_SYSCALL

	#Exit
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL
