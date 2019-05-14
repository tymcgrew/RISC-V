.text

	li t0, 100
	li t1, 255
	sb t1, 1, t0

	lb a1, 1, t0
	li a0, 1
	ecall	
