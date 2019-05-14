# Address line    0: Intializtion      (0 byte)
# Address line   50: Interrupt         (200 byte)
# Address line  300: Program1 Context  (1200 byte)
# Address line  350: Program2 Context  (1400 byte)
 
# Address line  400: Program1          (1600 byte)

# Address line  700: Program2          (2800 byte)

# Address line 1024: WatchdogTimerBegin (PseudoAddress)

Intialize:
	li t0, 1600                # Line 400 is start of program1
	sw t0, 1204, x0            # store 1600 in ra of program1 context
	li t0, 2800                # Line 700 is start of program2
	sw t0, 1404, x0            # store 2800 in ra 1 of program2 context

	li t0, 1 
	li gp, 4096                # Global pointer <= line 1024 (WatchdogTimerBegin address)
	sw t0, 0, gp               # Write 1 to WatchdogTimerBegin
	li t0, 0                   # Restore t0 to 0

	li tp, 0                   # Thread pointer <= 0 (Program1 thread id = 0)

	li ra, 1600                # Line 400 is start of program1
	ret                        # Jump to program1

	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

Interrupt:
	bgt tp, x0, P2toP1

	P1toP2:

		# Store registers in program1 context
		#sw x0, 1200, x0        # Don't store hardwired 0
		sw x1,  1204, x0
		sw x2,  1208, x0
		#sw x3, 1212, x0        # Don't store global pointer 
		#sw x4, 1216, x0        # Don't store thread pointer 
		sw x5,  1220, x0
		sw x6,  1224, x0
		sw x7,  1228, x0
		sw x8,  1232, x0
		sw x9,  1236, x0
		sw x10, 1240, x0
		sw x11, 1244, x0
		sw x12, 1248, x0
		sw x13, 1252, x0
		sw x14, 1256, x0
		sw x15, 1260, x0
		sw x16, 1264, x0
		sw x17, 1268, x0
		sw x18, 1272, x0
		sw x19, 1276, x0
		sw x20, 1280, x0
		sw x21, 1284, x0
		sw x22, 1288, x0
		sw x23, 1292, x0
		sw x24, 1296, x0
		sw x25, 1300, x0
		sw x26, 1304, x0
		sw x27, 1308, x0
		sw x28, 1312, x0
		sw x29, 1316, x0
		sw x30, 1320, x0
		sw x31, 1324, x0

		# Load registers from program2 context
		#lw x0, 1400, x0        # Don't load hardwired 0
		lw x1,  1404, x0
		lw x2,  1408, x0
		#lw x3, 1412, x0        # Don't load global pointer
		#lw x4, 1416, x0        # Don't load thread pointer
		lw x5,  1420, x0
		lw x6,  1424, x0
		lw x7,  1428, x0
		lw x8,  1432, x0
		lw x9,  1436, x0
		lw x10, 1440, x0
		lw x11, 1444, x0
		lw x12, 1448, x0
		lw x13, 1452, x0
		lw x14, 1456, x0
		lw x15, 1460, x0
		lw x16, 1464, x0
		lw x17, 1468, x0
		lw x18, 1472, x0
		lw x19, 1476, x0
		lw x20, 1480, x0
		lw x21, 1484, x0
		lw x22, 1488, x0
		lw x23, 1492, x0
		lw x24, 1496, x0
		lw x25, 1500, x0
		lw x26, 1504, x0
		lw x27, 1508, x0
		lw x28, 1512, x0
		lw x29, 1516, x0
		lw x30, 1520, x0
		lw x31, 1524, x0

		li tp, 1               # Update thread pointer to 1 (Program2 id)
		
		sw tp, 0, gp           # Write 1 to WatchdogTimerBegin 

		ret                    # Jump to return address (program 2 pc)


	P2toP1:

		# Store registers to program2 context
		#sw x0, 1400, x0        # Don't store hardwired 0
		sw x1,  1404, x0
		sw x2,  1408, x0
		#sw x3, 1412, x0        # Don't store global pointer
		#sw x4, 1416, x0        # Don't store thread pointer
		sw x5,  1420, x0
		sw x6,  1424, x0
		sw x7,  1428, x0
		sw x8,  1432, x0
		sw x9,  1436, x0
		sw x10, 1440, x0
		sw x11, 1444, x0
		sw x12, 1448, x0
		sw x13, 1452, x0
		sw x14, 1456, x0
		sw x15, 1460, x0
		sw x16, 1464, x0
		sw x17, 1468, x0
		sw x18, 1472, x0
		sw x19, 1476, x0
		sw x20, 1480, x0
		sw x21, 1484, x0
		sw x22, 1488, x0
		sw x23, 1492, x0
		sw x24, 1496, x0
		sw x25, 1500, x0
		sw x26, 1504, x0
		sw x27, 1508, x0
		sw x28, 1512, x0
		sw x29, 1516, x0
		sw x30, 1520, x0
		sw x31, 1524, x0


		# Load registers from program1 context
		#lw x0, 1200, x0        # Don't load hardwired 0
		lw x1,  1204, x0
		lw x2,  1208, x0
		#lw x3, 1212, x0        # Don't load global pointer     
		#lw x4, 1216, x0        # Don't load thread pointer 
		lw x5,  1220, x0
		lw x6,  1224, x0
		lw x7,  1228, x0
		lw x8,  1232, x0
		lw x9,  1236, x0
		lw x10, 1240, x0
		lw x11, 1244, x0
		lw x12, 1248, x0
		lw x13, 1252, x0
		lw x14, 1256, x0
		lw x15, 1260, x0
		lw x16, 1264, x0
		lw x17, 1268, x0
		lw x18, 1272, x0
		lw x19, 1276, x0
		lw x20, 1280, x0
		lw x21, 1284, x0
		lw x22, 1288, x0
		lw x23, 1292, x0
		lw x24, 1296, x0
		lw x25, 1300, x0
		lw x26, 1304, x0
		lw x27, 1308, x0
		lw x28, 1312, x0
		lw x29, 1316, x0
		lw x30, 1320, x0
		lw x31, 1324, x0

		sw tp, 0, gp           # Write 1 to WatchdogTimerBegin 

		li tp, 0               # Update thread pointer to 0 (Program1 id)

		ret                    # Jump to return address (program 1 pc)

	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
		

Program1:          # Finds the sum of the factors for each natural number starting from 1 and working upwards
	li a0, 1
	li t0, 1            # t0 is current value
	
	loop2:
		li t1, 0         # t1 is factor sum for current value
		li t2, 1         # t2 is i
		
		outerloop2:
			bgt t2, t0, doneouter2
			li t3, 0      # t3 is flag
			li t4, 1      # t4 is j
			
			innerloop2:
				bgt t4, t0, doneinner2
			
				mul t5, t2, t4 # t5 holds result
				bne t5, t0, skip2
				li t3, 1

				skip2:
				addi t4, t4, 1
				j innerloop2

		doneinner2:
			beq t3, x0, skipAdd2
			add t1, t1, t2			

		skipAdd2:
			addi t2, t2, 1
			j outerloop2

	doneouter2:
		mv a1, t1        # move factor sum to a1 and print
		ecall
		addi t0, t0, 1   # increment current value

	j loop2

	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop




Program2:                                   # Finds every prime number starting from 2 and working up
	li a0, 1
	li t0, 2        #t0 is value

	loop:

		li t2, 1                     #t2 is i
		outerloop:
			
			ecall
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
	addi sp, sp, 4
	sw ra, 0, sp

	mv a1, t0
	ecall
	
	lw ra, 0, sp
	addi sp, sp, -4
	ret
