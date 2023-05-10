# vxor.vv vd, vs2, vs1, vm  (vector-vector)
# vxor.vx vd, vs2, vs1, vm  (vector-scalar)
# vxor.vi vd, vs2, imm, vm  (vector-immediate)

vadd.vi v20, v20, 21        # imm = 5'b10101
vadd.vi v21, v21, 31        # imm = 5'b11111
vxor.vv v22, v21, v20       # v22 = v21 && v20 = 5'b01010 = 10