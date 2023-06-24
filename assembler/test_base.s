ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 16     # 8-bit elements 128-bit vector
ADDI x5, x5, 16
ADDI x8, x0, 0
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
NOP	#from C.NOP
ADDI x8, x0, 0
vle32.v v4, x8
vle16.v v8, x8
vle8.v v12, x8
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
