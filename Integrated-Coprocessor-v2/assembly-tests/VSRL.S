#Bit shift operations

# VSRL

# vsrl.vv vd, vs2, vs1, vm   (vector-vector)
# vsrl.vx vd, vs2, vs1, vm   (vector-scalar)
# vsrl.vi vd, vs2, uimm, vm  (vector-immediate)

#v0 = 0

vadd.vi v28, v0, 8         # v28 = 8 ('b1000)
vadd.vi v29, v0, 1         # v29 = 1
vsrl.vi v30, v28, 2         # v30 = 8 >> 2 = 'b0010
vsrl.vv v31, v28, v29       # v31 = 1 >> 8