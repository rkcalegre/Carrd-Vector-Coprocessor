# A single kernel refers to a 4x4 matrix
# A 'kernel row' refers to the 4 elements in a kernel 'row'
# A 'group of kernels' refers to the 8 kernels in a 32x32 matrix
# Note: data addresses are word-addressable - this is why the offsets are multplied in increments of 4
addi x8, x0, 0                  # load data address - load data from mem
addi x30, x0, 0                 # store data address - store data in mem
addi x10, x0, 0                 # looper1 - ith 'group of kernels'
addi x31, x0, 0                 # looper2 - load a single kernel starting address 
addi x12, x0, 0                 # looper3 - refers to the ith element in a single kernel row
addi x13, x0, 0                 # looper4 - iterates through the elements in a single kernel row
addi x14, x0, 9                 # loop 1 max counter - limit of 'group of kernels'
addi x15, x0, 128               # loop 2 max counter - resets the kernel starting address to the kernel located in the first column
addi x16, x0, 4                 # loop 3 max counter - number of rows in a single kernel
addi x17, x0, 4                 # loop 4 max counter - number of elements in a single kernel row
jal, x0, loop_row

loop_row:                       # next row of input array with stride = 2
    addi x10, x10, 1            # increment looper1
    bne x10, x14, loop_kernel
    jal x0, end

loop_kernel:
    addi x8, x31, 0            # reset load address
    addi x23, x0, 0            # x23 = max number holder
    bne x31, x15, loop_kernel_elem
    addi x31, x31, 192
    addi x31, x31, 192
    addi x27, x0, 1 
    slli x27, x27, 9            # 512 
    add x15, x15, x27
    addi x8, x31, 0
    jal x0, loop_row
    
loop_kernel_elem:
    addi x13, x0, 0            # reset looper4
    beq x12, x16, store
    addi x12, x12, 1           # increment looper3
    lw x18, 0(x8)              # load element 0 of kernel (Upper left element)
    lw x19, 4(x8)              # load element 1
    lw x20, 8(x8)              # load element 2    
    lw x21, 12(x8)             # load element 3
    addi x8, x8, 128
    add x24, x0, x18           # temp shifted element holder
    jal x0, max

max:
    beq x13, x17, loop_kernel_elem
    addi x13, x13, 1            # increment looper4
    slt x22, x23, x24           # set x22 if x18 < x19
    beq x22, x0, max_else       # this will overwrite x23 with x18 if x18 > x19
    add x23, x0, x24            # default: x23 = x24. x23 holds max number
    add x24, x0, x19            # overwrite x24 with the next element
    add x19, x0, x20            # overwrite x19 with the next element
    add x20, x0, x21            # move x21 to x20 (it's like you're shifting the contents of the row)
    jal x0, max

max_else:
    add x24, x0, x19            # overwrite x24 with the next element
    add x19, x0, x20            # overwrite x19 with the next element
    add x20, x0, x21            # move x21 to x20 (it's like you're shifting the contents of the row)
    jal x0, max

store:
    sw x23, 0(x30)              # store max number in kernel
    addi x30, x30, 4            # increment address
    addi x31, x31, 16           # goto starting address of next kernel
    addi x12, x0, 0             # reset looper3
    jal x0, loop_kernel

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
