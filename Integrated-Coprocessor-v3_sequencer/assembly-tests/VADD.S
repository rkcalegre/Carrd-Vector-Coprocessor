#Vector Integer Arithmetic Instructions

# Integer adds
# vadd.vv vd, vs2, vs1, vm (vector-vector)
# vadd.vx vd, vs2, vs1, vm (vector-scalar)
# vadd.vi vd, vs2, imm, vm (vector immediate)

#v0 = 0

vadd.vi v4, v0, 8        # v4 = 8
vadd.vi v8, v0, 9        # v8 = 9
vadd.vv v12, v8, v4      # v12 = v8 + v4 = 11 (or e)