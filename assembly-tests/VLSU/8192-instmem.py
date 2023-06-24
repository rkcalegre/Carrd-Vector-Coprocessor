import sys
from argparse import ArgumentParser

argparser = ArgumentParser()
argparser.add_argument('input_file', help='Input filename')

args = argparser.parse_args(sys.argv[1:])

filename = args.input_file
print(filename)


with open(filename, 'r') as instmem_file:
	lines = len(instmem_file.readlines())
	print('Total Number of lines:', lines)
""" for count, line in enumerate(instmem_file):
		pass 
	print('Total Number of lines:', count + 1)
	lines = count + 1"""

with open(filename, 'a+') as instmem_file:
	instmem_file.write('\n')
	while lines < 8192:
		instmem_file.write('0000'+ '\n')
		lines = lines + 1
	print('done writing to ' + filename)
	
