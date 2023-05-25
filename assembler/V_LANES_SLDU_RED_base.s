#Vector Integer Arithmetic Instructions

#v0 = 0

# Integer adds
vadd.vi v4, v0, 8        # v4 = 8
nop
vadd.vi v8, v0, 9        # v8 = 9
nop
ADDI x1, x0, 61          #Base Processor
vadd.vv v12, v8, v4      # v12 = v8 + v4 = 17 (or 11)
nop

# Integer subtract
vadd.vi v4, v0, 6        # v4 = 6
nop
ADDI x2, x1, 62          #Base Processor
vadd.vi v8, v0, 7        # v8 = 7
nop
vsub.vv v12, v8, v4      # v12 = v8 - v4 = 1
nop

# Bitwise logical operations

# AND
vadd.vi v16, v0, 21        # v16 = 5'b10101 //imm
nop
vadd.vi v20, v0, 20        # v20 = 5'b11111 //imm
nop
ADDI x3, x0, 63          #Base Processor
ADDI x4, x0, 64          #Base Processor
vand.vv v24, v20, v16       # v24 = v20 && v16 = 5'b10101 = 21
nop

# OR
vor.vv v24, v20, v16       # v24 = v20 || v16 = 5'b11111 = 31
nop

# XOR
vand.vv v24, v20, v16       # v24 = v20 && v16 = 5'b01010 = 10
nop

#Bit shift operations

# VSLL
vadd.vi v28, v0, 2         # v28 = 2 ('b10)
nop
vadd.vi v29, v0, 1         # v29 = 1
nop
ADDI x5, x1, 1              #Base Processor
vsll.vi v30, v28, 2         # v30 = 2 << 2 = 'b1000
nop
ADDI x6, x2, 1          #Base Processor
vsll.vv v31, v29, v28       # v31 = 1 << 2
nop

# VSRL
vadd.vi v28, v0, 8         # v28 = 8 ('b1000)
nop
vadd.vi v29, v0, 1         # v29 = 1
nop
vsrl.vi v30, v28, 2         # v30 = 8 >> 2 = 'b0010
nop
vsrl.vv v31, v29, v28       # v31 = 1 >> 8
nop

# Vector Integer Min/Max Instructions

# Signed minimum
vmin.vv v12, v8, v4      # v12 = 8
nop

# Signed maximum
vmax.vv v12, v8, v4      # v12 = 9
nop

#vmul
vmul.vv v12, v8, v4      # v12 = v8 * v4 = 72 (or 0100 1000)
nop

# Vector Slide Instructions
#check stalls for base integer instructions
#v0 = 0

# slide1down
vadd.vi v4, v0, 31               # v4 = 31
nop
addi x8, x0, 2                    # x8 = 2
nop
nop
nop
nop
vslide1down.vx v12, v4, x8        # v12 = #TO EDIT
nop

# slide1up
vadd.vi v4, v0, 8               # v4 = 8
nop
addi x8, x0, 9                  # x8 = 9
nop
nop
nop
nop
vslide1up.vx v12, v4, x8        # v12 = 8
nop

# slideup
vadd.vi v4, v0, 8               # v4 = 8
nop
addi x8, x0, 9                  # x8 = 9
nop
nop
nop
nop
vslideup.vx v12, v4, x8         # v12 = 524,288 (1000 0000 0000 0000 0000)
nop
vslideup.vi v16, v4, 9          # v16 = 524,288 (1000 0000 0000 0000 0000)
nop

# slidedown
vadd.vi v4, v0, 31               # v4 = 31
nop
addi x8, x0, 4                    # x8 = 4
nop
nop
nop
nop
vslidedown.vx v12, v4, x8         # v12 = #TO EDIT
nop
vslidedown.vi v16, v4, 4          # v16 = #TO EDIT
nop


# Vector Reduction Instructions

#VREDMAX
vadd.vi v4, v0, 31               # v4 = 31
nop
vadd.vi v8, v0, 4                 # V8 = 4
nop
vredmax.vs v12, v8, x4           `# v12 =  # TO EDIT
nop

#VREDSUM
vredsum.vs v12, v8, x4           `# v12 =  # TO EDIT
nop
