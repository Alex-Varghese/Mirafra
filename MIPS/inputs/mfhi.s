.data
msg: .asciiz "MFHI result: "
newline: .asciiz "\n"

.text
.globl main
main:
    li $t0, 12345
    li $t1, 6789
    mult $t0, $t1

    mfhi $s0       # Move from HI
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

