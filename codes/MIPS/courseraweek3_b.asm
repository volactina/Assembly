#main function
.data
inc: .word 0   # one character
ins: .word 0:3 # 4 words=16bytes string
.text
inputStr:	li $v0, 8
		la $a0, ins
		li $a1, 32
		syscall
query:		li $v0, 8
		la $a0, inc
		li $a1, 2
		syscall
		lb $t0, inc
		beq $t0, 63, exit
		jal judge
		j query
exit:		li $v0, 10
		syscall

#subroutine judge
.data
find:.asciiz "\nSuccess! Location: "
fail:.asciiz "\nFail!\n"
newline:.asciiz "\n"
.text
judge:		move $t0, $ra #need to save $ra otherwise it will be overwritten
		lb $t1, inc
		li $t3, 0
loop:		lb $t2, ins($t3)
		add $t3, $t3, 1
		beq $t2, 0, printFail #end of string
		beq $t1, $t2, printFind
		j loop
printFail:	la $a0, fail
		jal print
		j judgeFinish
printFind:	la $a0, find
		jal print
		li $v0, 1
		move $a0, $t3
		syscall
		la $a0, newline
		jal print
judgeFinish:	move $ra, $t0
		jr $ra

#subroutine print
.text
print:		li $v0, 4
		syscall
		jr $ra
		