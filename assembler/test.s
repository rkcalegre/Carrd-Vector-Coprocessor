vadd.vi v16, v16, 21        # v16 = 5'b10101 //imm
vadd.vi v20, v20, 31        # v20 = 5'b11111 //imm
vand.vv v24, v20, v16       # v24 = v20 && v16 = 5'b10101 = 21
