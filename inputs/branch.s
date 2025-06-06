.text
main:
    addi $t0, $zero, 5
    addi $t1, $zero, 5
    addi $t2, $zero, -3
    addi $t3, $zero, 0
    addi $t4, $zero, 2
    addi $s0, $zero, 0

    beq $t0, $t1, beq_taken
    next1:
    bne $t0, $t2, bne_taken
    next2:
    blez $t2, blez_taken
    next3:
    bgtz $t4, bgtz_taken
    next4:
    bltz $t2,bltz_taken
    next5:
    bgez $t0, bgez_taken
    next6:
    j end
    beq_taken:
    addi $s0, $s0, 1
    j next1
    bne_taken:
    addi $s0, $s0, 2
    j next2
    blez_taken:
    addi $s0, $s0, 3
    j next3
    bgtz_taken:
    addi $s0, $s0, 4
    j next4
    bltz_taken:
    addi $s0, $s0, 5
    j next5
    bgez_taken:
    addi $s0, $s0, 6
    j next6
    end:
     addi $v0, $zero, 10
     syscall
