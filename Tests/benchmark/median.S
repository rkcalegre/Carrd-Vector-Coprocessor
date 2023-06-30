


C.LI t0, 32
vsetvli t0, t0, e32
vle32.v v0, (t0)


# Initialize the vector with values


C.LI t1, 1
vse32.v v1, (t0)
vslideup.vi v1, v1, 4
C.LI t1, 2
vse32.v v1, (t0)
vslideup.vi v1, v1, 4
C.LI t1, 3
vse32.v v1, (t0)
vslideup.vi v1, v1, 4
C.LI t1, 4
vse32.v v1, (t0)
vslideup.vi v1, v1, 4
C.LI t1, 5
vse32.v v1, (t0)
vslideup.vi v1, v1, 4
C.LI t1, 6
vse32.v v1, (t0)
vslideup.vi v1, v1, 4
C.LI t1, 7
vse32.v v1, (t0)
vslideup.vi v1, v1, 4
C.LI t1, 8
vse32.v v1, (t0)


# Sort the vector in ascending order
C.LI t0, 8
vsetvli t0, t0, e32


sort:
    C.LI t1, 0
    C.LI t2, 1


sort_inner:
    vle32.v v3, (t1)
    vle32.v v4, (t2)
    vmax.vv v5, v3, v4
    vmin.vv v6, v3, v4
    vse32.v v5, (t1)
    vse32.v v6, (t2)
    vslideup.vi v1, v1, 4
    vslideup.vi v2, v2, 4
    BLT t2, t0, sort_inner
    vslidedown.vi v1, v1, 4
    vslidedown.vi v2, v2, 4
    ADDI t0, t0, -1
    BLT t0, 1, sort

# find the median


C.LI t0, 8
vle32.v v7, (t0)
SRAI t0, t0, 1
ADDI t0, t0, 4
vle32.v v8, (t0)



C.LI t0, 4
vsetvli t0, t0, e32
vse32.v v7, (t0)