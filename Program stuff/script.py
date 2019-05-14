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
	#print(line[0:32])
	if line[0:32] == '00000000000000000000000000010011':             #noop
		print('worked')
		code0.append('00000000')
		code1.append('00000000')
		code2.append('00000000')
		code3.append('00000000')
	else:
		code0.append(line[24:32])
		code1.append(line[16:24])
		code2.append(line[8:16])
		code3.append(line[0:8])
	
counter = 0
with open('MemoryModule3.mif', 'w+') as file:
	file.write('WIDTH=8;\nDEPTH=1024;\n\nADDRESS_RADIX=UNS;\nDATA_RADIX=BIN;\n\nCONTENT BEGIN\n')
	for byte in code3:
		file.write('\t')
		file.write(str(counter))
		file.write('   :   ')
		file.write(byte)
		file.write(';\n')
		counter += 1
	file.write('\t[')
	file.write(str(counter))
	file.write('..1023]   :   00000000;\nEND;')
	
counter = 0
with open('MemoryModule2.mif', 'w+') as file:	
	file.write('WIDTH=8;\nDEPTH=1024;\n\nADDRESS_RADIX=UNS;\nDATA_RADIX=BIN;\n\nCONTENT BEGIN\n')
	for byte in code2:
		file.write('\t')
		file.write(str(counter))
		file.write('   :   ')
		file.write(byte)
		file.write(';\n')
		counter += 1
	file.write('\t[')
	file.write(str(counter))
	file.write('..1023]   :   00000000;\nEND;')
	
counter = 0	
with open('MemoryModule1.mif', 'w+') as file:
	file.write('WIDTH=8;\nDEPTH=1024;\n\nADDRESS_RADIX=UNS;\nDATA_RADIX=BIN;\n\nCONTENT BEGIN\n')
	for byte in code1:
		file.write('\t')
		file.write(str(counter))
		file.write('   :   ')
		file.write(byte)
		file.write(';\n')
		counter += 1
	file.write('\t[')
	file.write(str(counter))
	file.write('..1023]   :   00000000;\nEND;')

counter = 0
with open('MemoryModule0.mif', 'w+') as file:
	file.write('WIDTH=8;\nDEPTH=1024;\n\nADDRESS_RADIX=UNS;\nDATA_RADIX=BIN;\n\nCONTENT BEGIN\n')
	for byte in code0:
		file.write('\t')
		file.write(str(counter))
		file.write('   :   ')
		file.write(byte)
		file.write(';\n')
		counter += 1
	file.write('\t[')
	file.write(str(counter))
	file.write('..1023]   :   00000000;\nEND;')
	
	
print('Finished!')