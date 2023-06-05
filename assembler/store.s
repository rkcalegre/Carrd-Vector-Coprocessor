ADDI x5, x0, 16     # x5 = 16
#vsetivli x20, x5, 18 #32 bit elements 512-bit vector
vsetivli x20, x5, 16 #32 bit elements, 128-bit vector
ADDI x5, x5, 16     # x5 = x5 + 16 = 32
C.NOP
C.NOP
C.NOP
#vle32.v v4, x0 #load first vector to v4
vadd.vi v4, v0, 15 # v4 = 15
ADDI x1, x0, 0    # x1 = 0
C.NOP
C.NOP
C.NOP
C.NOP
#32 bit save tests
vse32.v v4, x1     # m[x1 = 0] = v4 = 15 
ADDI x1, x1, 4    # x1 = x1 + 4 = 0 + 4 = 4
C.NOP
C.NOP
C.NOP
C.NOP
vse16.v v4, x1     # m[x1 = 4] = 15
ADDI x1, x1, 4    # x1 = x1 + 4 = 4 + 4 = 8
C.NOP
C.NOP
C.NOP
C.NOP
vse8.v v4, x1      # m[x1 = 8] = 15
ADDI x1, x1, 4    # x1 = x1 + 4 = 8 + 4 = 12
#vsetivli x20, x5, 10 #16 bit elements 512-bit vector
vsetivli x20, x5, 8 #16 bit elements, 128-bit vector
ADDI x5, x5, 16
ADDI x5, x5, 16
C.NOP
C.NOP
vse16.v v4, x1     # m[x1 = 12] = 15
ADDI x1, x1, 4    # x1 = x1 + 4 = 12 + 4 = 16
C.NOP
C.NOP
C.NOP
C.NOP
vse8.v v4, x1      # m[x1 = 16] = 15
ADDI x1, x1, 4    # x1 = x1 + 4 = 16 + 4 = 20
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v4, x1     # m[x1 = 20] = 15
ADDI x1, x1, 4   # x1 = x1 + 4 = 20 + 4 = 24
#vsetivli x20, x5, 2 #8 bit elements 512-bit vector
vsetivli x20, x5, 2 #8 bit elements 128-bit vector
C.NOP
C.NOP
C.NOP
C.NOP
vse8.v v4, x1      # m[x1 = 24] = 15
ADDI x1, x1, 4    # x1 = x1 + 4 = 24 + 4 = 28
C.NOP
C.NOP
C.NOP
C.NOP
vse16.v v4, x1     # m[x1 = 28] = 15
ADDI x1, x1, 4   # x1 = x1 + 4 = 28 + 4 = 32
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v4, x1     # m[x1 = 32] = 15
ADDI x1, x1, 4   # x1 = x1 + 4 = 32 + 4 = 36
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