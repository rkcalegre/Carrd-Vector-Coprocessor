ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 17    # 32 bit elements 256-bit vector
ADDI x5, x5, 16         # x5 = x5 + 16 = 32
################### VALU TESTS #####################
# VADD
ADDI x1, x0, 0          # Address Pointer
ADDI x2, x0, 10         # Scalar Operand for VX instructions
vadd.vi v4, v0, 15      # v4 = 15
vadd.vi v8, v0, 20      # v8 = 20
vadd.vv v12, v8, v4      # v12 = v4 + v8
vadd.vx v16, v4, x2      # v16 = v4 + x2
vse32.v v8, x1          # m[x1 = 0] = v8 = 20
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v12, x1          # m[x1 = 8] = v12 = 35
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v16, x1          # m[x1 = 16] = v16 = 25
ADDI x1, x1, 8 
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# VSUB
vsub.vv v12, v4, v8      # v4 = 15
vsub.vx v16, v4, x2      # v8 = 20
vse32.v v12, x1          # m[x1 = 24] = v8
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v16, x1          # m[x1 = 32] = v12
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# VAND
vand.vv v12, v8, v4 
vand.vx v16, v4, x2
vand.vi v20, v4, 1
vse32.v v12, x1          # m[x1 = 40] = v8
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v16, x1          # m[x1 = 48] = v12
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v20, x1          # m[x1 = 56] = v16
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# VOR
vor.vv v12, v8, v4
vor.vx v16, v4, x2
vor.vi v20, v4, 0
vse32.v v12, x1          # m[x1 = 64] = v8
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v16, x1          # m[x1 = 72] = v12
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v20, x1          # m[x1 = 80] = v16
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# VXOR
vxor.vv v12, v8, v4
vxor.vx v16, v4, x2
vxor.vi v20, v4, 0
vse32.v v12, x1          # m[x1 = 88] = v8
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v16, x1          # m[x1 = 96] = v12
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v20, x1          # m[x1 = 104] = v16
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# VSLL
ADDI x3, x0, 3
vadd.vi v24, v0, 2
vsll.vv v12, v8, v24
vsll.vi v20, v4, 4
vsll.vx v16, v4, x3
vse32.v v12, x1          # m[x1 = 112] = v8
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v16, x1          # m[x1 = 120] = v12
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v20, x1          # m[x1 = 128] = v16
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# VSRL
vsrl.vv v12, v8, v24  
vsrl.vx v16, v4, x3
vsrl.vi v20, v4, 1
vse32.v v12, x1          # m[x1 = 136] = v8
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v16, x1          # m[x1 = 144] = v12
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v20, x1          # m[x1 = 152] = v16
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# VSRA
vsra.vv v12, v8, v24  
vsra.vx v16, v4, x3
vsra.vi v20, v4, 2
vse32.v v12, x1          # m[x1 = 160] = v8
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v16, x1          # m[x1 = 168] = v12
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v20, x1          # m[x1 = 176] = v16
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# VMIN
vmin.vv v12, v8, v4
vmin.vx v16, v4, x2
vse32.v v12, x1          # m[x1 = 184] = v8
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v16, x1          # m[x1 = 192] = v12
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# VMAX
vmax.vv v12, v8, v4
vmax.vx v16, v4, x2
vse32.v v12, x1          # m[x1 = 200] = v8
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v16, x1          # m[x1 = 208] = v12
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

#VMSEQ
vadd.vi v28, v0, 20
vmseq.vv v12, v8, v28
vmseq.vx v16, v4, x2
vmseq.vi v20, v4, 15
vse32.v v12, x1          # m[x1 = 216]
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v16, x1          # m[x1 = 224]
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v20, x1          # m[x1 = 232]
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

#VMSNE
vmsne.vv v12, v8, v28
vmsne.vx v16, v4, x2
vmsne.vi v20, v4, 15
vse32.v v12, x1          # m[x1 = 240]
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v16, x1          # m[x1 = 248]
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v20, x1          # m[x1 = 256]
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# VMSLT
vmslt.vv v12, v4, v8
vmslt.vx v16, v4, x2
vse32.v v12, x1          # m[x1 = 264]
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v16, x1          # m[x1 = 272]
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# VMSLE
vmsle.vv v12, v4, v8
vmsle.vx v16, v4, x2
vmsle.vi v20, v4, 15
vse32.v v12, x1          # m[x1 = 280]
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v16, x1          # m[x1 = 288]
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v20, x1          # m[x1 = 296]
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# VMSGT
vmsgt.vx v12, v4, x2
vmsgt.vi v16, v4, 10
vse32.v v12, x1          # m[x1 = 304]
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v16, x1          # m[x1 = 312]
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0


################### VMUL TESTS ######################
# VMUL
ADDI x3, x0, 2
addi x0, x0, 0
vadd.vi v20, v0, 2
vmul.vv v12, v8, v20
vmul.vx v16, v4, x3
vse32.v v12, x1          # m[x1 = 320] = v8
ADDI x1, x1, 8
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
vse32.v v16, x1          # m[x1 = 328] = v12
ADDI x1, x1, 8
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
