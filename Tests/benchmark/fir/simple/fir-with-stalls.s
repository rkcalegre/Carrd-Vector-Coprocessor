ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 18    # 32 bit elements 512-bit vector
ADDI x1, x0, 16
ADDI x2, x0, 32
ADDI x3, x0, 48
ADDI x4, x0, 64
ADDI x6, x0, 80
vle32.v v8, x2
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vle32.v v12, x3
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vmul.vv v12, v12, v12
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vv v20, v12, v8
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vle32.v v16, x4
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vmul.vv v16, v16, v16
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vle32.v v0, x0
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vv v24, v16, v0
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vle32.v v4, x1
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vv v20, v20, v4
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vv v20, v20, v24
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v20, x0
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vsetivli x20, x5, 10    # 16 bit elements 512-bit vector
vle32.v v8, x2
ADDI x3, x0, 48
C.NOP
C.NOP
C.NOP
C.NOP
vle32.v v12, x3
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vmul.vv v12, v12, v12
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vv v20, v12, v8
ADDI x4, x0, 64
C.NOP
C.NOP
C.NOP
C.NOP
vle32.v v16, x4
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vmul.vv v16, v16, v16
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vle32.v v0, x0
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vv v24, v16, v0
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vle32.v v4, x1
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vv v20, v20, v4
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vv v20, v20, v24
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v20, x1
ADDI x22, x0, 112
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vsetivli x20, x5, 2     # 8 bit elements 512-bit vector
vle32.v v8, x22
ADDI x23, x0, 128
C.NOP
C.NOP
C.NOP
C.NOP
vle32.v v12, x23
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vmul.vv v12, v12, v12
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vv v20, v12, v8
ADDI x24, x0, 144
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vle32.v v16, x24
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vmul.vv v16, v16, v16
ADDI x20, x0, 80
C.NOP
C.NOP
C.NOP
C.NOP
vle32.v v0, x20
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vv v24, v16, v0
ADDI x21, x0, 96
C.NOP
C.NOP
C.NOP
C.NOP
vle32.v v4, x21
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vv v20, v20, v4
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vv v20, v20, v24
ADDI x26, x0, 32
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v20, x26
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
