ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 18    # 32 bit elements 512-bit vector
ADDI x5, x5, 16         # x5 = x5 + 16 = 32
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vadd.vi v4, v0, 15      # v4 = 15
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vadd.vi v10, v0, 10
ADDI x1, x0, 0          # x1 = 0
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
#32 bit save tests
vse32.v v4, x1          # m[x1 = 0] = v4 = 15
ADDI x1, x1, 16         # x1 = x1 + 16 = 0 + 16 = 16
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vse16.v v10, x1          # m[x1 = 16] = 15
ADDI x1, x1, 16         # x1 = x1 + 16 = 16 + 16 = 32
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vse8.v v4, x1           # m[x1 = 32] = 15
ADDI x1, x1, 16         # x1 = x1 + 16 = 32 + 16 = 48
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vsetivli x20, x5, 10    # 16 bit elements 512-bit vector
ADDI x5, x5, 16
ADDI x5, x5, 16
NOP	#from C.NOP
NOP	#from C.NOP
vse16.v v10, x1          # m[x1 = 48] = 15
ADDI x1, x1, 16         # x1 = x1 + 16 = 48 + 16 = 64
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vse8.v v4, x1           # m[x1 = 64] = 15
ADDI x1, x1, 16         # x1 = x1 + 16 = 64 + 16 = 80
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vse32.v v10, x1          # m[x1 = 80] = 15
ADDI x1, x1, 16         # x1 = x1 + 16 = 80 + 16 = 96
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vsetivli x20, x5, 2     # 8 bit elements 512-bit vector
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vse8.v v4, x1           # m[x1 = 96] = 15
ADDI x1, x1, 16         # x1 = x1 + 16 = 96 + 16 = 112
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vse16.v v10, x1          # m[x1 = 112] = 15
ADDI x1, x1, 16         # x1 = x1 + 16 = 112 + 16 = 128
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vse32.v v4, x1          # m[x1 = 128] = 15
ADDI x1, x1, 16         # x1 = x1 + 16 = 128 + 16 = 144
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
