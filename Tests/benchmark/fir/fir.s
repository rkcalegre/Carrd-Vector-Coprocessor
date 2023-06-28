

vsetvli x0, x0, e32
vle32.v v2, x2
vle32.v v3, x3
vmul.vv v3, v3
vadd.vv v5, v3, v2
vle32.v v4, x4
vmul.vv v4, v4
vle32.v v0, x0
vadd.vv v6, v4, v0
vle32.v v1, x1
vadd.vv v5, v5, v1
vadd.vv v5, v5, v6