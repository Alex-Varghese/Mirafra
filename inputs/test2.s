.text
__start:        addiu $v1,$zero,-10 #1
                addiu $v1,$v1,-3 #2
                addi $a0,$v1,180 #3
                addi $a1,$zero,-13 #4
                beq $a1,$v1,pass1 #5
pass2:
                addi $a2,$v1,13 #7
                blez $a2,pass3  #8
pass1:
                bgtz $a0, pass2 #6
pass3:
                bltzal $v1, pass4 #9
                slti $t6,$a1,150 #15
                sltiu $t7,$a1,150 #16
                andi  $s0,$v1,2 #17
                xori  $s1,$a2,160 #18
                bne $v1,$a1,pass5 #19
                bgez $a0,pass5 #20
pass6:
                lui $t0, 543 #22
                ori $t0, 48 #23
                lb $t1, -1($a3) #24
                lh $t2, 0($a3) #25
                lw $t3, 4($a3) #26
                lbu $t4, -1($a3) #27
                lhu $t5, 0($a3) #28
                bltz $a0,pass6 #29
                jr $ra #30
pass4:
                lui $a3,4096 #10
                ori $a3,4
                addiu $s4,$zero,-1
                lui $s5,38760
                ori $s5,26983
                sb $s4, -1($a3) #11
                sh $s5, 0($a3) #12
                addiu $s3,$zero,10
                sw $s3, 4($a3) #13
                jr $ra #14
pass5:
                bgezal $a0,pass6 #21
                addiu $v0,$zero,10 #31
                syscall #32
