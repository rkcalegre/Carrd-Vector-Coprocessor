ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 16    # 32 bit elements 128-bit vector
ADDI x1, x0, 4
ADDI x2, x0, 8
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vle32.v v0, x0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vle32.v v1, x1
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vmul.vv v2, v0, v1
ADDI x2, x0, 8
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vredsum.vs v3, v2, v4   #v4 is a zero vector
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v3, x2
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
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

#inputs
#m[0-3] = v0 = 00000004 00000003 00000002 00000001
#m[7-4] = v1 = 00000005 00000006 00000007 00000008
#m[12-9] = v3 = ffffffff ffffffff ffffffff 0000003c expected ouput 0000003c
# v2 = 00000014 00000012 0000000e 00000008 
