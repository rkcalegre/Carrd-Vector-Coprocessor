# vsra.vv vd, vs2, vs1, vm   (vector-vector)
# vsra.vx vd, vs2, vs1, vm   (vector-scalar)
# vsra.vi vd, vs2, uimm, vm  (vector-immediate)

vadd.vi v20, v20, 8         # v20 = 8 ('b1000)
vadd.vi v21, v21, 1         # v21 = 1
vsra.vi v22, v20, 2         # v21 = 8 >>> 2 = 'b0010
vsra.vv v23, v21, v20       # v23 = 1 >>> 8