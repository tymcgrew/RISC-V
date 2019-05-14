.text
	li a0, 1
	li a1, 5

	jal ra, funct
	ecall

	li a0, 10
	ecall




funct:
	addi sp, sp, 4
	sw ra, 0, sp

	li t0, 13
	bgt a1, t0, skip
	
	addi a1, a1, 3
	jal funct

	skip:
	lw ra, 0, sp
	addi sp, sp, -4
	ret