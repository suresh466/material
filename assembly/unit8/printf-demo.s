.section .data
some_string:
	.ascii "My name is %s %s. And I sort of like the number %d\0"

first_name:
	.ascii "Suresh\0"
last_name:
	.ascii "Thagunna\0"
liked_number:
	.long 7

.section .text
.globl _start
_start:
	pushl liked_number
	pushl $last_name
	pushl $first_name
	pushl $some_string
	call printf

	call exit
