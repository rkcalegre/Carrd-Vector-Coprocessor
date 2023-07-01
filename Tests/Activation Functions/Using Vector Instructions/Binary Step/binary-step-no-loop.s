addi x5, x0, 16             # x5 = 16
C.NOP
C.NOP
C.NOP
vsetivli x20, x5, 10        # 16-bit elements, 512-bit vector
addi x28, x0, 0             # store data address - load data from m[0]
addi x9, x0, 28             # max loop counter
addi x29, x0, 0             # looper
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#BINARY STEP
beq x29, x9, end
vle32.v v4, x28
vsrl.vi v8, v4, 15   
vse32.v v8, x28
addi x29, x29, 1        # loop_iter++
addi x28, x28, 16       # address++
C.NOP
C.NOP
C.NOP
C.NOP
#END
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
