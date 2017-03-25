A = matrix([[-1,1,1,0,0],[1,0,0,1,0],[0,1,0,0,1]])
b = vector([1,3,2])
c = vector([1,1,0,0,0])

import itertools
def findsubsets(S,m): #funkcja ktora zwraca liste wszystkich m-elementowych podzbiorow S
    return list(itertools.combinations(S, m))
#zakladamy ze kolumn jest zawsze wiecej niz wierszy (problem dobrze zdefiniowany)
#i wiersze sa lnz
#zakładamy ponadto, że maksimum przyjmowane jest w ktorymś z wierzchołków
lw = len(list(A))
lk = len(list(A[0]))
v = []
S = set(i for i in range(0,lk))
submatrices = findsubsets(S,lw) #lista numerow kolumn, z ktorych da sie utworzyc macierze lw x lw
for item in submatrices:
    Ak = []
    for j in item:
        Ak = Ak + list(matrix([A.column(j)]))
    Ak = matrix(Ak).T
    if Ak.determinant() != 0:
        vk = Ak.solve_right(b)
        template = list(0 for i in range(0,lk))
        l = 0
        dodatnie = true #sprawdzenie czy wektor rozwiazania jest dodatni (w zalozeniu musi byc)
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
    print "Wartosc maksymalna = " + str(maxvalue) #Jeśli wartość maksymalna jest przyjmowana w więcej niż jednym punkcie to podajemy jeden z nich
    print "Wektor na ktorym jest osiagana = " + str(maxv)
