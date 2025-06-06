.data
msg: .asciiz "MFLO result: "
newline: .asciiz "\n"

.text
.globl main
main:
    li $t0, 123
    li $t1, 321
    mult $t0, $t1

    mflo $s0       # Move from LO
    li $v0, 4
    la $a0, msg
    syscall

    li $v0, 1
    move $a0, $s0
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 10
    syscall

