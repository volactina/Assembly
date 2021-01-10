.data
    string: .space 33
    char: .space 2

.macro read_str (%buf, %len)
    la $a0, %buf
    li $a1, %len
    li $v0, 8
    syscall
.end_macro

.macro print_str (%str)
    .data
        myLabel: .asciiz %str
    .text
        li $v0, 4
        la $a0, myLabel
        syscall
.end_macro

.macro read_char(%buf)
    li $v0, 12
    syscall
    move %buf, $v0
.end_macro

.macro print_int (%i)
    .text
        li $v0, 1
        move $a0, %i
        syscall
.end_macro


.text
.globl start

print_str("enter a string(max 32 ): ")
read_str(string, 33)

start:

print_str("enter a char( enter ? exit ): ")
read_char($s0) # 读入字节存入s0寄存器
print_str("\n")

#判断是否为?
li $t0, 0x3f
beq $t0, $s0, exit

la $t0, string # 字符串起始地址
li $s1, 1 # 循环变量

for:
    lbu $t1, 0($t0) # 取单个字节
    bne $s0, $t1, endfor # 判断是否相等，不等则继续循环

    print_str("Success! Location: ")
    print_int($s1) #打印找到的位置
    print_str("\n")

    j start
endfor:
    addi $t0, $t0, 1 #字符串地址+1
    addi $s1, $s1, 1 #循环变量+1
    ble $s1, 32, for # 继续循环

print_str("fail\n") # 未找到 打印fail
j start

exit:
    print_str("Bye")
