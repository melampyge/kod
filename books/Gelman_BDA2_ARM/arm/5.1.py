import numpy
from matplotlib import pyplot as plt
import scikits.statsmodels.api as sm
from scipy import stats
    
def converter(x):
    if x == 'NA':
        return numpy.nan
    else:
        return float(x) 

# read data
nes = numpy.loadtxt("nes.dat",  skiprows=1, 
                    usecols = (1,12,35), 
                    converters={12:converter, 35:converter}) # year, inc, pvote


nes = nes[nes[:,0] == 1992] # get only the data for 1992

# get only non Nan data
nes = nes[(nes[:,2] < 3)  | numpy.isnan(nes[:,2])] # get where presvote < 3 or not nan
nes[:,2] -= 1 # convert pres vals into 0 or 1 for republicans 
                        # like gelman now

nes = nes[numpy.isnan(nes[:,2]) == False] 
nes = nes[numpy.isnan(nes[:,1]) == False] # drop nans

exog = nes[:,1]
endog = nes[:,2]

#endog, exog = sm.tools.drop_missing(endog, exog)

exog = sm.add_constant(exog)

print exog.shape
print endog.shape
print exog
print endog

logit_mod = sm.Logit(endog, exog)
logit_res = logit_mod.fit()
print logit_res.params
print logit_res.bse
print logit_res.prsquared
print logit_res.margeff()
print logit_res.conf_int()
print logit_res.df_resid


