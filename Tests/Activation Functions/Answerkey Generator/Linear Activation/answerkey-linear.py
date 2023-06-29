import sys
import pandas as pd                     # used for reading excel files
from argparse import ArgumentParser

#argparser = ArgumentParser()
#argparser.add_argument('input_file', help='Input filename')

#args = argparser.parse_args(sys.argv[1:])

#filename = args.input_file
#print(filename)

answers = []
dataset = []
padding = 8

# read excel file and extract data 
# note that the extracted data is in hexadecimal format
excel_data = pd.read_excel(r'../Input_Dataset.xlsx')
dataset_raw = excel_data['Input Data'].values

#s1 = pd.DataFrame(data, columns=['product_name'])
#s2 = pd.DataFrame(data, columns=['product_name']) # comment out this line if you need two operands

# write answer to answerkey file
with open('answerkey-linear.mem', 'w') as f:
    for data in dataset_raw:
        f.write(data)
        f.write("\n")