ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 17    # 32 bit elements 256-bit vector
ADDI x5, x5, 16         # x5 = x5 + 16 = 32
C.NOP
C.NOP
C.NOP
C.NOP
################### VALU TESTS #####################
# VADD
ADDI x1, x0, 0          # Address Pointer
ADDI x2, x0, 10         # Scalar Operand for VX instructions
vadd.vi v4, v0, 15      # v4 = 15
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vi v8, v0, 20      # v8 = 20
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vv v12, v8, v4      # v12 = v4 + v8
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vx v16, v4, x2      # v16 = v4 + x2
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v8, x1          # m[x1 = 0] = v8 = 20
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v12, x1          # m[x1 = 4] = v12 = 35
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 8] = v16 = 25
ADDI x1, x1, 8 
C.NOP
C.NOP
C.NOP
C.NOP

# VSUB
vsub.vv v12, v4, v8      # v4 = 15
C.NOP
C.NOP
C.NOP
C.NOP
vsub.vx v16, v4, x2      # v8 = 20
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v12, x1          # m[x1 = 12] = v8
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 16] = v12
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP

# VAND
vand.vv v12, v8, v4 
C.NOP
C.NOP
C.NOP
C.NOP
vand.vx v16, v4, x2
C.NOP
C.NOP
C.NOP
C.NOP
vand.vi v20, v4, 1
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v12, x1          # m[x1 = 0] = v8
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 4] = v12
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v20, x1          # m[x1 = 8] = v16
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP

# VOR
vor.vv v12, v8, v4
C.NOP
C.NOP
C.NOP
C.NOP
vor.vx v16, v4, x2
C.NOP
C.NOP
C.NOP
C.NOP
vor.vi v20, v4, 0
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v12, x1          # m[x1 = 0] = v8
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 4] = v12
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v20, x1          # m[x1 = 8] = v16
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP

# VXOR
vxor.vv v12, v8, v4
C.NOP
C.NOP
C.NOP
C.NOP
vxor.vx v16, v4, x2
C.NOP
C.NOP
C.NOP
C.NOP
vxor.vi v20, v4, 0
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v12, x1          # m[x1 = 0] = v8
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 4] = v12
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v20, x1          # m[x1 = 8] = v16
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP

# VSLL
ADDI x3, x0, 3
vadd.vi v24, v0, 2
C.NOP
C.NOP
C.NOP
C.NOP
vsll.vv v12, v8, v24
C.NOP
C.NOP
C.NOP
C.NOP
vsll.vx v16, v4, x3
C.NOP
C.NOP
C.NOP
C.NOP
vsll.vi v20, v4, 4
vse32.v v12, x1          # m[x1 = 0] = v8
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 4] = v12
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v20, x1          # m[x1 = 8] = v16
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP

# VSRL
vsrl.vv v12, v8, v24  
C.NOP
C.NOP
C.NOP
C.NOP
vsrl.vx v16, v4, x3
C.NOP
C.NOP
C.NOP
C.NOP
vsrl.vi v20, v4, 1
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v12, x1          # m[x1 = 0] = v8
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 4] = v12
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v20, x1          # m[x1 = 8] = v16
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP

# VSRA
vsra.vv v12, v8, v24  
C.NOP
C.NOP
C.NOP
C.NOP
vsra.vx v16, v4, x3
C.NOP
C.NOP
C.NOP
C.NOP
vsra.vi v20, v4, 2
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v12, x1          # m[x1 = 0] = v8
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 4] = v12
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v20, x1          # m[x1 = 8] = v16
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP

# VMIN
vmin.vv v12, v8, v4
C.NOP
C.NOP
C.NOP
C.NOP
vmin.vx v16, v4, x2
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v12, x1          # m[x1 = 0] = v8
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 4] = v12
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP

# VMAX
vmax.vv v12, v8, v4
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vx v16, v4, x2
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v12, x1          # m[x1 = 0] = v8
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 4] = v12
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP

################### VMUL TESTS ######################
# VMUL
ADDI x3, x0, 2
C.NOP
C.NOP
C.NOP
C.NOP
vadd.vi v20, v0, 2
C.NOP
C.NOP
C.NOP
C.NOP
vmul.vv v12, v8, v20
C.NOP
C.NOP
C.NOP
C.NOP
vmul.vx v16, v4, x3
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v12, x1          # m[x1 = 0] = v8
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 4] = v12
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
