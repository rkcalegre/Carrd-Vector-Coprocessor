ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 18    # 32 bit elements 512-bit vector
ADDI x1, x0, 16
ADDI x2, x0, 32
vle32.v v0, x0
vle32.v v4, x1
vmul.vv v8, v0, v4
vredsum.vs v12, v8, v28   #v28 is a zero vector
vse32.v v8, x0          # m [x0 = 0]    
ADDI x1, x0, 16
C.NOP
C.NOP
C.NOP
vse32.v v12, x1         # m [x1 = 16]
vsetivli x20, x5, 10    # 16 bit elements 512-bit vector
vmul.vv v8, v0, v4
vredsum.vs v12, v8, v28   #v28 is a zero vector
ADDI x2, x0, 32
C.NOP
C.NOP
C.NOP
vse32.v v8, x2          # m [x2 = 32]
ADDI x3, x0, 48
C.NOP
C.NOP
C.NOP
vse32.v v12, x3         # m [x3 = 48]
vsetivli x20, x5, 2     # 8 bit elements 512-bit vector
vmul.vv v8, v0, v4
vredsum.vs v12, v8, v28   #v28 is a zero vector
ADDI x4, x0,64
C.NOP
C.NOP
C.NOP
vse32.v v8, x4          # m [x4 = 64]
ADDI x5, x0, 80
vse32.v v12, x5         #m m [x5 = 80]
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
