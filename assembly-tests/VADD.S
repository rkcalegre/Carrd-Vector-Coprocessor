# vadd.vv vd, vs2, vs1, vm (vector-vector)
# vadd.vx vd, vs2, vs1, vm (vector-scalar)
# vadd.vi vd, vs2, imm, vm (vector immediate)

vadd.vi v20, v20, 2        # v20 = 2
vadd.vi v21, v21, 5        # v21 = 5
vadd.vv v22, v21, v20      # v22 = v20 + v21 = 7

