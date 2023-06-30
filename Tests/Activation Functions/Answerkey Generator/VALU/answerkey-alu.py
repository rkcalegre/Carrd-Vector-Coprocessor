import sys
import pandas as pd                     # used for reading excel files
from argparse import ArgumentParser

#argparser = ArgumentParser()
#argparser.add_argument('input_file', help='Input filename')

#args = argparser.parse_args(sys.argv[1:])

#filename = args.input_file
#print(filename)

answers = []
padding = 8

# change this for different lmul settings
# assume vsew = 32
# lmul = 0: 4
# lmul = 1: 8
# lmul = 2: 16
num_tests = 4


# read excel file and extract data 
# note that the extracted data is in hexadecimal format
excel_data = pd.read_excel(r'../VALU_Dataset.xlsx')
v1_raw = excel_data['v1'].values
#print(v1_raw)
v2_raw = excel_data['v2'].values
#print(v2_raw)
x_raw = excel_data['x'].values
imm_raw = excel_data['imm'].values

def convert_hex(hex_array):
    # converts raw hex data to decimal
    int_array = []
    for index, hex_elem in zip(range(num_tests), hex_array):
        int_elem = int(hex_elem, base=16)
        int_array.append(int_elem)
    return int_array

def vadd(v1, v2, x, imm):
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 + elem_v2)
    
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 + x)

    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 + imm)

def vsub(v1, v2, x, imm):
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 - elem_v1)
    
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 - x)

def vand(v1, v2, x, imm):
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 & elem_v1)
    
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 & x)

    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 & imm)

def vor(v1, v2, x, imm):
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 | elem_v1)
    
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 | x)

    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 | imm)

def vxor(v1, v2, x, imm):
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 ^ elem_v1)
    
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 ^ x)

    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 ^ imm)

def vsll(v1, v2, x, imm):
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 << elem_v1)
    
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 << x[0])

    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 << imm)

def vsrl(v1, v2, x, imm):
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 >> elem_v1)
    
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 >> x[0])

    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 >> imm)

def vsra(v1, v2, x, imm):
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 >> elem_v1)
    
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 >> x[0])

    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 >> imm)

def vmin(v1, v2, x, imm):
    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 < elem_v1:
            answers.append(elem_v2)
        else:
            answers.append(elem_v1)
    
    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 < x[0]:
            answers.append(elem_v2)
        else:
            answers.append(x[0])

def vmax(v1, v2, x, imm):
    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 > elem_v1:
            answers.append(elem_v2)
        else:
            answers.append(elem_v1)
    
    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 > x[0]:
            answers.append(elem_v2)
        else:
            answers.append(x[0])

def vmseq(v1, v2, x, imm):
    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 == elem_v1:
            answers.append(1)
        else:
            answers.append(0)
    
    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 == x[0]:
            answers.append(1)
        else:
            answers.append(0)

    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 == imm:
            answers.append(1)
        else:
            answers.append(0)

def vmsne(v1, v2, x, imm):
    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 != elem_v1:
            answers.append(1)
        else:
            answers.append(0)
    
    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 != x[0]:
            answers.append(1)
        else:
            answers.append(0)

    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 != imm:
            answers.append(1)
        else:
            answers.append(0)

def vmslt(v1, v2, x, imm):
    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 < elem_v1:
            answers.append(1)
        else:
            answers.append(0)
    
    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 < x[0]:
            answers.append(1)
        else:
            answers.append(0)

def vmsle(v1, v2, x, imm):
    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 <= elem_v1:
            answers.append(1)
        else:
            answers.append(0)
    
    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 <= x[0]:
            answers.append(1)
        else:
            answers.append(0)

    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 <= imm:
            answers.append(1)
        else:
            answers.append(0)

def vmsgt(v1, v2, x, imm):
    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 > x[0]:
            answers.append(1)
        else:
            answers.append(0)

    for elem_v1, elem_v2 in zip(v1, v2):
        if elem_v2 > imm:
            answers.append(1)
        else:
            answers.append(0)

def vmul(v1, v2, x, imm):
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 * elem_v1)
    
    for elem_v1, elem_v2 in zip(v1, v2):
        answers.append(elem_v2 * x[0])

def convert_int(arr):
    # format answer
    int_arr = []
    for elem in arr: 
        print(elem) 
        elem = hex(elem)[2:]                  
        elem = f"{elem:0{padding}}"       # ensures that the hex answer is formatted to have 8 digits
        if len(elem) > 8:
            elem = elem[len(elem) - 8:]
        int_arr.append(elem)
    return int_arr

# convert dataset
v1 = convert_hex(v1_raw)
#v2 = convert_hex(v2_raw)
v2 = v2_raw
x = convert_hex(x_raw)
imm = int(imm_raw[0], base=16)
vadd(v1, v2, x, imm)
vsub(v1, v2, x, imm)
vand(v1, v2, x, imm)
vor(v1, v2, x, imm)
vxor(v1, v2, x, imm)
vsll(v1, v2, x, imm)
vsrl(v1, v2, x, imm)
vsra(v1, v2, x, imm)
vmin(v1, v2, x, imm)
vmax(v1, v2, x, imm)
vmseq(v1, v2, x, imm)
vmsne(v1, v2, x, imm)
vmslt(v1, v2, x, imm)
vmsle(v1, v2, x, imm)
vmsgt(v1, v2, x, imm)
vmul(v1, v2, x, imm)
answers = convert_int(answers)


# write answer to answerkey file
with open('answerkey-valu.mem', 'w') as f:
    for answer in answers:
        f.write(answer)
        f.write("\n")