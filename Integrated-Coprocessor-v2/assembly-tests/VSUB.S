#Vector Integer Arithmetic Instructions

# Integer subtract

# vsub.vv vd, vs2, vs1, vm  (vector-vector)
# vsub.vx vd, vs2, vs1, vm  (vector-scalar)


#v0 = 0

vadd.vi v4, v0, 6        # v4 = 6
vadd.vi v8, v0, 7        # v8 = 7
vsub.vv v12, v8, v4      # v12 = v8 - v4 = 1