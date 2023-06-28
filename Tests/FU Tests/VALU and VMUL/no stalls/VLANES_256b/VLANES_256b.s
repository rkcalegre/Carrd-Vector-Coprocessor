ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 17    # 32 bit elements 256-bit vector
ADDI x5, x5, 16         # x5 = x5 + 16 = 32
C.NOP
C.NOP
C.NOP
################### VALU TESTS #####################
# VADD
ADDI x1, x0, 0          # Address Pointer
ADDI x2, x0, 10         # Scalar Operand for VX instructions
vadd.vi v4, v0, 15      # v4 = 15
vadd.vi v5, v0, 20      # v5 = 20
vadd.vv v6, v5, v4      # v6 = v4 + v5
vadd.vx v7, v4, x2      # v7 = v4 + x2
vse32.v v5, x1          # m[x1 = 0] = v5 = 20
ADDI x1, x1, 8
vse32.v v6, x1          # m[x1 = 4] = v6 = 35
ADDI x1, x1, 8
vse32.v v7, x1          # m[x1 = 8] = v7 = 25
ADDI x1, x1, 8         

# VSUB
vsub.vv v6, v4, v5      # v4 = 15
vsub.vx v7, v4, x2      # v5 = 20
vse32.v v6, x1          # m[x1 = 12] = v5
ADDI x1, x1, 8
vse32.v v7, x1          # m[x1 = 16] = v6
ADDI x1, x1, 8

# VAND
vand.vv v6, v5, v4     
vand.vx v7, v4, x2      
vand.vi v8, v4, 1
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 8
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 8
vse32.v v8, x1          # m[x1 = 8] = v7
ADDI x1, x1, 8

# VOR
vor.vv v6, v5, v4     
vor.vx v7, v4, x2      
vor.vi v8, v4, 0
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 8
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 8
vse32.v v8, x1          # m[x1 = 8] = v7
ADDI x1, x1, 8

# VXOR
vxor.vv v6, v5, v4     
vxor.vx v7, v4, x2      
vxor.vi v8, v4, 0
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 8
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 8
vse32.v v8, x1          # m[x1 = 8] = v7
ADDI x1, x1, 8

# VSLL
ADDI x3, x0, 3
vadd.vi v9, v0, 2
vsll.vv v6, v5, v9     
vsll.vx v7, v4, x3      
vsll.vi v8, v4, 4
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 8
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 8
vse32.v v8, x1          # m[x1 = 8] = v7
ADDI x1, x1, 8

# VSRL
vsrl.vv v6, v5, v9    
vsrl.vx v7, v4, x3      
vsrl.vi v8, v4, 1
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 8
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 8
vse32.v v8, x1          # m[x1 = 8] = v7
ADDI x1, x1, 8

# VSRA
vsra.vv v6, v5, v9     
vsra.vx v7, v4, x3      
vsra.vi v8, v4, 2
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 8
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 8
vse32.v v8, x1          # m[x1 = 8] = v7
ADDI x1, x1, 8

# VMIN
vmin.vv v6, v5, v4
vmin.vx v7, v4, x2
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 8
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 8

# VMAX
vmax.vv v6, v5, v4
vmax.vx v7, v4, x2
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 8
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 8

################### VMUL TESTS ######################
# VMUL
ADDI x3, x0, 2
vadd.vi v8, v0, 2
vmul.vv v6, v5, v8
vmul.vx v7, v4, x3
vse32.v v6, x1          # m[x1 = 0] = v5
ADDI x1, x1, 8
vse32.v v7, x1          # m[x1 = 4] = v6
ADDI x1, x1, 8