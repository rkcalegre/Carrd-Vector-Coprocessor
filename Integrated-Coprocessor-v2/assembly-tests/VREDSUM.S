# Vector Reduction Instructions

#VREDSUM

# vredsum.vs vd, vs2, vs1, vm # vd[0] = sum( vs1[0] , vs2[*] )

vadd.vi v4, v0, 128               # v4 = 128
vadd.vi v8, v0, 4                 # v8 = 4
vredsum.vs v12, v8, x4           `# v12 =  # TO EDIT