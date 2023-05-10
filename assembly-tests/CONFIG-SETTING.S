# vsetvli rd, rs1, vtype1
# rd = new vl, rs1 = AVL, vtypei = new vtype setting
#########################################################
vsetvli x0, x17, e8,m1       # vlmul = 1, vsew = 8
vsetvli x0, x17, e16,m1
vsetvli x0, x17, e32,m1

vsetvli x0, x17, e8,m2
vsetvli x0, x17, e16,m2
vsetvli x0, x17, e32,m2

vsetvli x0, x17, e8,m4
vsetvli x0, x17, e16,m4
vsetvli x0, x17, e32,m4


# vsetivli rd, uimm, vtypei
# rd = new vl, uimm = AVL, vtypei = new vtype setting
########################################################



# vsetvl rd, rs1, rs2
# rd = new vl, rs1 = AVL, vtypei = new vtype value  