vsetvli v0, v0, 0
vadd.vi v4, v0, 1, v0.t
nop
vadd.vi v5, v0, 2, v0.t
nop
vadd.vi v6, v0, 3, v0.t
nop
vadd.vi v7, v0, 4, v0.t
nop
vadd.vv v8, v4, 1, v0.t
nop
vadd.vv v9, v5, 2, v0.t
nop
vadd.vv v10, v6, 3, v0.t
nop
vadd.vv v11, v7, 4, v0.t
nop
vsub.vi v12, v11, 1, v0.t
nop
vsub.vi v13, v10, 2, v0.t
nop
vsub.vi v14, v11, 3, v0.t
nop
vsub.vi v15, v10, 4, v0.t
nop
vsub.vv v16, v11, v12, v0.t
nop
vsub.vv v17, v12, v13, v0.t
nop
vsub.vv v18, v13, v14, v0.t
nop
vsub.vv v19, v14, v15, v0.t
nop
vand.vi v12, v11, 1, v0.t
nop
vand.vi v13, v10, 2, v0.t
nop
vand.vi v14, v11, 3, v0.t
nop
vand.vi v15, v10, 4, v0.t
nop
vand.vv v16, v11, v12, v0.t
nop
vand.vv v17, v12, v13, v0.t
nop
vand.vv v18, v13, v14, v0.t
nop
vand.vv v19, v14, v15, v0.t
nop
vor.vi v12, v11, 1, v0.t
nop
vor.vi v13, v10, 2, v0.t
nop
vor.vi v14, v11, 3, v0.t
nop
vor.vi v15, v10, 4, v0.t
nop
vor.vv v16, v11, v12, v0.t
nop
vor.vv v17, v12, v13, v0.t
nop
vor.vv v18, v13, v14, v0.t
nop
vor.vv v19, v14, v15, v0.t
nop
vsll.vi v12, v11, 1, v0.t
nop
vsll.vi v13, v10, 2, v0.t
nop
vsll.vi v14, v11, 3, v0.t
nop
vsll.vi v15, v10, 4, v0.t
nop
vsll.vv v16, v11, v12, v0.t
nop
vsll.vv v17, v12, v13, v0.t
nop
vsll.vv v18, v13, v14, v0.t
nop
vsll.vv v19, v14, v15, v0.t
nop
vsrl.vi v12, v11, 1, v0.t
nop
vsrl.vi v13, v10, 2, v0.t
nop
vsrl.vi v14, v11, 3, v0.t
nop
vsrl.vi v15, v10, 4, v0.t
nop
vsrl.vv v16, v11, v12, v0.t
nop
vsrl.vv v17, v12, v13, v0.t
nop
vsrl.vv v18, v13, v14, v0.t
nop
vsrl.vv v19, v14, v15, v0.t
nop
vsra.vi v12, v11, 1, v0.t
nop
vsra.vi v13, v10, 2, v0.t
nop
vsra.vi v14, v11, 3, v0.t
nop
vsra.vi v15, v10, 4, v0.t
nop
vsra.vv v16, v11, v12, v0.t
nop
vsra.vv v17, v12, v13, v0.t
nop
vsra.vv v18, v13, v14, v0.t
nop
vsra.vv v19, v14, v15, v0.t
nop
vmin.vv v16, v11, v12, v0.t
nop
vmin.vv v17, v12, v13, v0.t
nop
vmin.vv v18, v13, v14, v0.t
nop
vmin.vv v19, v14, v15, v0.t
nop
vmax.vv v16, v11, v12, v0.t
nop
vmax.vv v17, v12, v13, v0.t
nop
vmax.vv v18, v13, v14, v0.t
nop
vmax.vv v19, v14, v15, v0.t
nop
vsetvli v0, v0, 17 #vset lmul = 1 vsew = 2
nop
vslideup.vi v8, v8, 5, v0.t
nop
vslideup.vi v9, v9, 5, v0.t
nop
vslideup.vi v10, v10, 5, v0.t
nop
vslideup.vi v11, v11, 5, v0.t
nop
vor.vi v8, v4, 10, v0.t
nop
vadd.vv v12, v4, v8, v0.t
nop
vmul.vv v12, v12, v12, v0.t
nop
vadd.vv v12, v4, v8, v0.t
nop
vmul.vv v12, v12, v12, v0.t
nop
vslidedown.vi v16, v4, 2, v0.t
nop
vadd.vv v20, v16, v16, v0.t
nop
vslidedown.vi v16, v16, 1, v0.t
nop
vsetvli v0, v0, 2 #vset lmul = 2 vsew = 0
nop
vor.vi v8, v4, 10, v0.t
nop
vadd.vv v12, v4, v8, v0.t
nop
vslideup.vi v16, v4, 2, v0.t
nop
vadd.vv v20, v16, v16, v0.t
nop
vslideup.vi v16, v4, 4, v0.t
nop
nop
nop
nop
