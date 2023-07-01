addi x5, x0, 16                 # x5 = 16
C.NOP
C.NOP
C.NOP
vsetivli x20, x5, 10            # 16-bit elements, 512-bit vector
addi x28, x0, 0                 # load data address - load data from mem
addi x30, x0, 0                 # store data address - store data in mem
addi x31, x0, 0                 # answer shift register
addi x18, x0, 8                 # max shift
addi x19, x0, 0                 # kernel shift
addi x9, x0, 7                  # max loop counter
addi x10, x0, 0                 # looper1
addi x11, x0, 0                 # looper2
jal, x0, max_pool

load_input:
    addi x0, x0, 0
    beq x10, x9, end
    vle32.v v0, x28
    addi x28, x28, 14
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    vslideup.vi v20, v0, 0
    vle32.v v4, x28
    addi x28, x28, 14
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    vslidedown.vi v0, v0, 4
    vslideup.vi v20, v4, 4
    vle32.v v8, x28
    addi x28, x28, 14
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    vslidedown.vi v4, v4, 4
    vslideup.vi v20, v8, 8
    vle32.v v12, x28
    addi x28, x28, 14
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    vslidedown.vi v8, v8, 4
    vslideup.vi v20, v12, 12
    vslidedown.vi v12, v12, 4
    addi x10, x10, 1            # loop1 counter++
    vsetivli x20, x5, 9         # 16-bit elements, 256-bit vector 
    vredmax.vs v28, v20, v20    # write answer to v28
    vslideup.vx v28, v28, x31
    addi x31, x31, 1            # increment shift answer
    vsetivli x20, x5, 10        # 16-bit elements, 512-bit vector 
    jal, x0, max_pool

max_pool:
    addi x0, x0, 0
    beq x11, x9, store_ans
    addi x11, x11, 1            # loop2 counter++
    vslideup.vx v20, v0, x19
    addi x19, x19, 4
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    vslidedown.vi v0, v0, 4
    vslideup.vx v20, v4, x19
    addi x19, x19, 4
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    vslidedown.vi v4, v4, 4
    vslideup.vx v20, v8, x19
    addi x19, x19, 4
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    vslidedown.vi v8, v8, 4
    vslideup.vx v20, v12, x19
    addi x19, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    vslidedown.vi v12, v12, 4
    vsetivli x20, x5, 11        # 16-bit elements, 256-bit vector 
    vredmax.vs v28, v20, v20    # write answer to v28
    vslideup.vx v28, v28, x31
    addi x31, x31, 1            # increment shift answer
    vsetivli x20, x5, 10        # 16-bit elements, 512-bit vector
    jal, x0, max_pool


store_ans:
    vsetivli x20, x5, 10        # 16-bit elements, 256-bit vector
    vse32.v v28, x30            # store answer in mem
    addi x30, x30, 4
    jal, x0, load_input

end:
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

