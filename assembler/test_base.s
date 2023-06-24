ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 1     # 8-bit elements 256-bit vector
ADDI x5, x5, 16
ADDI x1, x0, 0          # store address: x1 = 0
ADDI x2, x0, 2          # stride/looper: x2 = 2
ADDI x29, x0, 6         # max loop: x29 = 6
vadd.vi v4, v0, 15      # store data 1: v4 = 15 = 0F0F0F0F
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vadd.vi v8, v0, 10      # store data 2: v5 = 10 = 0A0A0A0A
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
# stride = 2
vsse32.v v4, x1, x2
ADDI x1, x1, 16      # change depending on lmul (128/32 * stride)
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vsse16.v v8, x1, x2
ADDI x1, x1, 32     # change depending on lmul (lmul/vsew * stride)
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vsse8.v v4, x1, x2
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
ADDI x1, x1, 64     # change depending on lmul
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
ADDI x2, x2, 1         # stride++
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
# stride = 3
vsse32.v v4, x1, x2
ADDI x1, x1, 24      # change depending on lmul (128/32 * stride)
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vsse16.v v8, x1, x2
ADDI x1, x1, 48     # change depending on lmul (lmul/vsew * stride)
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vsse8.v v4, x1, x2
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
ADDI x1, x1, 96     # change depending on lmul
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
ADDI x2, x2, 1         # stride++
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
# stride = 4
vsse32.v v4, x1, x2
ADDI x1, x1, 32      # change depending on lmul (128/32 * stride)
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vsse16.v v8, x1, x2
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
ADDI x1, x1, 64     # change depending on lmul (lmul/vsew * stride)
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vsse8.v v4, x1, x2
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
ADDI x1, x1, 128     # change depending on lmul
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
ADDI x2, x2, 1         # stride++
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
# stride = 5
vsse32.v v4, x1, x2
ADDI x1, x1, 40      # change depending on lmul (128/32 * stride)
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vsse16.v v8, x1, x2
ADDI x1, x1, 80     # change depending on lmul (lmul/vsew * stride)
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
vsse8.v v4, x1, x2
ADDI x1, x1, 160     # change depending on lmul
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
ADDI x2, x2, 1         # stride++
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
