.data
msg: .asciiz "MTHI then MFHI result: "
newline: .asciiz "\n"

.text
.globl main
main:
    li $t0, 99
    mthi $t0         # Copy 99 to HI
    mfhi $s0

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

