ADDI x5, x0, 16         # x5 = 16
ADDI x1, x0, 16
ADDI x2, x0, 32
vsetivli x20, x5, 18    # 32 bit elements 512-bit vector
vle32.v v0, x0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
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
vmul.vv v8, v0, v4
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vredsum.vs v12, v8, v28   #v28 is a zero vector
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v12, x0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vsetivli x20, x5, 10    # 16 bit elements 512-bit vector
vmul.vv v8, v0, v4
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vredsum.vs v12, v8, v28   #v28 is a zero vector
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v12, x1
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vsetivli x20, x5, 2     # 8 bit elements 512-bit vector
vmul.vv v8, v0, v4
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vredsum.vs v12, v8, v28   #v28 is a zero vector
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
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
