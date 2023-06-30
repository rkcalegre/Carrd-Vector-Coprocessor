addi x5, x0, 0              # store data address - load data from m[0]
addi x6, x0, 0              # answer comparer
addi x7, x0, 0              # looper
addi x30, x0, 3         
slli x30, x30, 4
addi x30, x30, 1
slli x30, x30, 4            # max loop = 784 = 28*28 dataset
addi x28, x0, 15            # value for a
jal, x0, linear_activation

linear_activation:          # f(x) = x
    lw x18, 0(x5)
    addi x19, x18, 0
    addi x7, x7, 1
    sw x19, 0(x5)
    addi x5, x5, 1          # data_address++ 
    jal, x0, linear_activation

end:
    C.NOP
    C.NOP
    C.NOP
    C.NOP
    C.NOP
    C.NOP
    C.NOP
    C.NOP
    C.NOP
    C.NOP
    C.NOP
    C.NOP
    C.NOP
    C.NOP
    C.NOP
    C.NOP
    C.NOP

