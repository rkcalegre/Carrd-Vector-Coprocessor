addi x5, x0, 0              # store data address - load data from m[0]
addi x6, x0, 0              # answer comparer
addi x7, x0, 0              # looper
addi x30, x0, 16            # max loop
addi x28, x0, 15            # value for a
jal, x0, parametric_relu

parametric_relu:            # f(x) = max(ax , x)
    beq x7, x30, end
    lw x18, 0(x5)
    mul x19, x18, x28       # x19 = ax
    slt x20, x19, x18       # R[rd] = (rs1 < rs2) ? 1 : 0
    slli x20, x20, 31
    srai x20, x20, 31
    beq x20, x6, skip
    and x21, x20, x19
    addi x7, x7, 1
    sw x21, 0(x5)
    addi x5, x5, 1          # data_address++ 
    jal, x0, parametric_relu

skip:
    addi x20, x20, 1
    slli x20, x20, 31
    srai x20, x20, 31
    and x21, x20, x18
    addi x7, x7, 1
    sw x21, 0(x5)
    addi x5, x5, 1          # data_address++ 
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

