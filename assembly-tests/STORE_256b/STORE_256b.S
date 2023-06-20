ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 17    # 32 bit elements 256-bit vector
ADDI x5, x5, 16         # x5 = x5 + 16 = 32
C.NOP
C.NOP
C.NOP
vadd.vi v4, v0, 15      # v4 = 15
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vi v7, v0, 10
ADDI x1, x0, 0          # x1 = 0
C.NOP
C.NOP
C.NOP
C.NOP
#32 bit save tests
vse32.v v4, x1         # m[x1 = 0] = v4 = 15 
ADDI x1, x1, 8         # x1 = x1 + 8 = 0 + 8 = 8
C.NOP
C.NOP
C.NOP
C.NOP
vse16.v v7, x1          # m[x1 = 8] = 15
ADDI x1, x1, 8         # x1 = x1 + 8 = 8 + 8 = 16
C.NOP
C.NOP
C.NOP
C.NOP
vse8.v v4, x1           # m[x1 = 16] = 15
ADDI x1, x1, 8          # x1 = x1 + 8 = 16 + 8 = 24
vsetivli x20, x5, 9     # 16 bit elements 256-bit vector
ADDI x5, x5, 16
ADDI x5, x5, 16
C.NOP
C.NOP
vse16.v v7, x1          # m[x1 = 24] = 15
ADDI x1, x1, 8         #  x1 = x1 + 8 = 24 + 8 = 32
C.NOP
C.NOP
C.NOP
C.NOP
vse8.v v4, x1           # m[x1 = 32] = 15
ADDI x1, x1, 8          # x1 = x1 + 8 = 32 + 8 = 40
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v7, x1          # m[x1 = 40] = 15
ADDI x1, x1, 8          # x1 = x1 + 8 = 40 + 8 = 48
vsetivli x20, x5, 1     # 8 bit elements 256-bit vector
C.NOP
C.NOP
C.NOP
C.NOP
vse8.v v4, x1           # m[x1 = 48] = 15
ADDI x1, x1, 8          # x1 = x1 + 8 = 48 + 8 = 56
C.NOP
C.NOP
C.NOP
C.NOP
vse16.v v7, x1          # m[x1 = 56] = 15
ADDI x1, x1, 8          # x1 = x1 + 8 = 56 + 8 = 64
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v4, x1          # m[x1 = 64] = 15
ADDI x1, x1, 8          # x1 = x1 + 8 = 64 + 8 = 72
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