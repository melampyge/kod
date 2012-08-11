''' 
Determines general MB type statistically based on celebs whose bdays and mb
types are known.  Naive Bayes is used: For a new bday and its associated astro
signs, we calculate probabilities for all \alpha values for every MB type. We
calculate joint log bernoulli probabilities for each MB group, and add the log
probabilities. We do this for all four MB types, and at the end, return the two
types whose log prob was the highest.
'''
import sys
sys.path.append('..')
import calculate

# Note: also you need to symlink pocketbudda.dat into
# the current directory here

spiller = ['Aquarius','Aries','Cancer','Capricorn','Gemini','Leo','Libra','Pisces','Sagittarius','Scorpio','Taurus','Virgo']

chinese = ['Dog','Dragon','Horse','Monkey','Ox','Pig','Rabbit','Rat','Rooster','Sheep','Snake','Tiger']

millman = ['123','134','145','156','167','178','189','1910','202','213','224','235','246','257','268','279','2810','2911','303','314','325','336','347','358','369','3710','3811','3912','404','415','426','437','448','459','4610','4711','4812']

lewis = ['lewi' + str(x) for x in range(1,277)]

def index(sign):
    for i,x in enumerate(spiller): 
        if sign == x: return i
    for i,x in enumerate(chinese): 
        if sign == x: return len(spiller)+i
    for i,x in enumerate(millman): 
        if sign == x: return len(spiller)+len(chinese)+i
    for i,x in enumerate(lewis): 
        if sign == x: return len(spiller)+len(chinese)+len(millman)+i
    raise Exception("error")

# for each person (celebrity) we are creating a huge vector with cells
# representing each astro sign we have, millman, chinese, lewi, etc. If a sign
# is present, the cell for that sign has '1', otherwise '0'. This vector is a
# multivariate bernoulli random variable. Then, training can take place for each
# MB group, using vectors for all celebrities falling under that group.

train = {}
for mb in ['NF','NT','SJ','SP']:
    train[mb] = [0.0 for x in range(len(spiller)+len(chinese)+len(millman)+len(lewis))]

file = open("mb-celeb-astro.txt")

N = {}
for mb in ['NF','NT','SJ','SP']:
    N[mb] = 0.0
    
for line in file:
    tokens = line.replace("\n","").split("|")
    # prepare a vector to represent astrologic data
    signs = tokens[2].split(":")
    v = [0.0 for x in range(len(spiller)+len(chinese)+len(millman)+len(lewis))]
    for i, sign in enumerate(signs): 
        # millman? (both lewi and millman are integers,
        # we are trying to distinquish them by looking at their 
        # position
        if i != 0 and sign.isdigit(): 
            s = "lewi" + sign
            idx = index(s)
            v[idx] = 1.
        else: # others
            idx = index(sign)
            v[index(sign)] = 1.
    if tokens[0][1] == 'N' and tokens[0][2] == 'F':
        train['NF'] = [train['NF'][i]+v[i]  for i in range(len(train['NF']))]
        N['NF'] = N['NF']+1.
    elif tokens[0][1] == 'S' and tokens[0][3] == 'P':
        train['SP'] = [train['NF'][i]+v[i]  for i in range(len(train['SP']))]
        N['SP'] = N['SP']+1.
    elif tokens[0][1] == 'N' and tokens[0][2] == 'T':
        train['NT'] = [train['NT'][i]+v[i]  for i in range(len(train['NT']))]
        N['NT'] = N['NT']+1.
    elif tokens[0][1] == 'S' and tokens[0][3] == 'J':
        train['SJ'] = [train['SJ'][i]+v[i]  for i in range(len(train['SJ']))]
        N['SJ'] = N['SJ']+1.
        
print N

out = {}        
        
for mb in ['NF','NT','SJ','SP']:
    train[mb] = [elem / N[mb]  for elem in train[mb]]
    
res =  calculate.calculate('19730424')

test_vector = [0.0 for x in range(len(spiller)+len(chinese)+len(millman)+len(lewis))]
for lewi in res[0]:
    lewi = lewi.replace("\n","")
    test_vector[index("lewi"+lewi)] = 1.0
for idx in [res[1], res[2], res[3][0]]:        
    test_vector[index(idx)] = 1.0

sums = {}
for mb in ['NF','NT','SJ','SP']:
    sums[mb] = 0.
for mb in ['NF','NT','SJ','SP']:
    for i in range(len(test_vector)):
        sums[mb] += calculate.prob(test_vector[i], train[mb][i])
        
# sort dictionary in ascending order
results = sorted(sums.items(), key=lambda x: x[1])
print results[-1][0], results[-2][0]

