addi x5, x0, 16             # x5 = 16
C.NOP
C.NOP
vsetivli x20, x5, 10        # 16-bit elements, 512-bit vector
addi x28, x0, 0             # store data address - load data from m[0]
addi x18, x0, 15            # value for a


#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
C.NOP
C.NOP

#parametric_relu :            # f(x) = max(ax , x)
vle32.v v4, x28
C.NOP
C.NOP
C.NOP
vmul.vx v8, v4, x18     # v8 = ax
C.NOP
C.NOP   
vmax.vv v12, v4, v8     # v12 = max(v8, v4) = max(ax, x)
C.NOP
C.NOP
vse32.v v12, x28
C.NOP
C.NOP
C.NOP
C.NOP
addi x28, x28, 16       # address++
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
