# Vector Integer Multiply Instructions

# vmul

## Signed multiply, returning low bits of product
# vmul.vv vd, vs2, vs1, vm # Vector-vector
# vmul.vx vd, vs2, rs1, vm # vector-scalar


vadd.vi v4, v0, 8        # v4 = 8
vadd.vi v8, v0, 9        # v8 = 9
vmul.vv v12, v8, v4      # v12 = v8 * v4 = 72 (or 0100 1000)