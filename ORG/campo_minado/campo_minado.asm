#################################
##	calculate the adress of a certain position inside a square matrix
#
#	@param	$a0 = *matrix, $a1 = matrix order, $a2 = x; $a3 = y
#	@return	$v0 = adress; $v1 = flag;
get_element_adress:
	blt	$a2, 0, seg_fault		# if the given position is outside the matrix range {
	bge	$a2, $a1, seg_fault		#
	blt	$a3, 0, seg_fault		#
	bge	$a3, $a1, seg_fault		# }

	mul	$t1, $a2, $a3 		# t1 = ((x*y) + x) * 4Bytes
	add	$t1, $t1, $a2		#
	mul	$t1, $t1, 4 		# 
	add	$v0, $t1, $a0		# return = (t1 + original adress)
	li	$v1, 0				# error flag = 0
	jr	$ra					# return; 
	seg_fault:			# returns 1 (flag) to $v1 and -1 instead of adress to $v0
		li	$v0, -1
		li	$v1, 1
		jr	$ra

#################################
##	Check if a given position in the matrix has a bomb
#
#	@param $a0 $matrix_adress(x, y)
#	@return $v0 = 1 if (x, y) possition has a bomb
is_bomb:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	beq	$a0, -1, end_ib_func # jumps to end if has a invalid adress
	lw	$v0, 0($v0)
	seq	$v0, $v0, 9	# if it has a bomb, returns TRUE

	end_ib_func:
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
