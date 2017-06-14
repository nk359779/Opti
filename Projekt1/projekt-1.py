#
# Rozne implementacje pivot rules
#
import random
import operator
import numpy
import math
import copy

# Porzadek leksykograficzny, minimum

def lexicographical_min_entering(self):
	return min(self.possible_entering())

def lexicographical_min_leaving(self):
	return min(self.possible_leaving())

# Porzadek leksykograficzny, maximum

def lexicographical_max_entering(self):
	return max(self.possible_entering())

def lexicographical_max_leaving(self):
	return max(self.possible_leaving())

# Największy wzrost

def largest_increase(self):
    obj_now = self.objective_value()
    enter_max = ""
    leave_max = ""
    temp = copy.deepcopy(self)
    x = self.possible_entering()[0]
    temp.enter(x)
    y = temp.possible_leaving()[0]
    obj_curr = temp.objective_value()
    obj_max = obj_curr
    enter_max = x
    leave_max = y
    for i in self.possible_entering():
        temp = copy.deepcopy(self)
        temp.enter(i)
        for j in temp.possible_leaving():
            temp.leave(j)
            temp.update()
            obj_curr = temp.objective_value()
            if math.fabs(obj_curr-obj_now) >= math.fabs(obj_max-obj_now):
                obj_max = obj_curr
                enter_max = i
                leave_max = j
            temp = copy.deepcopy(self)
            temp.enter(i)
    return [enter_max, leave_max]

# Najmniejszy wzrost

def smallest_increase(self):
    obj_now = self.objective_value()
    obj_min = obj_now
    enter_min = ""
    leave_min = ""
    temp = copy.deepcopy(self)
    x = self.possible_entering()[0]
    temp.enter(x)
    y = temp.possible_leaving()[0]
    obj_curr = temp.objective_value()
    obj_min = obj_curr
    enter_min = x
    leave_min = y
    for i in self.possible_entering():
        temp = copy.deepcopy(self)
        temp.enter(i)
        for j in temp.possible_leaving():
            temp.leave(j)
            temp.update()
            obj_curr = temp.objective_value()
            if math.fabs(obj_curr-obj_now) <= math.fabs(obj_min-obj_now):
                obj_min = obj_curr
                enter_min = i
                leave_min = j
            temp = copy.deepcopy(self)
            temp.enter(i)
    return [enter_min, leave_min]
    

# Największy wspolczynnik

def max_coefficient_entering(self):
    max_value = max(self.objective_coefficients())
    max_index = list(self.objective_coefficients()).index(max_value)
    return list(self.nonbasic_variables())[max_index] 

# Losowy wybor wierzcholka

def uni_random_entering(self):
    return random.choice(self.possible_entering())

def uni_random_leaving(self):
    return random.choice(self.possible_leaving())

# Średnia ważona

def weighted_random_entering(self):
    A = self.possible_entering()
    licz = 1
    B = []
    for j in A[int(len(A)/2)::-1]:
        for i in range(0, licz):
            B += [A.index(j)]
        licz = 2 * licz
    licz=2
    for j in A[int(len(A)/2+1):]:
        for i in range(0, licz):
            B += [A.index(j)]
        licz = 2 * licz
    draw = random.choice(B)
    return A[draw]

def weighted_random_leaving(self):
    A = self.possible_leaving()
    licz = 1
    B = []
    for j in A[int(len(A)/2)::-1]:
        for i in range(0, licz):
            B += [A.index(j)]
        licz = 2 * licz
    licz=2
    for j in A[int(len(A)/2+1):]:
        for i in range(0, licz):
            B += [A.index(j)]
        licz = 2 * licz
    draw = random.choice(B)
    return A[draw]

# No - stromo
def steepest_edge(self):
    keeplooping = true
    v_old = [0 for i in range(0,len(self.basic_variables()) + len(self.nonbasic_variables()))]
    c = [0 for i in range(0,len(self.basic_variables()) + len(self.nonbasic_variables()))]
    c_old = self.objective_coefficients()
    basic = self.basic_variables()
    non_basic = self.nonbasic_variables()
    max_entering = ""
    max_leaving = ""
    k = 0
    for i in basic:
        v_old[int(str(list(i)[0][1])[1:]) - 1] = (self.constant_terms())[k] #to dziala
        k += 1
    licz=0
    for i in non_basic:
        c[int(str(list(i)[0][1])[1:]) - 1] = c_old[licz]
        licz += 1
    c = vector(c)
    max = ""
    for x in self.possible_entering():
        temp = copy.deepcopy(self)
        temp.enter(x)
        for y in temp.possible_leaving():
            v_new = list(v_old)
            v_new[int(str(x)[1:]) - 1] = (temp.constant_terms())[list(temp.basic_variables()).index(y)]
            v_new[int(str(y)[1:]) - 1] = 0
            v = vector(v_new) - vector(v_old)
            calc = numpy.dot(c, v)
            if numpy.linalg.norm(v) != 0:
                calc = calc/numpy.linalg.norm(v)
                max = calc
                max_entering = x
                max_leaving = y
                keeplooping = false
                break
            temp = copy.deepcopy(self)
            temp.enter(x)
        if (keeplooping == false):
            break
    if max == "":
        x = self.possible_entering()[0]
        temp = copy.deepcopy(self)
        temp.enter(x)
        y = temp.possible_leaving()[0]
        return [x, y]
    for x in self.possible_entering():
        temp = copy.deepcopy(self)
        temp.enter(x)
        for y in temp.possible_leaving():
            v_new = list(v_old)
            v_new[int(str(x)[1:]) - 1] = (temp.constant_terms())[list(temp.basic_variables()).index(y)]
            v_new[int(str(y)[1:]) - 1] = 0
            v = vector(v_new) - vector(v_old)
            calc = numpy.dot(c, v)
            if numpy.linalg.norm(v) != 0:
                calc = calc/numpy.linalg.norm(v)
            else:
                calc = max - 1
            temp = copy.deepcopy(self)
            temp.enter(x)
            if calc >= max:
                max = calc
                max_entering = x
                max_leaving = y
    return [max_entering, max_leaving]

# Pierwszy po lewej

def farthest_left_entering(self):
    return self.possible_entering()[0]

def farthest_left_leaving(self):
    return self.possible_leaving()[0]

# Pierwszy po prawej

def farthest_right_entering(self):
    return self.possible_entering()[len(self.possible_entering()) - 1]

def farthest_right_leaving(self):
    return self.possible_leaving()[len(self.possible_leaving()) - 1]

#
# Wybor funkcji pivot
#

def my_entering(self):
    #return lexicographical_min_entering(self)
    #return lexicographical_max_entering(self)
    #return largest_increase(self)[0]
    #return smallest_increase(self)[0]
    #return max_coefficient_entering(self)
    #return uni_random_entering(self)
    #return weighted_random_entering(self)
    return steepest_edge(self)[0]
    #return farthest_left_entering(self)
    #return farthest_right_entering(self)

def my_leaving(self):
    #return lexicographical_min_leaving(self)
    #return lexicographical_max_leaving(self)
    #return largest_increase(self)[1]
    #return smallest_increase(self)[1]
    #return lexicographical_min_leaving(self)
    #return uni_random_leaving(self)
    #return weighted_random_leaving(self)
    return steepest_edge(self)[1]
    #return farthest_left_leaving(self)
    #return farthest_right_leaving(self)

#
# Definicja problemu
#

LP = \
"""
Maximize 
+x1,1+x1,2+x1,3+x1,4+x1,5+x1,6+x2,1+x2,2+x2,3+x2,4+x2,5+x2,6+x3,1+x3,2+x3,3+x3,4+x3,5+x3,6+x4,1+x4,2+x4,3+x4,4+x4,5+x4,6+x5,1+x5,2+x5,3+x5,4+x5,5+x5,6+x6,1+x6,2+x6,3+x6,4+x6,5+x6,6
Subject to 
+x1,1+x1,2+x1,3+x1,4+x1,5+x1,6 <=1 
+x1,1+x2,1+x3,1+x4,1+x5,1+x6,1 <=1
+x2,1+x2,2+x2,3+x2,4+x2,5+x2,6 <=1 
+x1,2+x2,2+x3,2+x4,2+x5,2+x6,2 <=1
+x3,1+x3,2+x3,3+x3,4+x3,5+x3,6 <=1 
+x1,3+x2,3+x3,3+x4,3+x5,3+x6,3 <=1
+x4,1+x4,2+x4,3+x4,4+x4,5+x4,6 <=1 
+x1,4+x2,4+x3,4+x4,4+x5,4+x6,4 <=1
+x5,1+x5,2+x5,3+x5,4+x5,5+x5,6 <=1 
+x1,5+x2,5+x3,5+x4,5+x5,5+x6,5 <=1
+x6,1+x6,2+x6,3+x6,4+x6,5+x6,6 <=1 
+x1,6+x2,6+x3,6+x4,6+x5,6+x6,6 <=1
+x5,1+x6,2 <= 1 
+x1,2+x2,1 <= 1
+x4,1+x5,2+x6,3 <= 1 
+x1,3+x2,2+x3,1 <= 1
+x3,1+x4,2+x5,3+x6,4 <= 1 
+x1,4+x2,3+x3,2+x4,1 <= 1
+x2,1+x3,2+x4,3+x5,4+x6,5 <= 1 
+x1,5+x2,4+x3,3+x4,2+x5,1 <= 1
+x1,1+x2,2+x3,3+x4,4+x5,5+x6,6 <= 1 
+x1,6+x2,5+x3,4+x4,3+x5,2+x6,1 <= 1
+x1,2+x2,3+x3,4+x4,5+x5,6 <= 1 
+x2,6+x3,5+x4,4+x5,3+x6,2 <= 1
+x1,3+x2,4+x3,5+x4,6 <= 1 
+x3,6+x4,5+x5,4+x6,3 <= 1
+x1,4+x2,5+x3,6 <= 1 
+x4,6+x5,5+x6,4 <= 1
+x1,5+x2,6 <= 1 
+x5,6+x6,5 <= 1
Generals 
x1,1
x1,2
x1,3
x1,4
x1,5
x1,6
x2,1
x2,2
x2,3
x2,4
x2,5
x2,6
x3,1
x3,2
x3,3
x3,4
x3,5
x3,6
x4,1
x4,2
x4,3
x4,4
x4,5
x4,6
x5,1
x5,2
x5,3
x5,4
x5,5
x5,6
x6,1
x6,2
x6,3
x6,4
x6,5
x6,6
end
"""

#with open('problem.lp', 'r') as lpfile:
#    LP=lpfile.read()

##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################

from sage.misc.html import HtmlFragment
import types

def my_run_simplex_method(self):
    output = []
    while not self.is_optimal():
        self.pivots += 1
        if self.entering() is None:
            self.enter(self.pivot_select_entering())
        if self.leaving() is None:
            if self.possible_leaving():
                self.leave(self.pivot_select_leaving())

        output.append(self._html_())
        if self.leaving() is None:
            output.append("The problem is unbounded in $()$ direction.".format(latex(self.entering())))
            break
        output.append(self._preupdate_output("primal"))
        self.update()
    if self.is_optimal():
        output.append(self._html_())
    return HtmlFragment("\n".join(output))

#
# Parsowanie danych
#

class Matrix:
    """ output matrix class """
    
    class Objective:
        def __init__(self, expression, sense, name):
            if name:
                self.name = name[int(0)]
            else:
                self.name = ""
            self.sense = sense # 1 is minimise, -1 is maximise
            self.expression = expression # a dict with variable names as keys, and coefficients as values

    class Constraint:
        def __init__(self, expression, sense, rhs, name):
            if name:
                self.name = name[int(0)]
            else:
                self.name = ""
            self.sense = sense # 1 is geq, 0 is eq, -1 is leq
            self.rhs = rhs
            self.expression = expression
    
    class Variable:
        def __init__(self, bounds, category, name):
            self.name = name
            self.bounds = (bounds["lb"], bounds["ub"]) # a tuple (lb, ub)
            self.category = category # 1 for int, 0 for linear

    def __init__(self, parserObjective, parserConstraints, parserBounds, parserGenerals, parserBinaries):

        self.objective = Matrix.Objective(varExprToDict(parserObjective.varExpr), objSenses[parserObjective.objSense], parserObjective.name)
        
        self.constraints = [Matrix.Constraint(varExprToDict(c.varExpr), constraintSenses[c.sense], c.rhs, c.name) for c in parserConstraints]
        
        boundDict = getBoundDict(parserBounds, parserBinaries) # can't get parser to generate this dict because one var can have several bound statements
        
        allVarNames = set()
        allVarNames.update(self.objective.expression.keys())
        for c in self.constraints:
            allVarNames.update(c.expression.keys())
        allVarNames.update(parserGenerals)
        allVarNames.update(boundDict.keys())
        
        self.variables = [Matrix.Variable(boundDict[vName], ((vName in list(parserGenerals)) or (vName in list(parserBinaries))), vName) for vName in allVarNames]

    def __repr__(self):
        return "Objective%s\n\nConstraints (%d)%s\n\nVariables (%d)%s" \
        %("\n%s %s %s"%(self.objective.sense, self.objective.name, str(self.objective.expression)), \
          len(self.constraints), \
          "".join(["\n(%s, %s, %s, %s)"%(c.name, str(c.expression), c.sense, c.rhs) for c in self.constraints]), \
          len(self.variables), \
          "".join(["\n(%s, %s, %s)"%(v.name, str(v.bounds), v.category) for v in self.variables]))

    def getInteractiveLPProblem(self):
        A = [[0 for x in range(len(self.variables))] for y in range(len(self.constraints))]
        b = [0] * len(self.constraints)
        c = [0] * len(self.variables)

        for i, constraint in enumerate(self.constraints):
            for v, a in constraint.expression.iteritems():
                if constraint.sense == 1:
                    A[i][map(lambda x: x.name, self.variables).index(v)] = -a
                else:
                    A[i][map(lambda x: x.name, self.variables).index(v)] = a

                if constraint.sense == 1:		
                    b[i] = -constraint.rhs
                else:
                    b[i] = constraint.rhs 

        for v, a in self.objective.expression.iteritems():
            if self.objective.sense == 1:
                c[map(lambda x: x.name, self.variables).index(v)] = -a
            else:
                c[map(lambda x: x.name, self.variables).index(v)] = a

        AA = ()
        bb = ()
        cc = ()

        for a in A:
            aaa=[]
            for aa in a:
                aaa.append(aa*int(10000))        
            AA = AA + (list(aaa),)
        for b in b:
            bb = bb + (b*int(10000),)
        for c in c:
            cc = cc + (c*int(10000),)

        lpp = InteractiveLPProblemStandardForm(AA,bb,cc)

        for i, v in enumerate(self.variables):
            if v.bounds[int(1)] < infinity:
                coef = [0,] * len(self.variables)
                coef[i] = 1
                lpp = lpp.add_constraint((coef), v.bounds[int(1)]*int(10000))
            if v.bounds[int(0)] > -infinity:
                coef = [0,] * len(self.variables)
                coef[i] = -1
                lpp = lpp.add_constraint((coef), -v.bounds[int(0)]*int(10000))

        return lpp

def varExprToDict(varExpr):
    return dict((v.name[int(0)], v.coef) for v in varExpr)

def getBoundDict(parserBounds, parserBinaries):
    boundDict = defaultdict(lambda: {"lb": -infinity, "ub": infinity}) # need this versatility because the lb and ub can come in separate bound statements

    for b in parserBounds:
        bName = b.name[int(0)]
        
        # if b.free, default is fine

        if b.leftbound:
            if constraintSenses[b.leftbound.sense] >= 0: # NUM >= var
                boundDict[bName]["ub"] = b.leftbound.numberOrInf

            if constraintSenses[b.leftbound.sense] <= 0: # NUM <= var
                boundDict[bName]["lb"] = b.leftbound.numberOrInf
        
        if b.rightbound:
            if constraintSenses[b.rightbound.sense] >= 0: # var >= NUM
                boundDict[bName]["lb"] = b.rightbound.numberOrInf

            if constraintSenses[b.rightbound.sense] <= 0: # var <= NUM
                boundDict[bName]["ub"] = b.rightbound.numberOrInf
    
    for bName in parserBinaries:
        boundDict[bName]["lb"] = 0
        boundDict[bName]["ub"] = 1

    return boundDict
    

def multiRemove(baseString, removables):
    """ replaces an iterable of strings in removables 
        if removables is a string, each character is removed """
    for r in removables:
        try:
            baseString = baseString.replace(r, "")
        except TypeError:
            raise TypeError, "Removables contains a non-string element"
    return baseString

from pyparsing import *
from sys import argv, exit
from collections import defaultdict

MINIMIZE = 1
MAXIMIZE = -1

objSenses = {"max": MAXIMIZE, "maximum": MAXIMIZE, "maximize": MAXIMIZE, \
             "min": MINIMIZE, "minimum": MINIMIZE, "minimize": MINIMIZE}

GEQ = 1
EQ = 0
LEQ = -1

constraintSenses = {"<": LEQ, "<=": LEQ, "=<": LEQ, \
                    "=": EQ, \
                    ">": GEQ, ">=": GEQ, "=>": GEQ}

infinity = 1E30

def read(fullDataString):
    #name char ranges for objective, constraint or variable
    allNameChars = alphanums + "!\"#$%&()/,.;?@_'`{}|~"
    firstChar = multiRemove(allNameChars, nums + "eE.") #<- can probably use CharsNotIn instead
    name = Word(firstChar, allNameChars, max=255)
    keywords = ["inf", "infinity", "max", "maximum", "maximize", "min", "minimum", "minimize", "s.t.", "st", "bound", "bounds", "bin", "binaries", "binary", "gen",  "general", "end"]
    pyKeyword = MatchFirst(map(CaselessKeyword, keywords))
    validName = ~pyKeyword + name
    validName = validName.setResultsName("name")

    colon = Suppress(oneOf(": ::"))
    plusMinus = oneOf("+ -")
    inf = oneOf("inf infinity", caseless=True)
    number = Word(nums+".")
    sense = oneOf("< <= =< = > >= =>").setResultsName("sense")

    # section tags
    objTagMax = oneOf("max maximum maximize", caseless=True)
    objTagMin = oneOf("min minimum minimize", caseless=True)
    objTag = (objTagMax | objTagMin).setResultsName("objSense")

    constraintsTag = oneOf(["subj to", "subject to", "s.t.", "st"], caseless=True)

    boundsTag = oneOf("bound bounds", caseless=True)
    binTag = oneOf("bin binaries binary", caseless=True)
    genTag = oneOf("gen general", caseless=True)

    endTag = CaselessLiteral("end")

    # coefficient on a variable (includes sign)
    firstVarCoef = Optional(plusMinus, "+") + Optional(number, "1")
    firstVarCoef.setParseAction(lambda tokens: eval("".join(tokens))) #TODO: can't this just be eval(tokens[0] + tokens[1])?

    coef = plusMinus + Optional(number, "1")
    coef.setParseAction(lambda tokens: eval("".join(tokens))) #TODO: can't this just be eval(tokens[0] + tokens[1])?

    # variable (coefficient and name)
    firstVar = Group(firstVarCoef.setResultsName("coef") + validName)
    var = Group(coef.setResultsName("coef") + validName)

    # expression
    varExpr = firstVar + ZeroOrMore(var)
    varExpr = varExpr.setResultsName("varExpr")

    # objective
    objective = objTag + Optional(validName + colon) + varExpr
    objective = objective.setResultsName("objective")

    # constraint rhs
    rhs = Optional(plusMinus, "+") + number
    rhs = rhs.setResultsName("rhs")
    rhs.setParseAction(lambda tokens: eval("".join(tokens)))

    # constraints
    constraint = Group(Optional(validName + colon) + varExpr + sense + rhs)
    constraints = ZeroOrMore(constraint)
    constraints = constraints.setResultsName("constraints")

    # bounds
    signedInf = (plusMinus + inf).setParseAction(lambda tokens:(tokens[int(0)] == "+") * infinity)
    signedNumber = (Optional(plusMinus, "+") + number).setParseAction(lambda tokens: eval("".join(tokens)))  # this is different to previous, because "number" is mandatory not optional
    numberOrInf = (signedNumber | signedInf).setResultsName("numberOrInf")
    ineq = numberOrInf & sense
    sensestmt = Group(Optional(ineq).setResultsName("leftbound") + validName + Optional(ineq).setResultsName("rightbound"))
    freeVar = Group(validName + Literal("free"))

    boundstmt = freeVar | sensestmt 
    bounds = boundsTag + ZeroOrMore(boundstmt).setResultsName("bounds")

    # generals
    generals = genTag + ZeroOrMore(validName).setResultsName("generals") 

    # binaries
    binaries = binTag + ZeroOrMore(validName).setResultsName("binaries")

    varInfo = ZeroOrMore(bounds | generals | binaries)

    grammar = objective + constraintsTag + constraints + varInfo + endTag

    # commenting
    commentStyle = Literal("\\") + restOfLine
    grammar.ignore(commentStyle)

    # parse input string
    parseOutput = grammar.parseString(fullDataString)

    # create generic output Matrix object
    m = Matrix(parseOutput.objective, parseOutput.constraints, parseOutput.bounds, parseOutput.generals, parseOutput.binaries)

    return m

#
# Parsowanie danych
#

m = read(LP)
P = m.getInteractiveLPProblem()

#
# Ustawienie wlasnej funkcji pivot
#

D = P.initial_dictionary()

if not D.is_feasible():
    print "The initial dictionary is infeasible, solving auxiliary problem."
    # Phase I
    AD = P.auxiliary_problem().initial_dictionary()
    AD.enter(P.auxiliary_variable())
    AD.leave(min(zip(AD.constant_terms(), AD.basic_variables()))[int(1)])
    AD.run_simplex_method()
    if AD.objective_value() < 0:
        print "The original problem is infeasible."
        P._final_dictionary = AD
    else:
        print "Back to the original problem."
        D = P.feasible_dictionary(AD)


D.run_simplex_method = types.MethodType(my_run_simplex_method, D)
D.pivots = 0

D.pivot_select_entering = types.MethodType(my_entering, D)
D.pivot_select_leaving = types.MethodType(my_leaving, D)

#
# Algorytm sympleks
#

if D.is_feasible():
    D.run_simplex_method()

print "Number of pivot steps: ", D.pivots

print D.objective_value()
print P.optimal_solution()
