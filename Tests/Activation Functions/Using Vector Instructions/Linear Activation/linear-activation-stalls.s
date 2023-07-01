addi x5, x0, 16                 # x5 = 16
addi x28, x0, 0                 # store data address - load data from m[0]
addi x9, x0, 28                  # max loop counter
addi x29, x0, 0                 # looper
vsetivli x20, x5, 10            # 16-bit elements, 512-bit vector
jal, x0, linear_activation


linear_activation:              # f(x) = x
    addi x0, x0, 0
    beq x29, x9, end
    vle32.v v4, x28
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    vadd.vi v8, v4, 0
    addi x0, x0, 0
    addi x0, x0, 0
    vse32.v v8, x28
    addi x29, x29, 1            # loop_iter++
    addi x28, x28, 16           # address++
    addi x0, x0, 0
    addi x0, x0, 0
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
