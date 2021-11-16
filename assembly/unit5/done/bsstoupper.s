#PURPOSE:
#	This program converts an input file
#	to an output file with all letters
#	converted to uppercase.
#
#PROCESSING:
#	1) Open the input file
#		%eax = 5(open syscall) 
#		%ebx = Filename.
#		%ecx = R/w intentions.
#			linux return file descriptor.
#	2) Open the output file
#	3) While we’re not at the end of the input file
#		a) read part of file into our memory buffer
#			read syscall = 3.
#				%ebx = file descriptor.
#		b) go through each byte of memory.
#			%ecx = address of a buffer for storing data that is read.
#			%edx = size of the buffer.
#			- read outputs number of charactes read from the file or
#			error code.
#		if the byte is a lower-case letter,
#		convert it to uppercase.
#		c) write the memory buffer to output file.
#			write syscall = 4.
#			other parameter same as read syscall, except
#			that the buffer should already be filled with
#			the data to write out.
#			- write will output the number of data written or
#			an negative error code.
#
#	4) clode the file after you are done.
#		close syscall = 6
#		%ebx = file descriptor.
#

.section .data
#######CONSTANTS########
#System call numbers
.equ SYS_EXIT, 1
.equ SYS_READ, 3
.equ SYS_WRITE, 4
.equ SYS_OPEN, 5
.equ SYS_CLOSE, 6

#Options for open (look at
# /usr/include/asm/fcntl.h for
# various values. You can combine them
# by adding them or ORing them)
# this is discussed at greater length
# in "Counting Like a Computer"
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

#Standard file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

#System call interrupt
.equ LINUX_SYSCALL, 0x80
.equ END_OF_FILE, 0	#This is the return value
			# of read which means we’ve
			# hit the end of the file
.equ NUMBER_ARGUMENTS, 2

.section .bss
#Buffer - this is where the data is loaded into
# from the data file and written from into
# the output file. This should never
# exceed 16,000 for various reasons.
#
.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

#For file descriptors.
.equ FD_SIZE, 8
.lcomm FD_DATA, FD_SIZE
#.lcomm FD_DATA_OUT, FD_SIZE


.section .text

#STACK POSITIONS
.equ ST_SIZE_RESERVE, 8
.equ ST_FD_IN, -4
.equ ST_FD_OUT, -8
.equ ST_ARGC, 0	#Number of arguments
.equ ST_ARGV_0, 4	#Name of program
.equ ST_ARGV_1, 8	#Input file name
.equ ST_ARGV_2, 12	#Output file name

.globl _start
_start:
###INITIALIZE PROGRAM###
#Save the stack pointer
movl %esp, %ebp

#Allocate space for our file descriptors
# on the stack
subl $ST_SIZE_RESERVE, %esp

open_files:
open_fd_in:
###OPEN INPUT FILE###
#Open syscall
movl $SYS_OPEN, %eax
#Input filename into %ebx
movl ST_ARGV_1(%ebp), %ebx
#Read-only flag
movl $O_RDONLY, %ecx
#This doesn’t really matter for reading
movl $0666, %edx
#Call Linux
int $LINUX_SYSCALL

store_fd_in:
#Save the given file descriptor
#movl %eax, ST_FD_IN(%ebp)
movl $0, %edi
movl %eax, FD_DATA(%edi)

open_fd_out:
###OPEN OUTPUT FILE###
#Open the file
movl $SYS_OPEN, %eax
#Output filename into %ebx
movl ST_ARGV_2(%ebp), %ebx
#Flags for writing to the file
movl $O_CREAT_WRONLY_TRUNC, %ecx
#Mode for new file (if it’s created)
movl $0666, %edx
#Call Linux
int $LINUX_SYSCALL

store_fd_out:
#Store the file descriptor here
#movl %eax, ST_FD_OUT(%ebp)
movl $4, %edi
movl %eax, FD_DATA(%edi)

###BEGIN MAIN LOOP###
read_loop_begin:
###READ IN A BLOCK FROM THE INPUT FILE###
movl $SYS_READ, %eax
#Get the input file descriptor
#movl ST_FD_IN(%ebp), %ebx
movl $0, %edi
movl FD_DATA(%edi), %ebx
#Get the location to read into
movl $BUFFER_DATA, %ecx
#The size of the buffer
movl $BUFFER_SIZE, %edx
#Size of buffer read is returned in %eax
int $LINUX_SYSCALL

###EXIT IF WE’VE REACHED THE END###
#Check for end of file marker
cmpl $END_OF_FILE, %eax
#If found or on error, go to the end
jle end_loop

continue_read_loop:
###CONVERT THE BLOCK TO UPPER CASE###
pushl $BUFFER_DATA	#Location of buffer
pushl %eax	#Size of the buffer
call convert_to_upper
popl %eax	#Get the size back
addl $4, %esp	#Restore %esp

###WRITE THE BLOCK OUT TO THE OUTPUT FILE###
#Size of the buffer
movl %eax, %edx
movl $SYS_WRITE, %eax
#File to use
#movl ST_FD_OUT(%ebp), %ebx
movl $4, %edi	#Index for  FD_OUT
movl FD_DATA(%edi), %ebx
#Location of the buffer
movl $BUFFER_DATA, %ecx
int $LINUX_SYSCALL

###CONTINUE THE LOOP###
jmp read_loop_begin

end_loop:
###CLOSE THE FILES###
#NOTE:
#	We don’t need to do error checking
#	on these, because error conditions
#	don’t signify anything special here.
movl $SYS_CLOSE, %eax
#movl ST_FD_OUT(%ebp), %ebx
movl $0, %edi
movl FD_DATA(%edi), %ebx
int $LINUX_SYSCALL

movl $SYS_CLOSE, %eax
#movl ST_FD_IN(%ebp), %ebx
movl $0, %edi
movl FD_DATA(%edi), %ebx
int $LINUX_SYSCALL

###EXIT###
movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL

#PURPOSE:
#	This function actually does the
#	conversion to upper case for a block
#
#INPUT:
#	The first parameter is the location
#	of the block of memory to convert
#	The second parameter is the length of
#	that buffer
#
#OUPUT:
#	This function overwrites the current
#	buffer with the upper-casified version.
#
#
#VARIABLES:
#	%eax - beginning of buffer
#	%ebx - length of buffer
#	%edi - current buffer offset
#	%cl - current byte being examined
#	(first part of %ecx)

###CONSTANTS##
#The lower boundary of our search
.equ LOWERCASE_A, 'a'
#The upper boundary of our search
.equ LOWERCASE_Z, 'z'
#Conversion between upper and lower case
.equ UPPER_CONVERSION, 'A' - 'a'

###STACK STUFF###
.equ ST_BUFFER_LEN, 8	#Length of buffer
.equ ST_BUFFER, 12	#Actual buffer
convert_to_upper:
	pushl %ebp
	movl %esp, %ebp

###SET UP VARIABLES###
movl ST_BUFFER(%ebp), %eax
movl ST_BUFFER_LEN(%ebp), %ebx
movl $0, %edi

#If a buffer with zero length was given
# to us, just leave
cmpl $0, %ebx
je end_convert_loop

convert_loop:
#Get the current byte
movb (%eax,%edi,1), %cl
#Go to the next byte unless it is between
# ’a’ and ’z’
cmpb $LOWERCASE_A, %cl
jl next_byte
cmpb $LOWERCASE_Z, %cl
jg next_byte

#Otherwise convert the byte to uppercase
addb $UPPER_CONVERSION, %cl
#And store it back
movb %cl, (%eax,%edi,1)
next_byte:
	incl %edi	#Next byte.
	cmpl %edi, %ebx	# continue unless we've reached the end.
	jne convert_loop

end_convert_loop:
#No return value, just leave
movl %ebp, %esp
popl %ebp
ret
