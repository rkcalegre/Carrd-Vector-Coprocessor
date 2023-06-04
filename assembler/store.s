ADDI x5, x0, 16     # x5 = 16
#vsetivli x20, x5, 18 #32 bit elements 512-bit vector
vsetivli x20, x5, 16
ADDI x5, x5, 16     # x5 = x5 + 16 = 32
C.NOP
C.NOP
C.NOP
#vle32.v v4, x0 #load first vector to v4
vadd.vi v4, v0, 15 # v4 = 15
ADDI x1, x0, 0    # x1 = 64
C.NOP
C.NOP
C.NOP
C.NOP
#32 bit save tests
vse32.v v4, x1     # m[x1 = 64] = v4 = 15 
ADDI x1, x1, 4    # x1 = x1 + 64 = 64 + 64 = 128
C.NOP
C.NOP
C.NOP
C.NOP
vse16.v v4, x1     # m[x1 = 128] = 15
ADDI x1, x1, 4    # x1 = x1 + 32 = 128 + 32 = 160
C.NOP
C.NOP
C.NOP
C.NOP
vse8.v v4, x1      # m[x1 = 160] = 15
ADDI x1, x1, 4    # x1 = x1 + 16 = 160 + 16 = 176
#vsetivli x20, x5, 10 #16 bit elements 512-bit vector
vsetivli x20, x5, 8
ADDI x5, x5, 16
ADDI x5, x5, 16
C.NOP
C.NOP
vse16.v v4, x1     # m[x1 = 176] = 15
ADDI x1, x1, 4    # x1 = x1 + 64 = 176 + 64 = 240
C.NOP
C.NOP
C.NOP
C.NOP
vse8.v v4, x1      # m[x1 = 240] = 15
ADDI x1, x1, 4    # x1 = x1 + 32 = 240 + 32 = 272
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v4, x1     # m[x1 = 272] = 15
ADDI x1, x1, 4   # x1 = x1 + 128 = 272 + 128 = 400
#vsetivli x20, x5, 2 #8 bit elements 512-bit vector
vsetivli x20, x5, 2
C.NOP
C.NOP
C.NOP
C.NOP
vse8.v v4, x1      # m[x1 = 400] = 15
ADDI x1, x1, 4    # x1 = x1 + 64 = 400 + 64 = 464
C.NOP
C.NOP
C.NOP
C.NOP
vse16.v v4, x1     # m[x1 = 464] = 15
ADDI x1, x1, 4   # x1 = x1 + 128 = 464 + 128 = 592
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v4, x1     # m[x1 = 592] = 15
ADDI x1, x1, 4   # x1 = x1 + 256 = 592 + 256 = 848
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