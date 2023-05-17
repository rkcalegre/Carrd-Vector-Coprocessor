l=[0xfa, 0x00, 0x00, 0xef, 0x01, 0x02, 0x87, 0x00, 0x11, 0x11, 0xb0, 0xb0, 0x45, 0xba, 0x12, 0x34, 0x22, 0x22, 0x22, 0x22, 0xa1, 0xb2, 0xc3, 0x4d, 0x78, 0xab, 0x1b, 0x90, 0x74, 0xcf, 0xae, 0x45, 0xc0, 0xe1, 0x99, 0xe5, 0xee, 0xe1, 0x23, 0xab, 0x76, 0x89, 0xeb, 0xa2, 0x2a, 0xbc, 0x65, 0x73, 0x90, 0x93, 0x2a, 0xb2, 0xe4, 0x57, 0xfd, 0xb0, 0x12, 0x80, 0x56, 0x78, 0x10, 0x6b, 0xdc, 0x3a]
m=[]
for i in range(0,16):
    #print(format(l[4*i+3]+l[4*i+2],"02x")[-2:])
    m.append(l[4*i+3]+l[4*i+2])
    #print(format(l[4*i+1]+l[4*i+0],"02x")[-2:])
    m.append(l[4*i+1]+l[4*i+0])
n=[]

for i in range(0,len(m)):
    print(format(m[i],"02x")[-2:],end="")
    print("[",i*8,":",((i)*8)+7,"]")
print("")
for i in range(0,8):
    print(format(m[4*i+1]+m[4*i+0],"02x")[-2:])
    n.append(m[4*i+1]+m[4*i+0])
    print(format(m[4*i+3] + m[4*i+2],"02x")[-2:])
    n.append(m[4*i+3] + m[4*i+2])
o=[]
for i in range(0,len(n)):
    print(format(n[i],"02x")[-2:],end="")
    print("[",i*8,":",((i)*8)+7,"]")
print("")
for i in range(0,4):
    print(format(n[4*i+1]+n[4*i+0],"02x")[-2:])
    o.append(n[4*i+1]+n[4*i+0])
    print(format(n[4*i+3] + n[4*i+2],"02x")[-2:])
    o.append(n[4*i+3] + n[4*i+2])

p=[]
for i in range(0,len(o)):
    print(format(o[i],"02x")[-2:],end="")
    print("[",i*8,":",((i)*8)+7,"]")
print("")
for i in range(0,2):
    print(format(o[4*i+1]+o[4*i+0],"02x")[-2:])
    p.append(o[4*i+1]+o[4*i+0])
    print(format(o[4*i+3] + o[4*i+2],"02x")[-2:])
    p.append(o[4*i+3] + o[4*i+2])
    
q=[]
for i in range(0,len(p)):
    print(format(p[i],"02x")[-2:],end="")
    print("[",i*8,":",((i)*8)+7,"]")
print("")
for i in range(0,1):
    print(format(p[4*i+1]+p[4*i+0],"02x")[-2:])
    q.append(p[4*i+1]+p[4*i+0])
    print(format(p[4*i+3] + p[4*i+2],"02x")[-2:])
    q.append(p[4*i+3] +p[4*i+2])