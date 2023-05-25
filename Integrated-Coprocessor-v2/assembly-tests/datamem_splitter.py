import sys
from argparse import ArgumentParser

argparser = ArgumentParser()
argparser.add_argument('input_file', help='Input filename')

args = argparser.parse_args(sys.argv[1:])

filename = args.input_file
print(filename)

bank1 = []
bank2 = []
bank3 = []
bank4 = []
answerkey = []

with open(filename, 'r') as datamem_file:
    answerkey = datamem_file.readlines()

#print(answerkey)
def split(answerkey):
    row = 1
    bank1 = []
    bank2 = []
    bank3 = []
    bank4 = []

    for row_data in answerkey:
        
        bank = row % 4
        if (bank == 1):
            bank1.append(row_data)
        elif (bank == 2):
            bank2.append(row_data)
        elif (bank == 3):
            bank3.append(row_data)            
        elif (bank == 0):
            bank4.append(row_data)
        row = row + 1  
    return bank1, bank2, bank3, bank4


# Split to 4 banks
bank1, bank2, bank3, bank4 = split(answerkey)

with open('answerkey0.mem', 'w') as f:
    for data in bank1:
        f.write(data)

with open('answerkey1.mem', 'w') as f:
    for data in bank2:
        f.write(data)

with open('answerkey2.mem', 'w') as f:
    for data in bank3:
        f.write(data)

with open('answerkey3.mem', 'w') as f:
    for data in bank4:
        f.write(data)