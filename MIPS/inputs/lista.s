
.text
main:	jal	create_default_list
	addu	$s0, $v0, $0	

	la	$a0, start_msg
	li	$v0, 4
	syscall

	addu	$a0, $s0, $0
	jal	print_list

	jal	print_newline

	addu	$a0, $s0, $0	
	la 	$a1, square
	
	jal	map
	la	$a0, end_msg
	li	$v0, 4
	syscall

	addu	$a0, $s0, $0
	jal	print_list

	li	$v0, 10
	syscall

map:

	addiu	$sp, $sp, -12
	sw	$ra, 0($sp)
	sw	$s1, 4($sp)
	sw	$s0, 8($sp)

	beq	$a0, $0, done	

	addu	$s0, $a0, $0	
	addu	$s1, $a1, $0


	

	lw 	$t0, 0($a0)
	
	addiu 	$sp, $sp,-4
	sw  	$a0, 0($sp)  
	lw 	$a0, 0($a0)	
	jalr 	$a1	
	lw 	$a0, 0($sp)	
	addiu 	$sp,$sp,4
	
	addi 	$t1, $v0, 0  
	sw 	$t1, 0($a0)     
	
	lw 	$a0, 4($a0)
	
	la 	$a1, square 
	
	
	jal map



done:
	lw	$s0, 8($sp)
	lw	$s1, 4($sp)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 12
	jr	$ra

square:

	mul	$v0 ,$a0, $a0
	jr	$ra

create_default_list:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	li	$s0, 0		
	li	$s1, 0		
loop:	
	li	$a0, 8
	jal	malloc		
	sw	$s1, 0($v0)	
	sw	$s0, 4($v0)	
	addu	$s0, $0, $v0	
	addiu	$s1, $s1, 1	
	bne	$s1, 10, loop	
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

print_list:
	bne	$a0, $0, printMeAndRecurse
	jr	$ra 		
printMeAndRecurse:
	addu	$t0, $a0, $0	
	lw	$a0, 0($t0)	
	li	$v0, 1		
	syscall
	li	$a0, ' '	
	li	$v0, 11		
	syscall
	lw	$a0, 4($t0)	
	j	print_list	

print_newline:
	li	$a0, '\n'
	li	$v0, 11
	syscall
	jr	$ra

malloc:
	li	$v0, 9
	syscall
	jr	$ra
