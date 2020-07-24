.data
mine_field:	.space	324


.text
################
# debug purposes
main:
	la	$a0, mine_field
	la	$a1, 8
	la	$a2, 1
	la	$a3, 1
	jal	sweep_field
	
	# finish the execution
	li	$v0, 10	
	syscall
# end debuging
#################

#################################
## 	nested for loops to run through a given square matrix
#	in this case, it calls calc_adjacent_bombs function for each position
#
#	@param $a0 *mine_field, $a1 = matrix_order
sweep_field:
	addi	$sp, $sp, -20
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)	
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	
	move	$s0, $a0	# s0 = *mine_field
	move	$s1, $a1	# s1 = matrix_order

	li	$s3, 0		# s3 = y = 0
	loop_y:

		li	$s2, 0		# s2 = x = 0
		loop_x:
			# set arguments for function call
			move	$a0, $s0
			move	$a1, $s1
			move	$a2, $s2
			move	$a3, $s3
			jal calc_adjacent_bombs

			################ debug purpose ##############
			# jal get_element_address
			# beq $v0, -1, continue
			# li $t1, 1
			# sw $t1, 0($v0)
			# continue:
			##########################################

			addi	$s2, $s2, 1		# x++
			blt	$s2, $s1, loop_x	# if (x < matrix_order) loop_x 
		addi	$s3, $s3, 1		# y++
		blt	$s3, $s1, loop_y	# if (y < matrix_order) loop_y 

	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra	
##################################
##	Calculates the quantity of adjacent bombs to the current cell
#
#	@param $a0 = *mine_field , $a1 =  matrix_order, $a2 = cell_coordinate_x , $a3 = cell_coordinate_y;
#	@return $v0 = number of adjacent bombs
calc_adjacent_bombs:
	addi	$sp, $sp, -24
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)

		# caller-saved temporaries assignment
	move	$s0, $a0	# s0 = matrix adress
	move	$s1, $a1	# s1 = matrix order
	move	$s2, $a2	# s2 = x coordinate
	move	$s3, $a3	# s3 = y coordinate
	li	$s4, 0		# s4 = count (for return), begins in 0

		# if the current cell is a bomb, jumps to the function's end with return = 9 (bomb)
	jal	get_element_address
	lw	$v0, 0($v0)
	beq	$v0, 9, end_adj_calc

		# adjacent cells "circular" iteration
	addi	$s2, $s2, 1		#x++
	jal	adjacent_bombs_subroutine
	addi	$s3, $s3, -1		#y--
	jal	adjacent_bombs_subroutine
	addi	$s2, $s2, -1		#x--
	jal	adjacent_bombs_subroutine
	addi	$s2, $s2, -1		#x--
	jal	adjacent_bombs_subroutine
	addi	$s3, $s3, 1		#y++
	jal	adjacent_bombs_subroutine
	addi	$s3, $s3, 1		#y++
	jal	adjacent_bombs_subroutine
	addi	$s2, $s2, 1		#x++
	jal	adjacent_bombs_subroutine	
	addi	$s2, $s2, 1		#x++
	jal	adjacent_bombs_subroutine
	move	$v0, $s4	 # return count (if's not a bomb-containing cell)

	end_adj_calc:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	addi	$sp, $sp, 24
	jr	$ra

	###################
	# calc_adjacent_bombs subroutine
	# move iterator position to arguments and adds up counter
	adjacent_bombs_subroutine:
		addi	$sp, $sp, -4
		sw	$ra, 0($sp)

		move	$a0, $s0
		move	$a1, $s1
		move	$a2, $s2
		move	$a3, $s3
		jal	get_element_address
		move	$a0, $v0
		jal is_bomb
		add	$s4, $s4, $v0	# if has bomb, count++
		
		lw	$ra, 0($sp)
		addi	$sp, $sp, 4
		jr	$ra
		

#################################
##	calculate the address of a certain position (cell) inside a square matrix
#
#	@param	$a0 = *matrix, $a1 = matrix order, $a2 = coordinate_x; $a3 = coordinate_y
#	@return	$v0 = address; $v1 = flag;
get_element_address:
	blt	$a2, 0, seg_fault		# if the given position is outside the matrix range {
	bge	$a2, $a1, seg_fault		#
	blt	$a3, 0, seg_fault		#
	bge	$a3, $a1, seg_fault		# }

	mul	$t1, $a1, $a3 		# t1 = ((x_max * a_y) + a_x) * 4Bytes
	add	$t1, $t1, $a2		#
	mul	$t1, $t1, 4 		# 
	add	$v0, $t1, $a0		# return = (t1 + original address)
	li	$v1, 0				# error flag = 0
	jr	$ra					# return; 
	seg_fault:			# returns 1 (flag) to $v1 and -1 instead of address to $v0
		li	$v0, -1
		li	$v1, 1
		jr	$ra

#################################
##	Check if a given address has a bomb
#
#	@param $a0 &address
#	@return $v0 = 1 if &address possition has a bomb
is_bomb:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	li	$v0, 0
	beq	$a0, -1, end_ib_func # jumps to end if has a invalid address
	lw	$t1, 0($a0)
	seq	$v0, $t1, 9	# if it has a bomb, returns TRUE

	end_ib_func:
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
