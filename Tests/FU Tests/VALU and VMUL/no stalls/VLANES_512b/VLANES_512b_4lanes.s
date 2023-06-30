ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 18    # 32 bit elements 256-bit vector
ADDI x5, x5, 16         # x5 = x5 + 16 = 32
vle32.v x28, x0
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
vse32.v v8, x1          # m[x1 = 0] = v8 = 20
C.NOP
C.NOP
C.NOP
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v12, x1          # m[x1 = 10] = v12 = 35
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 20] = v16 = 25
ADDI x1, x1, 16         
C.NOP

# VSUB
vsub.vv v12, v4, v8      # v4 = 15
vsub.vx v16, v4, x2      # v8 = 20
vse32.v v12, x1          # m[x1 = 30] = v8
C.NOP
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 40] = v12
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
C.NOP
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
vand.vi v20, v4, 1
vse32.v v12, x1          # m[x1 = 50] = v8
C.NOP
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 60] = v12
C.NOP
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v20, x1          # m[x1 = 70] = v16
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
C.NOP
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
vor.vi v20, v4, 0
vse32.v v12, x1          # m[x1 = 80] = v8
C.NOP
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 90] = v12
C.NOP
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v20, x1          # m[x1 = a0] = v16
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
C.NOP
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
vxor.vi v20, v4, 0
vse32.v v12, x1          # m[x1 = b0] = v8
C.NOP
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = c0] = v12
C.NOP
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v20, x1          # m[x1 = d0] = v16
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
C.NOP
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
vadd.vi v28, v0, 2
C.NOP
C.NOP
C.NOP
C.NOP
vsll.vv v12, v8, v28     
vsll.vx v16, v4, x3      
vsll.vi v20, v4, 4
vse32.v v12, x1          # m[x1 = e0] = v8
C.NOP
C.NOP
C.NOP
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = f0] = v12
C.NOP
C.NOP
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v20, x1          # m[x1 = 100] = v16
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP

# VSRL
vsrl.vv v12, v8, v28 
C.NOP
C.NOP
C.NOP
C.NOP
vsrl.vx v16, v4, x3      
vsrl.vi v20, v4, 1
vse32.v v12, x1          # m[x1 = 110] = v8
C.NOP
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 120] = v12
C.NOP
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v20, x1          # m[x1 = 130] = v16
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP


# VSRA
vsra.vv v12, v8, v28    
C.NOP
C.NOP
C.NOP
C.NOP 
vsra.vx v16, v4, x3      
vsra.vi v20, v4, 2
vse32.v v12, x1          # m[x1 = 140] = v8
C.NOP
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 150] = v12
C.NOP
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v20, x1          # m[x1 = 160] = v16
ADDI x1, x1, 16
C.NOP

# VMIN
vmin.vv v12, v8, v4
vmin.vx v16, v4, x2
vse32.v v12, x1          # m[x1 = 170] = v8
C.NOP
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 180] = v12
ADDI x1, x1, 16
C.NOP

# VMAX
vmax.vv v12, v8, v4
vmax.vx v16, v4, x2
vse32.v v12, x1          # m[x1 = 190] = v8
C.NOP
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 1a0] = v12
ADDI x1, x1, 16
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP


#VMSEQ
vadd.vi v28, v0, 20
C.NOP
C.NOP
C.NOP
C.NOP
vmseq.vv v12, v8, v28
vmseq.vx v16, v4, x2
vmseq.vi v20, v4, 15
vse32.v v12, x1          # m[x1 = 1b0] = v12
C.NOP
C.NOP
C.NOP
addi x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 1c0] = v12
C.NOP
C.NOP
addi x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v20, x1          # m[x1 = 1d0] = v12
addi x1, x1, 16
C.NOP

#VMSNE
vmsne.vv v12, v8, v28
vmsne.vx v16, v4, x2
vmsne.vi v20, v4, 15
vse32.v v12, x1          # m[x1 = 1e0] = v12
addi x1, x1, 16
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 1f0] = v12
C.NOP
addi x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v20, x1          # m[x1 = 200] = v12
addi x1, x1, 16
C.NOP

# VMSLT
vmslt.vv v12, v4, v8
vmslt.vx v16, v4, x2
vse32.v v12, x1          # m[x1 = 210] = v12
C.NOP
addi x1, x1, 16
C.NOP
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 220] = v12
addi x1, x1, 16
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP

# VMSLE
vmsle.vv v12, v4, v8
C.NOP
C.NOP
C.NOP
C.NOP
vmsle.vx v16, v4, x2
vmsle.vi v20, v4, 15
vse32.v v12, x1          # m[x1 = 230] = v12
C.NOP
addi x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 240] = v12
C.NOP
addi x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v20, x1          # m[x1 = 250] = v12
addi x1, x1, 16
C.NOP

# VMSGT
vmsgt.vx v12, v4, x2
vmsgt.vi v16, v4, 10
vse32.v v12, x1          # m[x1 = 260] = v12
C.NOP
addi x1, x1, 16
C.NOP
C.NOP
C.NOP
vse32.v v16, x1          # m[x1 = 270] = v12
addi x1, x1, 16
C.NOP
C.NOP
C.NOP
C.NOP
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
vmul.vv v12, v8, v20
vmul.vx v16, v4, x3
vse32.v v12, x1          # m[x1 = 280] = v8
C.NOP
ADDI x1, x1, 16
vse32.v v16, x1          # m[x1 = 290] = v12
C.NOP
C.NOP
C.NOP
C.NOP
ADDI x1, x1, 16
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
