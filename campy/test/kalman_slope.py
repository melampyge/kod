# Burak Bayramli, 2009

# Kalman filter for line fitting


from pylab import *
from numpy import *

#
# x_{t+1} = A x_t + Q
# y_t = Hx_t + R
#

def Kalman(obs,x,mu_init,nsteps):

    ndim = shape(mu_init)[0]

    Q = zeros((ndim, ndim))
    A = eye(ndim)
    H = array([[1, 0], [1, 0]])

    mu_hat = mu_init
    cov = ones((ndim, ndim))
    R = eye(ndim) * 10
    
    m = zeros((ndim,nsteps),dtype=float)
    ce = zeros((ndim,ndim,nsteps),dtype=float)
    
    for t in range(1,nsteps):
        # Make prediction
        # A is transformation matrix, equals to
        # | 1 delta_x |
        # | 0    1    |
        A = array([[1, x[t]-x[t-1]], [0, 1]])
        mu_hat_est = dot(A,mu_hat)
        cov_est = dot(A,dot(cov,transpose(A))) + Q

        # Update estimate
        error_mu = obs[:,t] - dot(H,mu_hat_est)
        error_cov = dot(H,dot(cov,transpose(H))) + R
        K = dot(dot(cov_est,transpose(H)),linalg.inv(error_cov))
        mu_hat = mu_hat_est + dot(K,error_mu)
        m[:,t] = mu_hat
        cov = dot((eye(ndim) - dot(K,H)),cov_est)
        ce[:,:,t] = cov
        print "mu_hat="+str(mu_hat)
    return mu_hat
        
if __name__ == "__main__":		

    slope = 2
    N = 20

    #
    # create sample data
    #
    obs = zeros((2, N))
    x = xrange(N)
    for i in xrange(N):
        obs[0, i] = obs[1, i]  = (slope*i)+random.normal(10)

    print "obs="+str(obs.shape)    
    print "obs="+str(obs)    

    mu_hat = Kalman(obs, x, mu_init=array([0, 0]),nsteps=N)

    plot(obs[0, :])
    plot([0,N], [10,N*mu_hat[1]], 'go-', label='line 1', linewidth=2)
    show()

