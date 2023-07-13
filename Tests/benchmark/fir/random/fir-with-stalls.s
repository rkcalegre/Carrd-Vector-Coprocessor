ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 18    # 32 bit elements 512-bit vector
ADDI x1, x0, 16
ADDI x2, x0, 32
ADDI x3, x0, 48
ADDI x4, x0, 64
ADDI x6, x0, 80
vle32.v v8, x2
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vle32.v v12, x3
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vmul.vv v12, v12, v12
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vadd.vv v20, v12, v8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vle32.v v16, x4
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vmul.vv v16, v16, v16
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vle32.v v0, x0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vadd.vv v24, v16, v0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vle32.v v4, x1
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vadd.vv v20, v20, v4
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vadd.vv v20, v20, v24
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v20, x0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
