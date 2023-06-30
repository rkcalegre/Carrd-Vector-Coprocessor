import sys
import pandas as pd                     # used for reading excel files
from argparse import ArgumentParser

#argparser = ArgumentParser()
#argparser.add_argument('input_file', help='Input filename')

#args = argparser.parse_args(sys.argv[1:])

#filename = args.input_file
#print(filename)

answers = []
answers_16b = []
dataset = []
padding = 8
a = 4

# read excel file and extract data 
# note that the extracted data is in hexadecimal format
excel_data = pd.read_excel(r'../Input_Dataset.xlsx')
dataset_raw = excel_data['Input Data'].values

#s1 = pd.DataFrame(data, columns=['product_name'])
#s2 = pd.DataFrame(data, columns=['product_name']) # comment out this line if you need two operands

def split_16b(arr):
    row = 1
    arr1 = []
    arr2 = []
    answerkey_16b = []

    for elem in arr:       
        i = row % 2
        if (i == 1):
            arr1.append(elem[4:])
        elif (i == 0):
            arr2.append(elem[4:])
        row = row + 1 
        
    #print(len(arr1))
    #print(len(arr2))
    for elem1, elem2 in zip(arr1, arr2):
        #print(elem2[4:])
        answerkey_16b.append(str(elem2) + str(elem1))

    return answerkey_16b

# converts raw hex data to decimal
for data_raw in dataset_raw:
    data = int(data_raw, base=16)
    dataset.append(data)

# format answer
for data in dataset:                                # relu: f(x) = max(ax, x)
    answer_int = max(a*data, data)
    answer_hex = hex(answer_int)[2:]                # remove '0x' from beginning of the str
    answer_final = answer_hex.zfill(padding)        # ensures that the hex answer is formatted to have 8 digits
    answers.append(answer_final)

# write answer to answerkey file
with open('answerkey-paramrelu.mem', 'w') as f:
    for answer in answers:
        f.write(answer)
        f.write("\n")

answers_16b = split_16b(answers)

with open('answerkey-paramrelu-16b.mem', 'w') as f:
    for answer in answers_16b:
        f.write(answer)
        f.write("\n")