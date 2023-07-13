addi x5, x0, 16                 # x5 = 16
addi x21, x0, 0                 # load data address - load data from mem
addi x30, x0, 0                 # store data address - store data in mem
addi x31, x0, 0                 # answer shift register
addi x18, x0, 8                 # max shift
addi x19, x0, 0                 # kernel shift
addi x22, x0, 2                 # filter address
slli x22, x22, 8                # 5x5 filter stored in m[512]
addi x9, x0, 14                 # max loop counter
addi x10, x0, 0                 # looper1 for load_input
addi x11, x0, 0                 # looper2 for kernel_load
addi x12, x0, 0                 # looper3 for convolution
addi x25, x0, 0                 # address of v0 every row iteration
jal, x0, load_input

load_input:                     # loads 4 rows of 128b data into v0-v3, v4-v7, v8-v11, and v12-v15
    addi x0, x0, 0
    beq x10, x9, end
    add x21, x0, x25            # adjusting v0 load address 
    addi x25, x25, 32           #implemented since stride = 2
    addi x11, x0, 0             # reset loop2 counter
    vsetivli x20, x5, 10        # 16-bit elements, 512-bit vector
    vle32.v v0, x21             # Loads a single 32-element row
    addi x21, x21, 16
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    vle32.v v4, x21             # Loads the succeeding 32-element row
    addi x21, x21, 16
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    vle32.v v8, x21             # Loads the succeeding 32-element row
    addi x21, x21, 16
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    vle32.v v12, x21            # Loads the succeeding 32-element row
    addi x21, x21, 16
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    vle32.v v16, x21            # Loads the succeeding 32-element row
    addi x21, x21, 16
    addi x10, x10, 1            # loop1 counter++
    jal, x0, kernel_load

kernel_load:
    addi x0, x0, 0
    beq x11, x9, load_input
    vsetivli x20, x5, 10        # 16-bit elements, 512-bit vector
    addi x11, x11, 1            # loop2 counter++
    vslideup.vi v20, v0, 0      # place first 5 elements of row1 in kernel
    addi x0, x0, 0
    addi x0, x0, 0
    vslidedown.vi v0, v0, 2     # drop first 2 elements of row1 (stride = 2)
    addi x0, x0, 0
    addi x0, x0, 0
    vslideup.vi v20, v4, 5      # place first 5 elements of row2 next to row1 elements
    addi x0, x0, 0
    addi x0, x0, 0
    vslidedown.vi v4, v4, 2     # drop first 2 elements of row2 (stride = 2)
    addi x0, x0, 0
    addi x0, x0, 0
    vslideup.vi v20, v8, 10     # place first 5 elements of row3 next to row2 elements
    addi x0, x0, 0
    addi x0, x0, 0
    vslidedown.vi v8, v8, 2     # drop first 2 elements of row3 (stride = 2)
    addi x0, x0, 0
    addi x0, x0, 0
    vslideup.vi v20, v12, 15    # place first 5 elements of row4 next to row3 elements
    addi x0, x0, 0
    addi x0, x0, 0
    vslidedown.vi v12, v12, 2   # drop first 2 elements of row4 (stride = 2)
    addi x0, x0, 0
    addi x0, x0, 0
    vslideup.vi v20, v16, 20    # place first 5 elements of row4 next to row3 elements
    addi x0, x0, 0
    addi x0, x0, 0
    vslidedown.vi v16, v16, 2   # drop first 2 elements of row5 (stride = 2)
    jal, x0, convolution        # one 5x5 kernel COMPLETE -> perform convolution

convolution:                    # performs convolution on 5x5 matrix
    addi x0, x0, 0
    vsetivli x20, x5, 10        # 16-bit elements, 512-bit vector
    vle32.v v24, x22            # load filter
    vmul.vv v20, v20, v24       # dot product
    vmv.s.x v24, x0             # v24[0] = 0: Drop first element of filter matrix
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    vredsum.vs v20, v20, v24    # write answer in v20
    vslideup.vx v28, v20, x31   # shift contents of answer vector
    beq x31, x18, store_ans     # TO BE CHANGED
    addi x31, x31, 1            # increment shift answer
    jal x0, kernel_load

store_ans:
    vsetivli x20, x5, 8         # 16-bit elements, 128-bit vector
    vse32.v v28, x30            # store answer in mem
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x30, x30, 4
    addi x31, x0, 0             # reset shift for answers
    jal, x0, convolution

end:
    vse32.v x28, x30            # account for the remaining answers not stored above
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
    addi x0, x0, 0
