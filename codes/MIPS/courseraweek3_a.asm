# use 16 bytes=4 words align so that we can get the address of each string with calculation
.data
in:.word 0
end:.asciiz "?"
star: .asciiz "\n*\n"
.align 4
zero:.asciiz "\nzero\n"
.align 4
one:.asciiz "\nFirst\n"
.align 4
two:.asciiz "\nSecond\n"
.align 4
three:.asciiz "\nThird\n"
.align 4
four:.asciiz "\nFourth\n"
.align 4
five:.asciiz "\nFifth\n"
.align 4
six:.asciiz "\nSixth\n"
.align 4
seven:.asciiz "\nSeventh\n"
.align 4
eight:.asciiz "\nEighth\n"
.align 4
nine:.asciiz "\nNinth\n"
.align 4
A:.asciiz "\nAlpha\n"
.align 4
B:.asciiz "\nBravo\n"
.align 4
C:.asciiz "\nChina\n"
.align 4
D:.asciiz "\nDelta\n"
.align 4
E:.asciiz "\nEcho\n"
.align 4
F:.asciiz "\nFoxtrot\n"
.align 4
G:.asciiz "\nGolf\n"
.align 4
H:.asciiz "\nHotel\n"
.align 4
I:.asciiz "\nIndia\n"
.align 4
J:.asciiz "\nJuliet\n"
.align 4
K:.asciiz "\nKilo\n"
.align 4
L:.asciiz "\nLima\n"
.align 4
M:.asciiz "\nMary\n"
.align 4
N:.asciiz "\nNovember\n"
.align 4
O:.asciiz "\nOscar\n"
.align 4
P:.asciiz "\nPaper\n"
.align 4
Q:.asciiz "\nQuebec\n"
.align 4
R:.asciiz "\nResearch\n"
.align 4
S:.asciiz "\nSierra\n"
.align 4
T:.asciiz "\nTango\n"
.align 4
U:.asciiz "\nUniform\n"
.align 4
V:.asciiz "\nVictor\n"
.align 4
W:.asciiz "\nWhisky\n"
.align 4
X:.asciiz "\nX-ray\n"
.align 4
Y:.asciiz "\nYankee\n"
.align 4
Z:.asciiz "\nZulu\n"

.text
input:		li $v0, 8
       		la $a0, in
       		li $a1, 2
       		syscall
judge:		lb $t1, in
		lb $t2, end
		beq $t1, $t2, exit #exit if ?
		blt $t1, 48, outStar
		ble $t1, 57, outNumeric
		blt $t1, 65, outStar
		ble $t1, 90, outUpperAlpha
		blt $t1, 97, outStar
		ble $t1, 122, outLowerAlpha
outStar:	li $v0, 4
		la $a0, star
		syscall
		j input
outUpperAlpha:	li $v0, 4
		sub $t3, $t1, 65 #65 means A
		mul $t3, $t3, 16
		la $a0, A($t3)
		syscall
		j input
outLowerAlpha:	li $v0, 4
		sub $t3, $t1, 97 #97 means a
		mul $t3, $t3, 16
		# make first letter to lowercase
		lw $t4, A($t3)
		or $t4, 0x2000 #also can use add $t4, $t4, 0x2000
		sw $t4, A($t3)
		la $a0, A($t3)
		syscall
		#restore first letter
		andi $t4, 0xffffdfff #also can use sub $t4, $t4, 0x2000
		sw $t4, A($t3)
		j input
outNumeric:	li $v0, 4
		sub $t3, $t1, 48 #48 means 0
		mul $t3, $t3, 16
		la $a0, zero($t3)
		syscall
		j input
exit:		li $v0, 10
		syscall

