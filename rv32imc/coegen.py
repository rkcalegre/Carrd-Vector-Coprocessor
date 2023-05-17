# dumpfile editor
dump = open('datamem.txt', 'r')
mem = open('datamem.coe', 'w')
mem.write('memory_initialization_radix=16;\n')
mem.write('memory_initialization_vector=')

for line in dump:
	e_list = line.split()
	e_list = e_list[1:len(e_list)-1]
	if (len(e_list) > 4):
		e_list = e_list[0:4]
	for entry in e_list:
		mem.write(entry.rjust(8, '0') + ' ')
mem.write(';')	
dump.close()
mem.close()