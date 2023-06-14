ADDI x5, x0, 16
vsetivli x20, x5, 18 #32 bit elements 512-bit vector
ADDI x5, x5, 16
C.NOP
C.NOP
C.NOP
#vle32.v v4, x0 #load first vector to v4
vadd.vi v4, v0, 15 
ADDI x1, x0, 64
C.NOP
C.NOP
C.NOP
C.NOP
#32 bit save tests
vse32.v v4, x1
ADDI x1, x1, 64
C.NOP
C.NOP
C.NOP
C.NOP
vse16.v v4, x1
ADDI x1, x1, 32
C.NOP
C.NOP
C.NOP
C.NOP
vse8.v v4, x1
ADDI x1, x1, 16
vsetivli x20, x5, 10 #16 bit elements 512-bit vector
ADDI x5, x5, 16
ADDI x5, x5, 16
C.NOP
C.NOP
vse16.v v4, x1
ADDI x1, x1, 64
C.NOP
C.NOP
C.NOP
C.NOP
vse8.v v4, x1
ADDI x1, x1, 32
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v4, x1
ADDI x1, x1, 128
vsetivli x20, x5, 2 #8 bit elements 512-bit vector
C.NOP
C.NOP
C.NOP
C.NOP
vse8.v v4, x1
ADDI x1, x1, 64
C.NOP
C.NOP
C.NOP
C.NOP
vse16.v v4, x1
ADDI x1, x1, 128
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v4, x1
ADDI x1, x1, 256
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