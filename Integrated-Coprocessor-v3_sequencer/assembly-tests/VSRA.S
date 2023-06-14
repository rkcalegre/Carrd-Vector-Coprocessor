#Bit shift operations

# VSRL

# vsra.vv vd, vs2, vs1, vm   (vector-vector)
# vsra.vx vd, vs2, vs1, vm   (vector-scalar)
# vsra.vi vd, vs2, uimm, vm  (vector-immediate)

#v0 = 0

vadd.vi v28, v0, 8         # v28 = 8 ('b1000)
vadd.vi v29, v0, 1         # v29 = 1
vsra.vi v30, v28, 2         # v30 = 8 >>> 2 = 'b0010
vsra.vv v31, v29, v28       # v31 = 1 >>> 8