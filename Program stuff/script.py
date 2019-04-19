import os
import sys

dir_path = os.path.dirname(os.path.realpath(__file__))
inputFile = os.path.join(dir_path,'input.txt')

try:
	with open(inputFile,'r') as f:
		input = f.readlines()
except FileNotFoundError:
	print('input.txt missing!')
	sys.exit(1)
	
code3 = []
code2 = []
code1 = []
code0 = []
for line in input:
	code0.append(line[24:32])
	code1.append(line[16:24])
	code2.append(line[8:16])
	code3.append(line[0:8])
	
with open('output.txt', 'w+') as file:
	
	file.write('out_3:\n')
	for line in code3:	
		file.write(line)
		file.write('\n')
	file.write('\n')		
	
	file.write('\n\nout_2:\n')	
	for line in code2:
		file.write(line)
		file.write('\n')
	file.write('\n')
		
	file.write('\n\nout_1:\n')
	for line in code1:
		file.write(line)
		file.write('\n')
	file.write('\n')

	file.write('\n\nout_0:\n')		
	for line in code0:
		file.write(line)
		file.write('\n')
	file.write('\n')
	
	
print('Finished!')