ADDI x5, x0, 16         # x5 = 16
ADDI x1, x0, 16
vsetivli x20, x5, 18    # 32 bit elements 512-bit vector
vle32.v v0, x0
ADDI x2, x0, 4
vle32.v v4, x1
ADDI x2, x2, 4
vmul.vv v8, v0, v4
ADDI x2, x2, 4
vredsum.vs v12, v8, v28   #v28 is a zero vector
vse32.v v12, x0
ADDI x2, x2, 4
vsetivli x20, x5, 10    # 16 bit elements 512-bit vector
vmul.vv v8, v0, v4
ADDI x2, x2, 4
vredsum.vs v12, v8, v28   #v28 is a zero vector
ADDI x2, x2, 4
vse32.v v12, x1
ADDI x2, x2, 8
vsetivli x20, x5, 2     # 8 bit elements 512-bit vector
vmul.vv v8, v0, v4
vredsum.vs v12, v8, v28   #v28 is a zero vector
vse32.v v12, x2
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
