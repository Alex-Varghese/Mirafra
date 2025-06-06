.text

main: 
    lui $t0,0x1000 #(this is used as base address for all other load and store instruction $to constains 0x0000100000000000)

    li $t1 , 0xf347
    
    sw $t1 , 0($t0)

    lb $t4, 0($t0)
    lb $t5 ,1($t0)
    lb $t6, 2($t0)

    lh $a0 , 0($t0)
    lw $a1 , 0($t0)

    lhu $v1,0($t0)
    
    j end

end : 
    li $v0,10
    syscall

