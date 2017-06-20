︠359a45f3-e43e-40af-a47f-5c4c6ac6abea︠
# -*- coding: utf-8 -*-

import itertools
import numpy
import random

def match(s1,s2): 
    die1 = s1[0][0]
    die2 = s2[0][0]
    call = s1
    player_call = 1
    
    if call[1] == [2,4]:
        if (die1 == 4 or die1 == 1) and (die2 == 4 or die2 == 1):
            return 1
        else:
            return -1
    
    for s in s2:
        if len(s) > 1:
            if s[0] == call[1]:
                call = s
                break
    player_call = 2
    while call[1] != [2, 4] and call[1] != 'call':
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

    if call[1] == [2,4]:
        if player_call == 2:
            if (die1 == 4 or die1 == 1) and (die2 == 4 or die2 == 1):
                return -1
            else: 
                return 1
        elif (die1 == 4 or die1 == 1) and (die2 == 4 or die2 == 1):
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
    for j in range(1,5):
        A += [[i, j]]
A += ['call']
A = list(A)
B = list(A)

M = []

A11 = []
A12 = []
A13 = []
A14 = []
A21 = []
A22 = []
A23 = []

for e in list(itertools.product(A, B)): #kartezjanskie mnozenie wszystkich kombinacji
    if e[1][0]>=e[0][0] and e[1][1]>e[0][1]:
        if e[0] == [1,1]: 
            A11 += [e] #wszystkie zagrywki zaczynajace sie od [1,1]
        elif e[0] == [1,2]:
            A12 += [e]
        elif e[0] == [1,3]:
            A13 += [e]
        elif e[0] == [1,4]:
            A14 += [e]
        elif e[0] == [2,1]:
            A21 += [e]
        elif e[0] == [2,2]:
            A22 += [e]
        elif e[0] == [2,3]:
            A23 += [e]
        #elif e[0] == [2,4]:
            #A24 += [e]
all_strat_1 = [] 
all_strat_2 = []         
for e11 in A11:
    for e12 in A12:
        for e13 in A13:
            for e14 in A14:
                for e21 in A21:
                    for e22 in A22:
                        for e23 in A23:
                            strat = [e11] + [e12] + [e13] + [e14] + [e21] + [e22] + [e23] #jak gracz 1 zagra [1,1] to ja zagram coś, jak zagra [1,2],...
                            for i in range(1, 5):
                                all_strat_2 += [[[i]] + strat] #dołączam do każdej pełnej zagrywki liczbe oczek na kosce
for e12 in A12:
        for e13 in A13:
            for e14 in A14:
                for e21 in A21:
                    for e22 in A22:
                        for e23 in A23:
                            strat = [e12] + [e13] + [e14] + [e21] + [e22] + [e23]
                            for i in range(1,3):
                                for j in range(1,5):
                                    for element in strat:
                                        if element[0][0] <= i and element[0][1] <= j:
                                            strat.remove(element) # jesli moim pierwszym ruchem jest [1,4] to muszę usunac wszystkie zagrywki zaczynajace sie od <=[1,4]
                                    all_strat_1 += [[[j]] + [[i, j]] + strat]


all_strat_1 = numpy.unique(all_strat_1).tolist()

A11 = []
A12 = []
A13 = []
A14 = []
A21 = []
A22 = []
A23 = []
A24 = []

for element in all_strat_1:
    if element[0][0] == 1:
        A11 += [element] #lista ze strategiami dla 1 na kostce
    if element[0][0] == 2:
        A12 += [element]
    if element[0][0] == 3:
        A13 += [element]
    if element[0][0] == 4:
        A14 += [element]
        
for element in all_strat_2:
    if element[0][0] == 1:
        A21 += [element]
    if element[0][0] == 2:
        A22 += [element]
    if element[0][0] == 3:
        A23 += [element]
    if element[0][0] == 4:
        A24 += [element]

all_strat_1 = []
all_strat_2 = []

for e11 in A11:
    for e12 in A12:
        for e13 in A13:
            for e14 in A14:
                all_strat_1 += [[e11] + [e12] + [e13] + [e14]] #pelna strategia czyli zagrywki dla 1,2,3,4 na kostce lacznie

for e21 in A21:
    for e22 in A22:
        for e23 in A23:
            for e24 in A24:
                all_strat_2 += [[e21] + [e22] + [e23] + [e24]]

for s1 in all_strat_1: #rozgrywamy kombinacje wszystkich meczy dla danej strategi gracza 1 i 2
    A = []
    for s2 in all_strat_2:
        a = 0
        for ss1 in s1:
            for ss2 in s2:
                a += match(ss1, ss2)
        A += [a]
    M += [A]

#Reszta przekopiowana z ktoregos z labow

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
show(P)
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









