ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 16    # 32 bit elements 128-bit vector
ADDI x1, x0, 16
ADDI x2, x0, 32
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vle32.v v0, x0
vle32.v v4, x1
vmul.vv v8, v0, v4
ADDI x0, x0, 0
vse32.v v8, x0