# Vector Integer Min/Max Instructions

# Signed maximum
# vmax.vv vd, vs2, vs1, vm  (vector-vector)
# vmax.vx vd, vs2, vs1, vm  (vector-scalar)

#v0 = 0

vadd.vi v4, v4, 8        # v4 = 8
vadd.vi v8, v8, 9        # v8 = 9
vmax.vv v12, v8, v4      # v12 = 9