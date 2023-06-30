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

# write answer to answerkey file
with open('answerkey-linear.mem', 'w') as f:
    for data in dataset_raw:
        f.write(data)
        f.write("\n")

answers_16b = split_16b(dataset_raw)

with open('answerkey-linear-16b.mem', 'w') as f:
    for answer in answers_16b:
        f.write(answer)
        f.write("\n")