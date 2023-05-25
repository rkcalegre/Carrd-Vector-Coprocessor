#Vector Integer Arithmetic Instructions

#v0 = 0

# Integer adds
vadd.vi v4, v0, 8        # v4 = 8
nop
vadd.vi v8, v0, 9        # v8 = 9
nop
ADDI x1, x0, 61          #Base Processor
vadd.vv v12, v8, v4      # v12 = v8 + v4 = 15 (or e)
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
