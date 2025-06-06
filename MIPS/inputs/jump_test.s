#The j (jump) instruction unconditionally transfers control to the specified label, in this case second_expression and then to update, to perform a specific operation like addition. Since it's unconditional, the program does not check any condition and directly jumps to operationLabel.
 
.text
 
main:
      addi $4,$zero,1024
      j second_expression
      addi $5,$zero,2043
 
second_expression:
      addi $6,$zero,777
      j update
      addi $7,$zero,16
 
update:
      add $8,$4,$6
      add $9,$5,$7
      j end
 
end:
      addi $v0 , $zero,10
      syscall
