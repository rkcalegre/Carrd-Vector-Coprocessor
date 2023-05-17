# dumpfile editor
dump = open('isr_instmem.txt', 'r')
mem = open('isr_instmem.mem', 'w')
limit = 512
lines = 0

for line in dump:
	e_list = line.split()
	e_list = e_list[1:len(e_list)-1]
	if (len(e_list) > 4):
		e_list = e_list[0:4]
		
	for entry in e_list:
		mem.write(entry[2:4] + entry[0:2] + '\n')
		lines = lines + 1
		if (len(entry) == 8):
			mem.write(entry[6:8] + entry[4:6] + '\n')
			lines = lines + 1

while (lines < limit):
	mem.write('0000\n')
	lines = lines + 1	
dump.close()
mem.close()