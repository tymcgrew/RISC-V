.text
	li a0, 1
	li t0, 2        #t0 is value

	loop:

		li t2, 1                     #t2 is i
		outerloop:

			li t3, 1                  #t3 is j
			innerloop:
				mul t4, t2, t3          #t4 = i*j
				beq t4, t0, done

				addi t3, t3, 1          #j++
				blt t3, t0, innerloop   #if (j < value) do inner loop again
		
			addi t2, t2, 1             #i++
			blt t2, t0, outerloop      #if (i < value) do outer loop again  

		jal print
		done:
		addi t0, t0, 1               #increment value and check again
		j loop

	print:
	mv a1, t0
	ecall
	ret