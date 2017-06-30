︠623f2fa2-7265-4053-abc0-8abf40bc0132︠
# -*- coding: utf-8 -*-

import itertools
import numpy
import random

def match(s1,s2): 
    die1 = s1[0][0]
    die2 = s2[0][0]
    call = s1
    player_call = 1
    
    if call[1] == [2,2]:
        if (die1 == 2 or die1 == 1) and (die2 == 2 or die2 == 1):
            return 1
        else:
            return -1
    
    for s in s2:
        if len(s) > 1:
            if s[0] == call[1]:
                call = s
                break
    player_call = 2
    while call[1] != [2, 2] and call[1] != 'call':
        skip = 0
        if player_call == 2:
            for s in s1:
                if len(s) > 1:
                    if s[0] == call[1]:
                        call = s
                        break
            player_call = 1
            skip = 1
        if player_call == 1 and skip == 0:
            for s in s2:
                if len(s) > 1:
                    if s[0] == call[1]:
                        call = s
                        break
            player_call = 2

    if call[1] == [2,2]:
        if player_call == 2:
            if (die1 == 2 or die1 == 1) and (die2 == 2 or die2 == 1):
                return -1
            else: 
                return 1
        elif (die1 == 2 or die1 == 1) and (die2 == 2 or die2 == 1):
            return 1
        else: 
            return -1
    if call[1] == 'call':
        if player_call == 2:
            if call[0][0] == 2:
                if (die1 == call[0][1] or die1 == 1) and (die2 == call[0][1] or die2 == 1):
                    return 1
                else:
                    return -1
            elif die1 == call[0][1] or die2 == call[0][1] or die1 == 1 or die2 == 1:
                return 1
            else:
                return -1
        elif call[0][0] == 2:
            if (die1 == call[0][1] or die1 == 1) and (die2 == call[0][1] or die2 == 1):
                return -1
            else:
                return 1
        elif die1 == call[0][1] or die2 == call[0][1] or die1 == 1 or die2 == 1:
            return -1
        else:
            return 1

A = []
for i in range(1,3):
    for j in range(1,3):
        A += [[i, j]]
A += ['call']
A = list(A)
B = list(A)

M = []

A11 = []
A12 = []
A21 = []
A22 = []


for e in list(itertools.product(A, B)): #kartezjanskie mnozenie wszystkich kombinacji
    if e[1][0]>=e[0][0] and e[1][1]>e[0][1]:
        if e[0] == [1,1]:
            A11 += [e] #wszystkie zagrywki zaczynajace sie od [1,1]
        elif e[0] == [1,2]:
            A12 += [e]
        elif e[0] == [2,1]:
            A21 += [e]
        elif e[0] == [2,2]:
            A22 += [e]
all_strat_1 = [] 
all_strat_2 = []         
for e11 in A11:
    for e12 in A12:
        for e21 in A21:
            for e22 in A22:
                strat = [e11] + [e12] + [e21] + [e22] #jak gracz 1 zagra [1,1] to ja zagram coś, jak zagra [1,2],...
                for i in range(1, 5):
                    all_strat_2 += [[[i]] + strat] #dołączam do każdej pełnej zagrywki liczbe oczek na kosce
for e12 in A12:
    for e21 in A21:
        for e22 in A22:
            strat = [e12] + [e21] + [e22]
            for i in range(1,3):
                for j in range(1,5):
                    for element in strat:
                        if element[0][0] <= i and element[0][1] <= j:
                            strat.remove(element) # jesli moim pierwszym ruchem jest [1,4] to muszę usunac wszystkie zagrywki zaczynajace sie od <=[1,4]
                            all_strat_1 += [[[j]] + [[i, j]] + strat]


all_strat_1 = numpy.unique(all_strat_1).tolist()

A11 = []
A12 = []
A21 = []
A22 = []

for element in all_strat_1:
    if element[0][0] == 1:
        A11 += [element] #lista ze strategiami dla 1 na kostce
    elif element[0][0] == 2:
        A12 += [element]
        
for element in all_strat_2:
    if element[0][0] == 1:
        A21 += [element]
    elif element[0][0] == 2:
        A22 += [element]

all_strat_1 = []
all_strat_2 = []

for e11 in A11:
    for e12 in A12:
        all_strat_1 += [[e11] + [e12]] #pelna strategia czyli zagrywki dla 1,2,3,4 na kostce lacznie

for e21 in A21:
    for e22 in A22:
        all_strat_2 += [[e21] + [e22]]

for s1 in all_strat_1: #rozgrywamy kombinacje wszystkich meczy dla danej strategi gracza 1 i 2
    A = []
    for s2 in all_strat_2:
        a = 0
        for ss1 in s1:
            for ss2 in s2:
                a += match(ss1, ss2)
        A += [a]
    M += [A]

    
print all_strat_1[0]
print all_strat_2[29]

#Reszta przekopiowana z ktoregos z labow
M= matrix(M)
A = list([[-1 for i in range(M.ncols())]]) +  list(M) #odejmujemy zmienną x0 od równań
A = matrix(A)
A=A.T
A = list(A) + list([[0] +[1 for i in range(A.ncols() - 1)]]) #dodajemy warunek x1+x2+...+xn = 1
A = matrix(A)
c = [1] + [0 for i in range(A.ncols() - 1)]
b = [0 for i in range(A.nrows() - 1)] + [1]
var_type = [""] + [">=" for i in range(A.ncols() - 1)] #Technikalia
constr_type = [">=" for i in range(A.nrows() - 1)]  + ["=="]
L_var = ["x%i" %i for i in range(A.ncols())]
P = InteractiveLPProblem(A, b, c, L_var, constraint_type = constr_type, variable_type = var_type)
#show(P)
solution = P.optimal_solution()
solution = vector(solution[1:len(solution)])
print str(L_var[1:len(L_var)]) + " = " + str(solution)
#szukamy naj;epszej odpowiedzi gracza 2. <- podobnie jak szukanie optymalnej strategii dla gracza 1
c = solution * M
L_var = ["y%i" %i for i in range(A.nrows())]
L_var = L_var[1:len(L_var)]
A = [1 for i in range(A.nrows() - 1)]
b=[1]
P = InteractiveLPProblem(A, b, c, L_var, constraint_type="==", variable_type=">=", problem_type="min")
show(P)
solution = P.optimal_solution()
print str(L_var) + " = " + str(solution)
︡6cd7d2d9-4640-488b-ae05-97b46e7f20fc︡{"stdout":"[[[1], [2, 1], ([2, 2], 'call')], [[2], [1, 2], ([2, 1], [2, 2]), ([2, 2], 'call')]]\n"}︡{"stdout":"[[[1], ([1, 1], 'call'), ([1, 2], 'call'), ([2, 1], [2, 2]), ([2, 2], 'call')], [[2], ([1, 1], 'call'), ([1, 2], 'call'), ([2, 1], 'call'), ([2, 2], 'call')]]\n"}︡{"stdout":"duuuupa\n"}︡{"stdout":"['x1', 'x2', 'x3'] = (1, 0, 0)\n"}︡{"html":"<div align='center'>$\\displaystyle \\begin{array}{l}\n\\begin{array}{lcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcrcl}\n \\min \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{7} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{8} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{9} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{10} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{11} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{12} \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{19} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{20} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{21} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{22} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{23} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{24} \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{31} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{32} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{33} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{34} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{35} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} 2 y_{36} \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu} \\\\\n \\mspace{-6mu}&amp;\\mspace{-6mu}  \\mspace{-6mu}&amp;\\mspace{-6mu} y_{1} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{2} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{3} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{4} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{5} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{6} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{7} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{8} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{9} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{10} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{11} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{12} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{13} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{14} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{15} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{16} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{17} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{18} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{19} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{20} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{21} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{22} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{23} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{24} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{25} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{26} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{27} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{28} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{29} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{30} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{31} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{32} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{33} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{34} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{35} \\mspace{-6mu}&amp;\\mspace{-6mu} + \\mspace{-6mu}&amp;\\mspace{-6mu} y_{36} \\mspace{-6mu}&amp;\\mspace{-6mu} = \\mspace{-6mu}&amp;\\mspace{-6mu} 1 \\\\\n\\end{array} \\\\\ny_{1}, y_{2}, y_{3}, y_{4}, y_{5}, y_{6}, y_{7}, y_{8}, y_{9}, y_{10}, y_{11}, y_{12}, y_{13}, y_{14}, y_{15}, y_{16}, y_{17}, y_{18}, y_{19}, y_{20}, y_{21}, y_{22}, y_{23}, y_{24}, y_{25}, y_{26}, y_{27}, y_{28}, y_{29}, y_{30}, y_{31}, y_{32}, y_{33}, y_{34}, y_{35}, y_{36} \\geq 0\n\\end{array}$</div>"}︡{"stdout":"['y1', 'y2', 'y3', 'y4', 'y5', 'y6', 'y7', 'y8', 'y9', 'y10', 'y11', 'y12', 'y13', 'y14', 'y15', 'y16', 'y17', 'y18', 'y19', 'y20', 'y21', 'y22', 'y23', 'y24', 'y25', 'y26', 'y27', 'y28', 'y29', 'y30', 'y31', 'y32', 'y33', 'y34', 'y35', 'y36'] = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0)\n"}︡{"done":true}︡









