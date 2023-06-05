# Vector Slide Instructions

# slide1up

# vslide1up.vx vd, vs2, rs1, vm # vd[0]=x[rs1], vd[i+1] = vs2[i]

#v0 = 0

vadd.vi v4, v0, 8               # v4 = 8
addi x8, x0, 9                  # x8 = 9
vslide1up.vx v12, v4, x8        # v12 = 8