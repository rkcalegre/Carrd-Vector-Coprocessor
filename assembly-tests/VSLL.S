# vsll.vv vd, vs2, vs1, vm   (vector-vector)
# vsll.vx vd, vs2, vs1, vm   (vector-scalar)
# vsll.vi vd, vs2, uimm, vm  (vector-immediate)

vadd.vi v20, v20, 2         # v20 = 2 ('b10)
vadd.vi v21, v21, 1         # v21 = 1
vsll.vi v22, v20, 2         # v21 = 2 << 2 = 'b1000
vsll.vv v23, v21, v20       # v23 = 1 << 2