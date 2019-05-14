li t0, 5
li t1, -5

sltu t2, t1, t0
bgt t2, x0, skip

li a1, 50

skip:
slt t2, t1, t0
bgt t2, x0, end

addi a1, a1, 25

end:
li a0, 1
ecall