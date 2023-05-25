# Vector Slide Instructions

# slideup

# vslideup.vx vd, vs2, rs1, vm # vd[i+rs1] = vs2[i]
# vslideup.vi vd, vs2, uimm[4:0], vm # vd[i+uimm] = vs2[i]

#v0 = 0

vadd.vi v4, v0, 8               # v4 = 8
addi x8, x0, 9                  # x8 = 9
vslideup.vx v12, v4, x8         # v12 = 524,288 (1000 0000 0000 0000 0000)
vslideup.vi v16, v4, 9          # v16 = 524,288 (1000 0000 0000 0000 0000)