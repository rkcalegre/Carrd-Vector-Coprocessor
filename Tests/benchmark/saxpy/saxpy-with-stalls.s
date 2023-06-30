ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 18    # 32 bit elements 512-bit vector
ADDI x1, x0, 16
ADDI x10, x0, 7         #assigning value of a
C.NOP
C.NOP
C.NOP
vle32.v v0, x0          #assigning vector x
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vle32.v v4, x1          #assigning vector y
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vmul.vx v8, v0, x10      #perform multiply a*x
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vv v12, v8, v4         #perform add (ax) + y
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v12, x0
C.NOP
C.NOP
C.NOP
C.NOP
vsetivli x20, x5, 10    # 16 bit elements 512-bit vector
C.NOP
C.NOP
vmul.vx v8, v0, x10      #perform multiply a*x
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vv v12, v8, v4         #perform add (ax) + y
ADDI x1, x0, 16
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v12, x1
C.NOP
C.NOP
C.NOP
C.NOP
vsetivli x20, x5, 2     # 8 bit elements 512-bit vector
C.NOP
C.NOP
vmul.vx v8, v0, x10      #perform multiply a*x
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vv v12, v8, v4         #perform add (ax) + y
ADDI x2, x0, 32
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v12, x2
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
