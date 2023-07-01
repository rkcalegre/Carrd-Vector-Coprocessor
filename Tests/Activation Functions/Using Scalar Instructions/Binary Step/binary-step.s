ADDI x8, x0, 0              # store data address - load data from m[0]
ADDI x9, x0, 1              # if greater than or equal to zero
ADDI x30, x0, 3         
SLLI x30, x30, 4
ADDI x30, x30, 1
SLLI x30, x30, 6           # max loop = 784 (28*28 dataset) * 4 (stalls for load/store)
jal, x0, binary_step


binary_step:                # f(x) = max(x, 0)
    BEQ x8, x30, end
    LW x18, 0(x8)
    BLT x18, x0, zero
    SW x9, 0(x8)
    ADDI x8, x8, 1          # data_address++ 
    jal, x0, binary_step

zero:
    SW x0, 0(x8)
    ADDI x8, x8, 1          # data_address++ 
    jal, x0, zero

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
