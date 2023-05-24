#Bit shift operations

# VSLL

# vsll.vv vd, vs2, vs1, vm   (vector-vector)
# vsll.vx vd, vs2, vs1, vm   (vector-scalar)
# vsll.vi vd, vs2, uimm, vm  (vector-immediate)

#v0 = 0

vadd.vi v28, v28, 2         # v28 = 2 ('b10)
vadd.vi v29, v29, 1         # v29 = 1
vsll.vi v30, v28, 2         # v30 = 2 << 2 = 'b1000
vsll.vv v31, v29, v28       # v31 = 1 << 2