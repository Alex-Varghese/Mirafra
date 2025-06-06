.data
msg: .asciiz "MULTU: LO = "
newline: .asciiz "\n"

.text
.globl main
main:
    li $t0, 4294967295  # 0xFFFFFFFF (max unsigned)
    li $t1, 2
    multu $t0, $t1      # HI = 1, LO = 0xFFFFFFFE

    mfhi $s0
    mflo $s1

    li $v0, 4
    la $a0, msg
    syscall

    li $v0, 1
    move $a0, $s1
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 1
    move $a0, $s0
    syscall

    li $v0, 10
    syscall

