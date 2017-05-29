Autorzy rozwiązania: Natalia Kwiecień i Jakub Dudziński

W pliku Zad3_dual znajduje się sformułowanie problemu pierwotnego, tj. znalezienia skojarzenia maksymalnego.
Solver problemów liniowych (http://hgourvest.github.io/glpk.js/) dla tak zdefiniowanego problemu znalazł rozwiązanie optymalne, całkowitoliczbowe:

INTEGER OPTIMAL SOLUTION FOUND
{"x11":0,"x13":0,"x16":1,"x21":0,"x24":1,"x32":0,"x33":0,"x35":1,"x41":1,"x44":0,"x47":0,"x52":0,"x57":1,"x62":1,"x65":0,"x66":0,"x73":1,"x77":0},

gdzie x11 oznacza krawędź łączącą punkt A (pierwszy z góry) z punktem q (pierwszy z dołu), x23 - krawędź łączącą B z s itd.
Znalezione rozwiązanie jest, jakimś, rozwiązaniem optymalnym (wartośc funkcji celu dla niego wynosi 7, choc różnym od tego na rysunku w książce.

Następnie znaleźliśmy problem dualny - za pomocą skryptu Zad3_dual.
Zmienne w problemie dualnym należy interpretować następująco - zmienne od y1 do y14 to określenie czy dany wierzchołek należy wziąć do minimalnego pokrycia (wartość zmiennej 1), czy też go nie brać (wartośc zmiennej 0).
Zmienne y1 do y14 odpowiadają kolejno wierzchołkom A, B, ..., q, r, ..., w.
Wartością optymalną znalezioną przez solver jest 7 i (wg. wikipedii) jest to istotnie rozwiązanie optymalne bo dla grafu dwudzielnego jest to min z liczby wierzchołków "u góry grafu" i "u dołu grafu" czyli min(7,7)=7.
Znalezione rozwiązanie optymalne (za pomocą solvera z danymi z pliku Zad3_dual.lp) to:

INTEGER OPTIMAL SOLUTION FOUND
{"y1":1,"y2":1,"y3":1,"y4":1,"y5":1,"y6":1,"y7":1,"y8":0,"y9":0,"y10":0,"y11":0,"y12":0,"y13":0,"y14":0,"y15":0,"y16":0,"y17":0,"y18":0,"y19":0,"y20":0,"y21":0,"y22":0,"y23":0,"y24":0,"y25":0,"y26":0,"y27":0,"y28":0,"y29":0,"y30":0,"y31":0,"y32":0},

Rozwiązanie jest istotnie pokryciem (sprawdzone za pomocą kartki i papieru). Do naszego pokrycia bierzemy wierzchołki od A do G (co jest jednym z dwóch oczywistych rozwiązań).
