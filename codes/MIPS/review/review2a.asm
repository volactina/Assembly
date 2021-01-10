.data
    word: .asciiz "alpha   ","bravo   ","china   ","delta   ","echo    ","foxtrot ","golf    ","hotel   ","india   ","juliet  ","kilo    ","lima    ","mary    ","november","oscar   ","paper   ","quebec  ","research","sierra  ","tango   ","uniform ","victor  ","whisky  ","x-ray   ","yankee  ","zulu    "
    Word: .asciiz "Alpha   ","Bravo   ","China   ","Delta   ","Echo    ","Foxtrot ","Golf    ","Hotel   ","India   ","Juliet  ","Kilo    ","Lima    ","Mary    ","November","Oscar   ","Paper   ","Quebec  ","Research","Sierra  ","Tango   ","Uniform ","Victor  ","Whisky  ","X-ray   ","Yankee  ","Zulu    "
    num: .asciiz "Zero    ", "First   ","Second  ","Third   ","Fourth  ","Fifth   ","Sixth   ","Seventh ","Eighth  ","Ninth   "
    a_z: .word 0x61 0x7a
    A_Z: .word 0x41 0x5a
    n0_9: .word 0x30 0x39

.macro print_str (%str)
    .data
        msg: .asciiz %str
    .text
        li $v0, 4
        la $a0, msg
        syscall
.end_macro

.macro read 
    li $v0, 12	
    syscall
.end_macro

# 读入字符串 a
# 判断字符串在哪个范围内
# 根据范围，计算出偏移量
# 打印最终结果

.text
.globl start
start:
print_str ("Enter a char (max 1 length, enter ? quit): ")
#读取字符串
read
move $s3, $v0
print_str ("\n")
#判断是否为?
li $t0, 0x3f
beq $t0, $s3, exit

# 循环三次，判断在哪个范围内打印了，如果没有打印，则打印*
li $t7, 0 #循环初始变量
li $t8, 3 #循环结束条件

for:
    mul $t5, $t7, 8  # 边界范围偏移量
    la $t0, a_z #加载边界范围基础地址
    add $t0, $t5, $t0 #基础地址 + 偏移量
    lw $t1, 0($t0) #上界
    lw $t2, 4($t0) #下界
    bge $s3, $t1, gt # 判断大于下界，如果是判断是否大于上界
        j endfor #小于下界则进行下一轮循环
    gt: bgt $s3, $t2, endfor #大于上界则进行下一轮循环

    sub $t0, $s3, $t1 #算出单词偏移量
    li $t2, 9 #偏移量单位 9
    mul $t0, $t2, $t0 #单词最终偏移量
    mul $t5, $t7, 234 #单词段基址偏移量单位26 * 9
    la $t1, word #单词段基础地址
    add $t1, $t5, $t1 #单词段最终地址= 基址+偏移量
    add $a0, $t1, $t0 #单词地址=单词段最终地址+单词最终偏移量

    li $v0, 4 #加载打印服务
    syscall #打印
    print_str("\n")
    j start #重新开始输入
endfor: addi $t7, $t7, 1
blt $t7, $t8, for

print_str("*\n") #其他字符打印*
j start #继续下一轮
exit:
    print_str("Bye")
