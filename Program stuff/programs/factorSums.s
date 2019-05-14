.text
	li a0, 1
	li t0, 1            # t0 is current value
	
	loop:
		li t1, 0         # t1 is factor sum for current value
		li t2, 1         # t2 is i
		
		outerloop:
			bgt t2, t0, doneouter
			li t3, 0      # t3 is flag
			li t4, 1      # t4 is j
			
			innerloop:
				bgt t4, t0, doneinner
			
				mul t5, t2, t4 # t5 holds result
				bne t5, t0, skip
				li t3, 1

				skip:
				addi t4, t4, 1
				j innerloop

		doneinner:
			beq t3, x0, skipAdd
			add t1, t1, t2			

		skipAdd:
			addi t2, t2, 1
			j outerloop

	doneouter:
		mv a1, t1        # move factor sum to a1 and print
		ecall
		addi t0, t0, 1   # increment current value

	j loop