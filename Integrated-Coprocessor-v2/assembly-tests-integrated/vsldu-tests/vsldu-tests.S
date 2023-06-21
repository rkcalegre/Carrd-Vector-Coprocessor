#IGNORE ALL MEMORY COMMENTS
ADDI x5, x0, 16
#512-bits sldu tests
vsetivli x20, x5, 18 #32 bit elements 512-bit vector
ADDI x5, x5, 16
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vle32.v v4, x0
ADDI x4, x0, 2
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
VSLIDEUP.VX v8, v4, x4
ADDI x1, x0, 0          # x1 = 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v8, x1         # m[x1 = 0] = v8
NOP
NOP
NOP
NOP
NOP
VSLIDEUP.VI v8, v4, 2
ADDI x1, x1, 16          # x1 = x1 + 4 = 0 + 4 = 4
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v8, x1         # m[x1 = 4] = v8
NOP
NOP
NOP
NOP
NOP
VSLIDE1UP.VX v12, v4, x4
ADDI x1, x1, 16          # x1 = x1 + 4 = 4 + 4 = 8
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v12, x1         # m[x1 = 8] = v12
NOP
NOP
NOP
NOP
NOP
VSLIDEDOWN.VX v16, v4, x4
ADDI x1, x1, 16          # x1 = x1 + 4 = 8 + 4 = 12
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v16, x1         # m[x1 = 12] = v16
NOP
NOP
NOP
NOP
NOP
VSLIDEDOWN.VI v16, v4, 2
ADDI x1, x1, 16          # x1 = x1 + 4 = 12 + 4 = 16
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v16, x1         # m[x1 = 16] = v16
NOP
NOP
NOP
NOP
NOP
VSLIDE1DOWN.VX v20, v4, 2
ADDI x1, x1, 16          # x1 = x1 + 4 = 16 + 4 = 20
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v20, x1         # m[x1 = 20] = v20
NOP
NOP
NOP
NOP
NOP
VMV.S.X v24, x5
ADDI x1, x1, 16          # x1 = x1 + 4 = 20 + 4 = 24
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v24, x1         # m[x1 = 24] = v20
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vsetivli x20, x5, 10 #16 bit elements 512-bit vector
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
VSLIDEUP.VX v8, v4, x4
ADDI x1, x1, 16          # x1 = x1 + 4 = 24 + 4 = 28
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v8, x1         # m[x1 = 28] = v8
NOP
NOP
NOP
NOP
NOP
VSLIDEUP.VI v8, v4, 2
ADDI x1, x1, 16          # x1 = x1 + 4 = 28 + 4 = 32
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v8, x1         # m[x1 = 32] = v8
NOP
NOP
NOP
NOP
NOP
VSLIDE1UP.VX v12, v4, x4
ADDI x1, x1, 16          # x1 = x1 + 4 = 32 + 4 = 36
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v12, x1         # m[x1 = 36] = v12
NOP
NOP
NOP
NOP
NOP
VSLIDEDOWN.VX v16, v4, x4
ADDI x1, x1, 16          # x1 = x1 + 4 = 36 + 4 = 40
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v16, x1         # m[x1 = 40] = v16
NOP
NOP
NOP
NOP
NOP
VSLIDEDOWN.VI v16, v4, 2
ADDI x1, x1, 16          # x1 = x1 + 4 = 40 + 4 = 44
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v16, x1         # m[x1 = 44] = v16
NOP
NOP
NOP
NOP
NOP
VSLIDE1DOWN.VX v20, v4, 2
ADDI x1, x1, 16          # x1 = x1 + 4 = 44 + 4 = 48
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v20, x1         # m[x1 = 48] = v20
NOP
NOP
NOP
NOP
NOP
VMV.S.X v24, x5
ADDI x1, x1, 16          # x1 = x1 + 4 = 48 + 4 = 52
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v24, x1         # m[x1 = 52] = v24
NOP
NOP
NOP
NOP
NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
vsetivli x20, x5, 2 #8 bit elements 512-bit vector
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
VSLIDEUP.VX v8, v4, x4
ADDI x1, x1, 16          # x1 = x1 + 4 = 52 + 4 = 56
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v8, x1         # m[x1 = 56] = v8
NOP
NOP
NOP
NOP
NOP
VSLIDEUP.VI v8, v4, 2
ADDI x1, x1, 16          # x1 = x1 + 4 = 56 + 4 = 60
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v8, x1         # m[x1 = 60] = v8
NOP
NOP
NOP
NOP
NOP
VSLIDE1UP.VX v12, v4, x4
ADDI x1, x1, 16          # x1 = x1 + 4 = 60 + 4 = 64
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v12, x1         # m[x1 = 64] = v12
NOP
NOP
NOP
NOP
NOP
VSLIDEDOWN.VX v16, v4, x4
ADDI x1, x1, 16          # x1 = x1 + 4 = 64 + 4 = 68
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v16, x1         # m[x1 = 68] = v16
NOP
NOP
NOP
NOP
NOP
VSLIDEDOWN.VI v16, v4, 2
ADDI x1, x1, 16          # x1 = x1 + 4 = 68 + 4 = 72
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v16, x1         # m[x1 = 72] = v16
NOP
NOP
NOP
NOP
NOP
VSLIDE1DOWN.VX v20, v4, 2
ADDI x1, x1, 16          # x1 = x1 + 4 = 72 + 4 = 76
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v20, x1         # m[x1 = 76] = v20
NOP
NOP
NOP
NOP
NOP
VMV.S.X v24, x5
ADDI x1, x1, 16          # x1 = x1 + 4 = 76 + 4 = 80
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vse32.v v24, x1         # m[x1 = 80] = v24
NOP
NOP
NOP
NOP
NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP
C.NOP

# Input vector
# 3d2d1d0d 3c2c1c0c 3b2b1b0b 3a2a1a0a
# 7d6d5d4d 7c6c5c4c 7b6b5b4b 7a6a5a4a
# 9d9d9d8d 9c9c9c8c 9b9b9b8b 9a9a9a8a
# 0d0d0d0d 0c0c0c0c 0b0b0b0b 0a0a0a0a
