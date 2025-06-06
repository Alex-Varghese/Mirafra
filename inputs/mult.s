.data
msg: .asciiz "MULT: HI = "
newline: .asciiz "\n"

.text
.globl main
main:
    li $t0, -10
    li $t1, 20
    mult $t0, $t1     # HI/LO = -200 = 0xFFFFFF38

    mfhi $s0          # Get upper 32 bits
    mflo $s1          # Get lower 32 bits

    li $v0, 4
    la $a0, msg
    syscall

    li $v0, 1
    #move $a0, $s0     # Print HI
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 4
    la $a0, msg
    syscall

    li $v0, 1
   # move $a0, $s1     # Print LO
    syscall

    li $v0, 10
    syscall

