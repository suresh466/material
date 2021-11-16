#PURPOSE:
#	Count the characters until a null byte is reached.
#INPUT:
#	Parameter 1 - Address of the character string.
#
#output:
#	Count of characters until null byte.
#

.section .text

.equ ST_STRING_START_ADDRESS, 8

.globl count_chars
.type count_chars, @function
#count_chars:
#	pushl %ebp
#	movl %esp, %ebp
#
#	movl ST_STRING_START_ADDRESS(%ebp), %edx
#	movl $0, %ecx
#
#	count_loop_begin:
#	cmpb $0, (%edx,%ecx,1)
#	je count_loop_end
#	incl %ecx
#	jmp count_loop_begin
#
#	count_loop_end:
#	movl %ecx, %eax
#	movl %ebp, %esp
#	popl %ebp
#	ret


count_chars:
	pushl %ebp
	movl %esp, %ebp

#Counter starts at zero
movl $0, %ecx

#Starting address of data
movl ST_STRING_START_ADDRESS(%ebp), %edx

count_loop_begin:
#Grab the current character
movb (%edx), %al
#Is it null?
cmpb $0, %al
#If yes, we’re done
je count_loop_end
#Otherwise, increment the counter and the pointer
incl %ecx
incl %edx
#Go back to the beginning of the loop
jmp count_loop_begin

count_loop_end:
#We’re done. Move the count into %eax
#and return.
movl %ecx, %eax

popl %ebp
ret
