.text

	li a0, 1
	li sp, 1000

	li t0, 1                # t0 is value
	loop:

		mv t1, t0            # t1 is n
		jal recursive
		mv a1, t2            # print returned number (t2)
		li t2, 0
		ecall

		addi t0, t0, 1        #increment value and loop
		j loop

	recursive:
		addi sp, sp, -8
		sw ra, 4(sp)
		mv t2, t1
		beq t1, x0, recursivebase

		sw t1, 0(sp)
		addi t1, t1, -1
		jal recursive
		
		lw t3, 0(sp)
		add t2, t2, t3

	recursivebase:
		lw ra, 4(sp)
		addi sp, sp, 8
		jr ra