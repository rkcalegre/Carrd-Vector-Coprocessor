addi x5, x0, 16             # x5 = 16
C.NOP
C.NOP
C.NOP
vsetivli x20, x5, 10        # 16-bit elements, 512-bit vector
addi x28, x0, 0             # store data address - load data from m[0]

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#LOOP
vle32.v v4, x28
C.NOP
C.NOP
vsrl.vi v8, v4, 15  
vxor.vi v8, v8, 1
C.NOP
C.NOP
vse32.v v8, x28
C.NOP
C.NOP
addi x28, x28, 16       # address++
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
