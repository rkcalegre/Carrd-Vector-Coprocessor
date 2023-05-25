# Vector Slide Instructions
#check stalls for base integer instructions
#v0 = 0

# slide1down
vadd.vi v4, v0, 128               # v4 = 128
nop
addi x8, x0, 2                    # x8 = 2
nop
nop
nop
nop
vslide1down.vx v12, v4, x8        # v12 = 160 (1010 0000)
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
vadd.vi v4, v0, 128               # v4 = 128
nop
addi x8, x0, 4                    # x8 = 4
nop
nop
nop
nop
vslidedown.vx v12, v4, x8         # v12 = 8
nop
vslidedown.vi v16, v4, 4          # v16 = 8
nop
