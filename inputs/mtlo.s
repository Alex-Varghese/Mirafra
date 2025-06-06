.data
msg: .asciiz "MTLO then MFLO result: "
newline: .asciiz "\n"

.text
.globl main
main:
    li $t0, 77
    mtlo $t0         # Copy 77 to LO
    mflo $s0

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

