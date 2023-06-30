ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 17    # 32 bit elements 256-bit vector
ADDI x5, x5, 16         # x5 = x5 + 16 = 32
vle32.v v28, x0
C.NOP
C.NOP
C.NOP
C.NOP
################### VALU TESTS #####################
# VADD
ADDI x1, x0, 0          # Address Pointer
ADDI x2, x0, 10         # Scalar Operand for VX instructions
vadd.vi v4, v0, 15      # v4 = 15
vadd.vi v8, v0, 20      # v8 = 20
vadd.vv v12, v8, v4      # v12 = v4 + v8
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
vand.vx v16, v4, x2
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
vor.vx v16, v4, x2
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
vxor.vx v16, v4, x2
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
vsll.vv v12, v8, v24
vsll.vx v16, v4, x3
vsll.vi v20, v4, 4
vse32.v v12, x1          # m[x1 = 0] = v8
C.NOP
C.NOP
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
vsrl.vx v16, v4, x3
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
C.NOP
vse32.v v20, x1          # m[x1 = 8] = v16
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP

# VSRA
vsra.vv v12, v8, v24  
vsra.vx v16, v4, x3
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

#VMSEQ
vadd.vi v28, v0, 20
vmseq.vv v12, v8, v28
vmseq.vx v16, v4, x2
vmseq.vi v20, v4, 15
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v12, x1
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v20, x1
ADDI x1, x1, 8
C.NOP
C.NOP

#VMSNE
vmsne.vv v12, v8, v28
vmsne.vx v16, v4, x2
vmsne.vi v20, v4, 15
vse32.v v12, x1
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v20, x1
ADDI x1, x1, 8
C.NOP
C.NOP

# VMSLT
vmslt.vv v12, v4, v8
vmslt.vx v16, v4, x2
vse32.v v12, x1
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1
ADDI x1, x1, 8
C.NOP

# VMSLE
vmsle.vv v12, v4, v8
vmsle.vx v16, v4, x2
vmsle.vi v20, v4, 15
vse32.v v12, x1
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v20, x1
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP

# VMSGT
vmsgt.vx v12, v4, x2
vmsgt.vi v16, v4, 10
vse32.v v12, x1
ADDI x1, x1, 8
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1
ADDI x1, x1, 8

################### VMUL TESTS ######################
# VMUL
ADDI x3, x0, 2
C.NOP
C.NOP
vadd.vi v20, v0, 2
vmul.vv v12, v8, v20
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
