###################################################################
#	func calcula endereço matriz																		#
#	recebe *campo[], número de linhas, x e y - respectivamente			#
# retorna endereço e flag de validade de endereço									#
###################################################################

calc_endereco:
	blt	$a2, 0, seg_fault
	bge	$a2, $a1, seg_fault
	blt	$a3, 0, seg_fault
	bge	$a3, $a1, seg_fault

	mul	$t1, $a1, $a3
	add	$t1, $t1, $a2
	mul	$v0, $t1, 4
	add	$v0, $v0, $a0		# adiciona o offset ao endereço
	li	$v1, 0					# não retorna flag de erro
	jr	$ra
	
seg_fault:
	li	$v0, 0			# se tentar acessar uma casa não existente na matriz
	li	$v1, 1			# retorna 1 (flag) em $v1 e 0 no lugar de endereço
	jr	$ra
