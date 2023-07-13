ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 18    # 32 bit elements 512-bit vector
ADDI x1, x0, 16
ADDI x2, x0, 32
ADDI x10, x0, 7         #assigning value of a
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vle32.v v0, x0          #assigning vector x
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vle32.v v4, x1          #assigning vector y
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vmul.vx v8, v0, x10      #perform multiply a*x
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vadd.vv v12, v8, v4         #perform add (ax) + y
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v12, x0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vsetivli x20, x5, 10    # 16 bit elements 512-bit vector
addi x0, x0, 0
addi x0, x0, 0
vmul.vx v8, v0, x10      #perform multiply a*x
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vadd.vv v12, v8, v4         #perform add (ax) + y
ADDI x1, x0, 16
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v12, x1
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vsetivli x20, x5, 2     # 8 bit elements 512-bit vector
addi x0, x0, 0
addi x0, x0, 0
vmul.vx v8, v0, x10      #perform multiply a*x
vadd.vv v12, v8, v4         #perform add (ax) + y
ADDI x2, x0, 32
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
