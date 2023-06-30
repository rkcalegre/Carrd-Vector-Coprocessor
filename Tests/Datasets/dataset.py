import os
import matplotlib.pyplot

os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras.datasets import mnist 
from tensorflow.keras.datasets import fashion_mnist 
import tensorflow_datasets as tfds

def split_16b(arr):
    row = 1
    arr1 = []
    arr2 = []
    dataset_16b = []

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
        dataset_16b.append(str(elem2) + str(elem1))

    return dataset_16b

(x_train, y_train), (x_test, y_test) = fashion_mnist.load_data()
print(x_train[7580])
#print(y_train.shape)

dataset_raw = x_train[7580]
#print(dataset_raw[0])
dataset_uint = []
dataset = []
dataset_16b = []

for pixel_row in dataset_raw:
    for pixel_col in pixel_row:
        dataset_uint.append(pixel_col)

for pixel in dataset_uint:
    pixel = hex(pixel)[2:]
    pixel = pixel.zfill(8)
    dataset.append(pixel)

""" (ds_train, ds_test), ds_info  = tfds.load(
    "mnist",
    split=["train", "test"],
    shuffle_files=True,
    as_supervised=True,
    with_info=True
)

def output_data(image, label):
    return tf.cast(image, tf.float32), label

#print(ds_info)
print(ds_train)
print(ds_test) """

with open('fashion_mnist_data2.txt', 'w') as f:
    for data in dataset:
        f.write(data)
        f.write("\n")

dataset_16b = split_16b(dataset)

with open('fashion_mnist_data2_16b.txt', 'w') as f:
    for data in dataset_16b:
        f.write(data)
        f.write("\n")