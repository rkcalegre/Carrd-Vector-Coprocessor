ADDI x5, x0, 0              # store data address - load data from m[0]
ADDI x6, x0, 0              # anSWer comparer
ADDI x7, x0, 0              # looper
ADDI x30, x0, 3         
SLLI x30, x30, 4
ADDI x30, x30, 1
SLLI x30, x30, 4            # max loop = 784 = 28*28 dataset
ADDI x28, x0, 15            # value for a
jal, x0, linear_activation

linear_activation:          # f(x) = x
    BEQ x7, x30, end
    LH x27, 0(x5)
    ADDI x19, x27, 0
    SH x19, 0(x5)
    ADDI x7, x7, 1
    ADDI x5, x5, 1          # data_address++ 
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

