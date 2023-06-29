addi x5, x0, 16             # x5 = 16
C.NOP
C.NOP
C.NOP
vsetivli x20, x5, 18        # 32-bit elements, 512-bit vector
addi x1, x0, 0         `    # store data address - load data from m[0]
addi x2, x0, 15             # value for a
jal, x0, parametric_relu

parametric_relu:            # f(x) = max(ax , x)
    vle32.v v4, x1
    vmul.vx v8, v4, x2      # v8 = ax
    vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
    vse32.v v12, x1
    jal, x0, end

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

