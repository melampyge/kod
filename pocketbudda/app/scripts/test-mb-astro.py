import pickle
import sys
sys.path.append('..')
import calculate

lewis, spiller, chinese, millman =  calculate.calculate('19730424')
#res =  calculate.calculate('19451005')
#res =  calculate.calculate('19820108')
#res =  calculate.calculate('19490222')
#res =  calculate.calculate('19730326') #larry page
#res =  calculate.calculate('19730821') #brin
#res =  calculate.calculate('19540226') 
#res =  calculate.calculate('19730423')
#res =  calculate.calculate('19480331') # al gore
#res =  calculate.calculate('19420108') # hawking
#res =  calculate.calculate('19610804') # obama

print lewis, spiller, chinese, millman 

