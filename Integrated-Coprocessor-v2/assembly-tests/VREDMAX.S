# Vector Reduction Instructions

#VREDMAX

# vredmax.vs vd, vs2, vs1, vm # vd[0] = max( vs1[0] , vs2[*] )

vadd.vi v4, v0, 31               # v4 = 31 = 5'b11111
vadd.vi v8, v0, 4                # V8 = 4 = 3'b100
vredmax.vv v12, v8, v4           # v12 =  31 = 5'b11111