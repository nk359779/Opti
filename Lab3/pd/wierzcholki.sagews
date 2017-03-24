import itertools
def findsubsets(S,m):
    return list(itertools.combinations(S, m))

A = matrix([[-1,1,1,0,0],[1,0,0,1,0],[0,1,0,0,1]])
b = vector([1,3,2])
c = vector([1,1,0,0,0])
lw = len(list(A))
lk = len(list(A[0]))
v = []
S = set(i for i in range(0,lk))
submatrices = findsubsets(S,lw)
for item in submatrices:
    Ak = []
    for j in item:
        Ak = Ak + list(matrix([A.column(j)]))
    Ak = matrix(Ak).T
    if Ak.determinant() != 0:
        vk = Ak.solve_right(b)
        template = list(0 for i in range(0,lk))
        l = 0
        dodatnie = true
        for j in item:
            template[j] = vk[l]
            if vk[l] < 0:
                dodatnie = false
            l += 1
        if dodatnie == true:
            v.append(template)
if v == []:
    print "INFEASIBLE"
else:
    maxvalue = vector(v[0])*c
    maxv = vector(v[0])
    for item in v:
        if vector(item)*c > maxvalue:
            maxvalue = vector(item)*c
            maxv = vector(item)
    print "Wartosc maksymalna = " + str(maxvalue)
    print "Wektor na ktorym jest osiagana = " + str(maxv)
