# Vector Reduction Instructions

#VREDMAX
vadd.vi v4, v0, 128               # v4 = 128
nop
vadd.vi v8, v0, 4                 # V8 = 4
nop
vredmax.vs v12, v8, x4           `# v12 =  # TO EDIT
nop

#VREDSUM
vredsum.vs v12, v8, x4           `# v12 =  # TO EDIT
nop
