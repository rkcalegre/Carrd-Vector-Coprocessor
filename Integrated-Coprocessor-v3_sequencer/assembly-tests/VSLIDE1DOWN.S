# Vector Slide Instructions

# slide1down

# vslide1down.vx vd, vs2, rs1, vm # vd[i] = vs2[i+1], vd[vl-1]=x[rs1]

#v0 = 0

vadd.vi v4, v0, 128               # v4 = 128
addi x8, x0, 2                    # x8 = 2
vslide1down.vx v12, v4, x8        # v12 = 160 (1010 0000)