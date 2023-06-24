ADDI x5, x0, 16         # x5 = 16
vsetivli x20, x5, 0     # 8-bit elements 128-bit vector
ADDI x5, x5, 16
ADDI x1, x0, 0          # store address: x1 = 0
ADDI x2, x0, 2          # stride: x2 = 2
ADDI x30, x0, 0         # looper
ADDI x29, x0, 4         # max loop: x29 = 4
vadd.vi v4, v0, 15      # store data 1: v4 = 15 = 0F0F0F0F
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
vadd.vi v8, v0, 10      # store data 2: v5 = 10 = 0A0A0A0A
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
ADDI x0, x0, 0
JAL x0, stride

stride:
    BEQ x30, x29, end
    vsse32.v v4, x1, x2   
    ADDI x1, x1, 8      # change depending on lmul (128/32 * stride)
    ADDI x0, x0, 0
    ADDI x0, x0, 0
    ADDI x0, x0, 0
    ADDI x0, x0, 0
    vsse16.v v8, x1, x2
    ADDI x1, x1, 16     # change depending on lmul (lmul/vsew * stride)
    ADDI x0, x0, 0
    ADDI x0, x0, 0
    ADDI x0, x0, 0
    ADDI x0, x0, 0
    vsse8.v v4, x1, x2
    ADDI x0, x0, 0
    ADDI x0, x0, 0
    ADDI x0, x0, 0
    ADDI x0, x0, 0
    ADDI x1, x1, 32     # change depending on lmul
    ADDI x0, x0, 0
    ADDI x0, x0, 0
    ADDI x0, x0, 0
    ADDI x0, x0, 0
    ADDI x30, x30, 1       # loop++
    ADDI x2, x2, 1         # stride++
    ADDI x29, x0, 4
    ADDI x0, x0, 0
    ADDI x0, x0, 0
    ADDI x0, x0, 0
    ADDI x0, x0, 0
    JAL x0, stride

end:
    ADDI x0, x0, 0
	ADDI x0, x0, 0
	ADDI x0, x0, 0
	ADDI x0, x0, 0
	ADDI x0, x0, 0
	ADDI x0, x0, 0
	ADDI x0, x0, 0
	ADDI x0, x0, 0
	ADDI x0, x0, 0
	ADDI x0, x0, 0
	ADDI x0, x0, 0
	ADDI x0, x0, 0
    ADDI x0, x0, 0
	ADDI x0, x0, 0
	ADDI x0, x0, 0
	ADDI x0, x0, 0
	ADDI x0, x0, 0
	ADDI x0, x0, 0
