ADDI x8, x0, 0              # store data address - load data from m[0]
ADDI x7, x0, 0              # looper
ADDI x30, x0, 3         
SLLI x30, x30, 4
ADDI x30, x30, 1
SLLI x30, x30, 6           # max loop = 784 (28*28 dataset) * 4 (stalls for load/store)
ADDI x28, x0, 4            # value for a
jal, x0, parametric_relu


parametric_relu:                # f(x) = max(ax, 0)
    BEQ x8, x30, end
    LW x18, 0(x8)
    MUL x19, x18, x28
    BLT x19, x18, less_than
    SW x19, 0(x8)
    ADDI x8, x8, 1          # data_address++ 
    jal, x0, parametric_relu

less_than:
    SW x18, 0(x8)
    ADDI x8, x8, 1          # data_address++ 
    jal, x0, parametric_relu

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
