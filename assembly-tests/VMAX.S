# Signed maximum
# vmax.vv vd, vs2, vs1, vm  (vector-vector)
# vmax.vx vd, vs2, vs1, vm  (vector-scalar)

vadd.vi v20, v20, 2         # v20 = 2
vadd.vi v21, v21, 4         # v21 = 4
vmax.vv v22, v21, v20       # v22 = 4