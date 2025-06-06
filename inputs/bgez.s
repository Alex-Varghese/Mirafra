#The `bgez` instruction checks if the value in register `t8` is greater than or equal to zero, and if so, it branches to the `multiplicationOperationLabel` to perform a multiplication. If the condition is false, the program continues with the next instruction to perform a division.
.text

main: 
     addi $t1,$zero,20
     addi $t2,$zero,4
     addi $t8,$zero,0

     bgez $t8,multiplicationOperationLabel
     div $t1,$t2
     j end

multiplicationOperationLabel: 
     mult $t1,$t2
     j end

end: 
     addi $v0,$zero,10
     syscall

