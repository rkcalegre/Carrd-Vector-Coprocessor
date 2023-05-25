# Vector Reduction Instructions

#VREDMAX

# vredmax.vs vd, vs2, vs1, vm # vd[0] = max( vs1[0] , vs2[*] )

vadd.vi v4, v0, 128               # v4 = 128
vadd.vi v8, v0, 4                 # V8 = 4
vredmax.vs v12, v8, x4           `# v12 =  # TO EDIT