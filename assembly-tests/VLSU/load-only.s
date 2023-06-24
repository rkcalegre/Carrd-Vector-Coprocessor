ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 16     # 8-bit elements 128-bit vector
ADDI x5, x5, 16
ADDI x8, x0, 0
C.NOP
C.NOP
C.NOP
C.NOP
vle32.v v4, x8
C.NOP
C.NOP
C.NOP
C.NOP
vle16.v v8, x8
C.NOP
C.NOP
C.NOP
C.NOP
vle8.v v12, x8
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
