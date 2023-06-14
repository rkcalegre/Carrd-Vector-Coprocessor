# Bitwise logical operations

# OR

# vor.vv vd, vs2, vs1, vm  (vector-vector)
# vor.vx vd, vs2, vs1, vm  (vector-scalar)
# vor.vi vd, vs2, imm, vm  (vector-immediate)

vadd.vi v16, v16, 21        # v16 = 5'b10101 //imm
vadd.vi v20, v20, 20        # v20 = 5'b11111 //imm
vor.vv v24, v20, v16       # v24 = v20 || v16 = 5'b11111 = 31
