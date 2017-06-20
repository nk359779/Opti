︠5646deaa-80e3-4f92-814a-30e294206766s︠
n = 0
A = []
def inf(E, w, k):
    global n
    global A
    E += [w]
    for i in range(0, n):
        if A[i][k] == w and i != w:
            inf(E, i, k)


f = open ('10.in' , 'r')
l = [ map(int,line.split(' ')) for line in f ]
f.close()
n = int(l[0][0])
l.remove(l[0])
A = list(l)

P = MixedIntegerLinearProgram(maximization=False, solver = "GLPK")
x = P.new_variable(integer=True, nonnegative=True)

O = ""

for i in range(0, n):
    E0 = []
    E1 = []
    if A[i][2] != 0:
        inf(E0, i, 0)
        P.add_constraint(sum(x[i] for i in E0), min = A[i][2])
    if A[i][3] != 0:
        inf(E1, i, 1)
        P.add_constraint(sum(x[i] for i in E1), min = A[i][3])
    P.add_constraint(x[i] <= 1)
P.set_objective(sum(x[i] for i in range(0,n)))
obj = P.solve()
obj = n - obj
out = ""
for i, v in P.get_values(x).iteritems():
    if int(v) == 0:
        out = out + str(i) + " "

g = open('10.out', 'w')
g.write(str(int(obj)) + "\n")
g.write(str(out))
g.close()
print "done"
︡521c1e90-62ae-4e35-8867-06688cd35a0b︡{"stdout":"done\n"}︡{"done":true}︡









