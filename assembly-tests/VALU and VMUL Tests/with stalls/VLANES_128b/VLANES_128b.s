ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 16    # 32 bit elements 128-bit vector
ADDI x5, x5, 16         # x5 = x5 + 16 = 32
C.NOP
C.NOP
C.NOP
C.NOP
################### VALU TESTS #####################
# VADD
ADDI x1, x0, 0          # Address Pointer
ADDI x2, x0, 10         # Scalar Operand for VX instructions
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vi v4, v0, 15      # v4 = 15
C.NOP
C.NOP
vadd.vi v5, v0, 20      # v5 = 20
C.NOP
C.NOP
vadd.vv v6, v5, v4      # v6 = v4 + v5
C.NOP
C.NOP
vadd.vx v7, v4, x2      # v7 = v4 + x2
C.NOP
C.NOP
vse32.v v5, x1          # m[x1 = 0] = v5 = 20
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v6, x1          # m[x1 = 4] = v6 = 35
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v7, x1          # m[x1 = 8] = v7 = 25
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP

# VSUB
vsub.vv v6, v4, v5      # v4 = 15
C.NOP
C.NOP
vsub.vx v7, v4, x2      # v5 = 20
C.NOP
C.NOP
vse32.v v6, x1          # m[x1 = 12] = v5
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v7, x1          # m[x1 = 16] = v6
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP

# VAND
vand.vv v6, v5, v4
C.NOP
C.NOP     
vand.vx v7, v4, x2
C.NOP
C.NOP      
vand.vi v8, v4, 1
C.NOP
C.NOP
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v8, x1          # m[x1 = 8] = v7
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP

# VOR
vor.vv v6, v5, v4
C.NOP
C.NOP     
vor.vx v7, v4, x2
C.NOP
C.NOP      
vor.vi v8, v4, 0
C.NOP
C.NOP
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v8, x1          # m[x1 = 8] = v7
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP

# VXOR
vxor.vv v6, v5, v4
C.NOP
C.NOP     
vxor.vx v7, v4, x2
C.NOP
C.NOP      
vxor.vi v8, v4, 0
C.NOP
C.NOP
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v8, x1          # m[x1 = 8] = v7
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP

# VSLL
ADDI x3, x0, 3
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vi v9, v0, 2
C.NOP
C.NOP
vsll.vv v6, v5, v9
C.NOP
C.NOP     
vsll.vx v7, v4, x3
C.NOP
C.NOP      
vsll.vi v8, v4, 4
C.NOP
C.NOP
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v8, x1          # m[x1 = 8] = v7
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP

# VSRL
vsrl.vv v6, v5, v9
C.NOP
C.NOP    
vsrl.vx v7, v4, x3
C.NOP
C.NOP      
vsrl.vi v8, v4, 1
C.NOP
C.NOP
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v8, x1          # m[x1 = 8] = v7
ADDI x1, x1, 4

# VSRA
vsra.vv v6, v5, v9
C.NOP
C.NOP     
vsra.vx v7, v4, x3
C.NOP
C.NOP      
vsra.vi v8, v4, 2
C.NOP
C.NOP
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v8, x1          # m[x1 = 8] = v7
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP

# VMIN
vmin.vv v6, v5, v4
C.NOP
C.NOP
vmin.vx v7, v4, x2
C.NOP
C.NOP
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP

# VMAX
vmax.vv v6, v5, v4
C.NOP
C.NOP
vmax.vx v7, v4, x2
C.NOP
C.NOP
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP

################### VMUL TESTS ######################
# VMUL
ADDI x3, x0, 2
vadd.vi v8, v0, 2
C.NOP
C.NOP
vmul.vv v6, v5, v8
C.NOP
C.NOP
vmul.vx v7, v4, x3
C.NOP
C.NOP
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 4
C.NOP
C.NOP
C.NOP
C.NOP
