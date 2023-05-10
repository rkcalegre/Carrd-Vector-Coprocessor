# vslidedown.vx vd, vs2, rs1, vm   ( vd[i] = vs2[i + rs1] )
# vslidedown.vi vd, vs2, uimm, vm  ( vd[i] = vs2[i + uimm] )

vadd.vi v20, v20, 2
vslidedown.vi v21, v20, 4