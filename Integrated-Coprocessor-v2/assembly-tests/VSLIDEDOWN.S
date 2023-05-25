# Vector Slide Instructions

# slidedown

# vslidedown.vx vd, vs2, rs1, vm # vd[i] = vs2[i+rs1]
# vslidedown.vi vd, vs2, uimm[4:0], vm # vd[i] = vs2[i+uimm]

#v0 = 0

vadd.vi v4, v0, 128               # v4 = 128
addi x8, x0, 4                    # x8 = 4
vslidedown.vx v12, v4, x8         # v12 = 8
vslidedown.vi v16, v4, 4          # v16 = 8