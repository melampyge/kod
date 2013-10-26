import pickle, math, logging, datetime

spiller = ['Aquarius','Aries','Cancer','Capricorn','Gemini','Leo','Libra','Pisces','Sagittarius','Scorpio','Taurus','Virgo']
chinese = ['Dog','Dragon','Horse','Monkey','Ox','Pig','Rabbit','Rat','Rooster','Sheep','Snake','Tiger']
millman = ['123','134','145','156','167','178','189','1910','202','213','224','235',
           '246','257','268','279','2810','2911','303','314','325','336','347','358',
           '369','3710','3811','3912','404','415','426','437','448','459','4610','4711',
           '4812', '0','1','2','3','4','5','6','7','8','9']
lewis = ['lewi' + str(x) for x in range(1,277)]

# translates a query for any sign into an index that allows access to our
# multivariate bernoulli vector, because all '1' and '0's corresponding to all
# signs are placed together under one huge vector . This had to be done to allow
# quick addition of '1' and '0's for one group during training.
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


''' Myers-Briggs test evaluation in Python. Input 'choices' is flattened list of
answers containing -1,0,1 corresponding to leftmost, center, rightmost
selections of radio boxes on the questionaire.
'''
def calculate_mb(choices):

    new_choices = []
    
    ''' The MB questionare is divided into a 10 x 7 table (actually 10 x 14, but
    we use values to represent selections between A,B). The evaluation is
    performed on this table by summing up columns in a certain way. The code
    below simply creates the necessary indexes so that we can read a flattened
    questinaire in a way we can use the 'sum' operation properly.
    '''
    for i in range(1,8):
        new_choices.append([int(choices[j-1]) for j in range(i,71,7) ])

    #print new_choices
        
    # apparently setting a single character in a string using
    # the [] operator is not possible, so we start with a list, then 
    # go back to string when we are finished.
    res = list("XXXX")

    ei = sum(new_choices[0])
    if ei < 0: res[0] = 'E'
    else: res[0] = 'I'
    
    sn = sum(new_choices[1]) + sum(new_choices[2])
    if sn < 0: res[1] = 'S'
    else: res[1] = 'N'
    
    tf = sum(new_choices[3]) + sum(new_choices[4])
    if tf < 0: res[2] = 'T'
    else: res[2] = 'F'

    jp = sum(new_choices[5]) + sum(new_choices[6])
    if jp < 0: res[3] = 'J'
    else: res[3] = 'P'
    
    return str(''.join(res))

def calculate_millman(date):
    millman = []
    sum1 = 0
    sum2 = 0
    for s in date: sum1+=int(s)
    for s in str(sum1): sum2+=int(s)
    millman.append(sum1)
    millman.append(sum2)
    for s in str(sum1)+str(sum2):
      millman.append(int(s))      
    res = []
    res.append(str(millman[0])+str(millman[1]))
    for x in millman[2:]:
      if x not in res:
        res.append(x)
    return res

# Entry method for all the other calculations
def calculate(date):    
  ast = open("pocketbudda.dat")
  for line in ast.readlines():
    if date == line[0:8]:
        res = line[9:]
        tokens = res.split(":")
        spiller = tokens[0]
        chinese = tokens[1]
        lewis = tokens[2:]
        lewis[-1] = lewis[-1].replace("\n","")
        millman = calculate_millman(date) 
        break
  ast.close()
  return lewis, spiller, chinese, millman


def prob(xd, alphad):
    return math.log(alphad*xd + 1e-7) + \
        math.log((1.-alphad)*(1.-xd) + 1e-7)
    
def calculate_cycle(d):
    birth_date = datetime.datetime.strptime(d, '%Y%m%d').date()
    str_d = birth_date.strftime('%d %B %Y')
    now_year = datetime.datetime.now().year      
    cs = str(birth_date.day)+"/"+str(birth_date.month)+"/"+str(now_year)
    cycle_date = datetime.datetime.strptime(cs, '%d/%m/%Y').date()  
    str_cycle_date = cycle_date.strftime('%Y%m%d')
    millman = calculate_millman(str_cycle_date)
    res = str(millman[0])
    res = res[0:2]
    total = int(res[0]) + int(res[1])
    if total > 9: 
        res = str(total)
        total = int(res[0]) + int(res[1])
    return total, now_year, str_d
    
''' Determines specific MB type statistically based on celebs whose bdays and mb
types are known.  Naive Bayes is used.
'''
def calculate_mbti_full(astro):
    mbti = ''
    curr_letter_idx = 0    
    for ss in [['I','E'], ['N','S'], ['T','F'], ['P','J']]:
        file = open("mb-celeb-astro.txt")
        zero_v = [0.0 for x in range(len(spiller)+len(chinese)+len(millman)+len(lewis))]
        train = {}
        train[ss[0]] = zero_v[:]
        train[ss[1]] = zero_v[:]
        N = {}
        N[ss[0]] = 0.
        N[ss[1]] = 0.
        for line in file:
            tokens = line.replace("\n","").split("|")
            curr_letter = tokens[0][curr_letter_idx]
            if curr_letter == 'x': continue
            signs = tokens[2].split(":")
            v = zero_v[:]
            for i, sign in enumerate(signs): 
                if i != 0 and sign.isdigit(): 
                    s = "lewi" + sign
                    idx = index(s)
                    v[idx] = 1.
                else: # others
                    idx = index(sign)
                    v[index(sign)] = 1.
            
            # we could not simply "add" train[curr_letter] and v vectors
            # bcz we dont have numpy, we have lists. we have to fake it.
            train[curr_letter] = [train[curr_letter][i]+v[i] for i in range(len(train[curr_letter])) ]
            N[curr_letter] = N[curr_letter] + 1
            
        #print ss[0], N[ss[0]], ss[1], N[ss[1]]
        train[ss[0]] = [elem / N[ss[0]] for elem in train[ss[0]]]
        train[ss[1]] = [elem / N[ss[1]] for elem in train[ss[1]]] 
                
        test_vector = [0.0 for x in range(len(spiller)+len(chinese)+len(millman)+len(lewis))]
        for lewi in astro[0]:
            lewi = lewi.replace("\n","")
            test_vector[index("lewi"+lewi)] = 1.0
        for idx in [astro[1], astro[2], astro[3][0]]:        
            test_vector[index(idx)] = 1.0

        sums = {}
        sums[ss[0]] = 0.
        sums[ss[1]] = 0.
        for i in range(len(test_vector)):
            sums[ss[0]] += prob(test_vector[i], train[ss[0]][i])
            sums[ss[1]] += prob(test_vector[i], train[ss[1]][i])

        file.close()    
        #print sums[ss[0]], sums[ss[1]]
        if sums[ss[0]] > sums[ss[1]]:
            mbti += ss[0]
        else:
            mbti += ss[1]
        curr_letter_idx += 1

    return mbti

if __name__ == "__main__": 
    print calculate_millman("18890420")
