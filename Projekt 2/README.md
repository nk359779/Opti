# Projekt 2

Autorzy: Natalia Kwiecień i Jakub Dudziński

Instrukcja i opis do znalezienia w pliku projekt-2.pdf, kod w pliku projekt2.sagews

# Update

Przeprowadziliśmy testy dla kostki dwuściennej. Otrzymaliśmy następujące wyniki:
['x1', 'x2', 'x3'] = (1, 0, 0)
['y1', 'y2', 'y3', 'y4', 'y5', 'y6', 'y7', 'y8', 'y9', 'y10', 'y11', 'y12', 'y13', 'y14', 'y15', 'y16', 'y17', 'y18', 'y19', 'y20', 'y21', 'y22', 'y23', 'y24', 'y25', 'y26', 'y27', 'y28', 'y29', 'y30', 'y31', 'y32', 'y33', 'y34', 'y35', 'y36'] = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0)

Czyli dla gracza 1 strategią wygrywającą jest:

[[[1], [2, 1], ([2, 2], 'call')], [[2], [1, 2], ([2, 1], [2, 2]), ([2, 2], 'call')]]

Jeśli wyrzucę 1 na kostce, to zagram [2,1], a jak przeciwnik zagra [2,2] to zagram "call". Jeśli wyrzucę 2 na kostce, to zagram [1,2]. Jeśli przeciwnik zagra [2,1], to zagram [2,2], jeśli zagra [2,2] to zagram "call". 

Ta strategia jest najlepszą odpowiedzią na wyliczoną strategię gracza 2:

[[[1], ([1, 1], 'call'), ([1, 2], 'call'), ([2, 1], [2, 2]), ([2, 2], 'call')], [[2], ([1, 1], 'call'), ([1, 2], 'call'), ([2, 1], 'call'), ([2, 2], 'call')]]

Razem tworzą one więc równowagę Nasha.


