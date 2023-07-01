addi x5, x0, 16         # x5 = 16
C.NOP
C.NOP
C.NOP
vsetivli x20, x5, 10    # 16-bit elements, 512-bit vector
addi x28, x0, 16         # store data address & load data from m[0]

#relu 0
vle32.v v4, x0          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x0         
C.NOP
C.NOP
C.NOP
C.NOP

#relu 1
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 2
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 3
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 4
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 5
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 6
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 7
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 8
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 9
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 10
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 11
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 12
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 13
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 14
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 15
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 16
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 17
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 18
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 19
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 20
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 21
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 22
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 23
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 24
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 25
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 26
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16
C.NOP
C.NOP

#relu 27
vle32.v v4, x28          
C.NOP
C.NOP
C.NOP
C.NOP
vmax.vv v8, v0, v4
C.NOP
C.NOP
vse32.v v8, x28         
C.NOP
C.NOP
C.NOP
C.NOP


#end
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
