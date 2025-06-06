#The **AND IMMEDIATE** instruction in MIPS performs a bitwise AND operation between oneregister and immediate value. The result is stored in the destination register, with each bit set to 1 only if the corresponding bits in both source registers are 1.


.text


main: 
   addiu $t0,$zero,0x1872

   and $t8,$t0,0x1234
   j end

end: 
   addiu $v0,$zero,10
   syscall

