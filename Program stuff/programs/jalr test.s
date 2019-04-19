.text
	
	li a0, 1
	li a1, 1
	jal ra, funct
	addi a1, a1, 2
	addi a1, a1, 4
	ecall

	li a0, 10
	ecall

	funct:
	addi a1, a1, 1
	jalr x0, ra, 4

