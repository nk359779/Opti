B = [0,0,0,1,1]
D = ['+', '+', '-']
import random
n = 30
k = 50
temp = ""
print "Maximize"
for i in range(1, n+1):
    temp += random.choice(D) + " " + str(random.randint(0, 10000)) + " x" + str(i) + " "
    
print temp

print "Subject To"
for k in range(1, k+1):
    temp = ""
    for i in range(1, n+1):
        if (random.choice(B) == 1):
            temp += random.choice(D) + " " + str(random.randint(0, 10000)) + " x" + str(i) + " "
    print temp + " <= " + str(random.randint(0, 10000))
for i in range(1, n+1):
    print "x" + str(i) + " >= 0"  
    print "x" + str(i) + " <= 1"

print "Bounds"

print "Generals"
for i in range(1, n+1):
    print "x" + str(i)
print "End"