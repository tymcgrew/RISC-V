.text
	li a0, 1
	li a1, 1

	li a2, -5
	li a3, 6
	
	bge a2, a3, skip
	li a1, -1
	skip:
	ecall


