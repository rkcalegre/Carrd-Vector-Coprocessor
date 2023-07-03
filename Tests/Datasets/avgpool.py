import os
import matplotlib.pyplot

os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras.datasets import mnist 
from tensorflow.keras.datasets import fashion_mnist 
import tensorflow_datasets as tfds

(x_train, y_train), (x_test, y_test) = fashion_mnist.load_data()
#print(x_train[7580])
#print(y_train.shape)

answerkey_raw = []
answerkey = []
answerkey_16b = []

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

dataset_raw = x_train[7580]
print(dataset_raw)
paddings = tf.constant([[2,2,],[2,2]])
dataset_raw = tf.pad(dataset_raw, paddings, "CONSTANT")
x = tf.reshape(dataset_raw, [1, 32, 32, 1])
x = tf.cast(x, tf.double)
avg_pool_2d = tf.keras.layers.AveragePooling2D(pool_size=(4, 4), strides=(4, 4), padding='VALID')
print(avg_pool_2d(x))

answerkey_raw = avg_pool_2d(x)

for kernel in answerkey_raw:
    for arr in kernel:
        for elem_raw in arr:
            #print(elem_raw[0])
            elem_rnd = int(elem_raw[0])
            print(elem_rnd)
            elem = hex(elem_rnd)[2:]
            elem = elem.zfill(8)
            answerkey.append(str(elem))

answerkey_16b = split_16b(answerkey)

with open('avgpool_AK.txt', 'w') as f:
    for answer in answerkey_16b:
        f.write(answer)
        f.write("\n")