ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 16    # 32 bit elements 128-bit vector
ADDI x1, x0, 16
ADDI x2, x0, 32         #assigning value of a
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vle32.v v0, x0          #assigning vector x
vle32.v v4, x1          #assigning vector b
vmul.vx v8, v0, x2      #perform multiply a*x
vadd.vv v12, v8         #perform add (ax) + y
ADDI x0, x0, 0
vse32.v v8, x0