#The MFLO (Move From LO) instruction in MIPS transfers the value from the LO register to a general-purpose register. It is typically used after multiplication or division operations to access the result stored in the LO register.
#The MFHI (Move From HI) instruction in MIPS moves the value from the HI register to a general-purpose register. It is used to retrieve the upper part of the result from multiplication or the remainder from division operations.

.text

main: 
   li $t0,100 #pseudo instruction used to load data into general purpose register ($t0)
   li $t1,6

   div $t0,$t1

   mflo $t8
   mfhi $t9
   j end

end: 
    addiu $v0 , $zero , 10
    syscall


