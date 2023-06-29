addi x5, x0, 0          # store data address - load data from m[0]
addi x6, x0, 0          # answer comparer
addi x7, x0, 0          # looper
addi x30, x0, 16        # max loop
jal, x0, relu

relu:                   # f(x) = max(0 , x)
    beq x7, x30, end
    lw x18, 0(x5)
    slt x19, x18, x6    # R[rd] = (rs1 < rs2) ? 1 : 0
    slli x19, x19, 31
    srai x19, x19, 31
    and x19, x19, x18
    addi x7, x7, 1
    sw x19, 0(x5)
    addi x5, x5, 1      # data_address++ 
    jal, x0, relu

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

