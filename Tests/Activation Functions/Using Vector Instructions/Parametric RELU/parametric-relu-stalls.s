addi x5, x0, 16             # x5 = 16
C.NOP
C.NOP
C.NOP
vsetivli x20, x5, 10        # 16-bit elements, 512-bit vector
addi x28, x0, 0             # store data address - load data from m[0]
addi x18, x0, 15            # value for a
addi x9, x0, 28             # max loop counter
addi x29, x0, 0             # looper
jal, x0, parametric_relu

parametric_relu:            # f(x) = max(ax , x)
    beq x29, x9, end
    vle32.v v4, x28
    vmul.vx v8, v4, x18     # v8 = ax
    C.NOP
    C.NOP
    vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
    C.NOP
    C.NOP
    vse32.v v12, x28
    addi x29, x29, 1        # loop_iter++
    addi x28, x28, 16       # address++
    C.NOP
    C.NOP
    C.NOP
    C.NOP
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

