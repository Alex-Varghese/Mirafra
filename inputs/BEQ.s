



.text

main:
    li $t0, 5
        li $t1, 5
            beq $t0, $t1, equal_branch
                li $v0, 4
                    la $a0, msg2
                        syscall
                            j end

                            equal_branch:
                                li $v0, 4
                                    la $a0, msg1
                                        syscall

                                        end:
                                            li $v0, 10
                                                syscall

