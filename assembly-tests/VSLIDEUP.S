# vslideup.vx vd, vs2, rs1, vm   ( vd[i+rs1] = vs2[i] )
# vslideup.vi vd, vs2, uimm, vm  ( vd[i+uimm] = vs2[i] )

vadd.vi v20, v20, 2
vslideup.vi v21, v20, 4