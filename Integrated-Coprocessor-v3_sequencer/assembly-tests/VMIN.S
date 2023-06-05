# Vector Integer Min/Max Instructions

# Signed minimum
# vmin.vv vd, vs2, vs1, vm  (vector-vector)
# vmin.vx vd, vs2, vs1, vm  (vector-scalar)

#v0 = 0

vadd.vi v4, v4, 8        # v4 = 8
vadd.vi v8, v8, 9        # v8 = 9
vmin.vv v12, v8, v4      # v12 = 8