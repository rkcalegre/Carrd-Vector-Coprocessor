#Vector Integer Arithmetic Instructions

# Integer adds
# vadd.vv vd, vs2, vs1, vm (vector-vector)
# vadd.vx vd, vs2, vs1, vm (vector-scalar)
# vadd.vi vd, vs2, imm, vm (vector immediate)

vadd.vi v4, v4, 8        # v4 = 8
vadd.vi v8, v8, 9        # v8 = 9
vadd.vv v12, v8, v4      # v12 = v8 + v4 = 15 (or e)