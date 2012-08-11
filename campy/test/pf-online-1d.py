from pylab import *
 
class Model():
	def __init__(self,Q,R, dim=1):
		self.Q = Q
		self.R = R
		self.dim = dim
		
	def pi_0(self):
		# prior on x
		return normal(0,sqrt(10))
	
        def f(self,x):
		# dynamic equation
		mean = x/2 + 25* (x/(1+x**2)) + 8 
		return mean + normal(0,sqrt(self.Q))		
	
	def g_sample(self,x):
		# observation equation sample generator
		mean = (x**2)/20
		return mean + normal(0,sqrt(self.R))	                
	
	def g(self,x,y):
		# observation equation for point probability
		mean = (x**2)/20
		return (1/(sqrt(self.R)*sqrt(2*pi))) * \
		    exp((-(y-mean)**2)/(2.0*self.R))
	
	def sample(self,T):
            x = empty(T)
	    y = empty(T)
	    x[0] = self.pi_0()
	    y[0] = self.g_sample(x[0])
	    for t in range(1,T):
		    x[t] = self.f(x[t-1])
		    y[t] = self.g_sample(x[t])	    
	    return x,y

class ParticleFilter():
	def __init__(self,N):
		self.N = N
		self.model = model
		self.q = model.f
	def resample(self, x, w): 
		N = len(w)
		Ninv = 1 / float(N)
		new_x = empty(N)
		c = cumsum(w)
		u = rand()*Ninv
		i = 0
		for j in range(N):
			uj = u + Ninv*j
			while uj > c[i]:
				i += 1
			new_x[j] = x[i]
		new_w = ones(self.N,dtype=float)/self.N
		return new_x, new_w		
		
	def filter(self, y): 
		x0 = model.pi_0()
		xhat = 0
		# initial particles
		x = [self.q(x0) for i in range(self.N)]
		w = ones(self.N,dtype=float)/self.N
		# apply transition equation to get prediction for 
		# next time step, and our G. the sample had to be from
		# G(x), and here it is.
		x = [self.q(xi) for xi in x]
		w = w*[self.model.g(xi,y) for xi in x] 
		w /= sum(w)
		x,w = self.resample(x, w)
		xhat = sum(x*w)
		return xhat
			
if __name__ == "__main__":		
	#print multivariate_normal([0,0], [[10,1],[1,10]])
	model = Model(Q=10,R=1)
	T = 100 # maximum time steps
	N = 40 # number of particles
	x,y = model.sample(T)
	b = ParticleFilter(N)	
	xhat = [b.filter(yy) for yy in y]
	plot(xhat,label='estimated state')
	plot(x,label='true state')
	legend()
	xlabel('t')
	show()
