.text
start:          addiu $gp,$zero,14 #1
                addiu $sp,$zero,4 #2
                sll $v1,$gp,2 #3
                srl $a0,$gp,2 #4
                sra $a1,$gp,1 #5
                sllv $a2,$sp,$gp #6
                srlv $a3,$gp,$sp #7
                srav $t0,$gp,$sp #8
                jal special #9
                addiu $gp,$zero,-10 #19
                add $t1,$gp,$sp #20
                addu $t2,$gp,$sp #21
                sub $t3,$gp,$sp #22
                subu $t4,$gp,$sp #23
                and $t5,$gp,$sp #24
                or $t6,$gp,$sp #25
                xor $t7,$gp,$sp #26
                nor $s0,$gp,$sp #27
                slt $s1,$gp,$sp #28
                sltu $s2,$gp,$sp #29
                j exit #30
special:        mult $gp,$sp #10
                mfhi $s3 #11
                mflo $s4 #12
                mthi $gp #13
                mtlo $sp #14
                multu $gp,$sp #15
                div $gp,$sp #16
                divu $gp,$sp #17
                jr $ra #18
 exit:
                addiu $v0,$zero,10
                syscall #32

