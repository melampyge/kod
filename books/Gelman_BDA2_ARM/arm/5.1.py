import pandas as pd
import numpy as np
import statsmodels.api as sm
import statsmodels.formula.api as smf
    
def converter(x):
    if x == 'NA': return np.nan
    else: return float(x) 

# read data
nes = np.loadtxt("nes.dat",  skiprows=1, 
                    usecols = (1,12,35), 
                    converters={12:converter, 35:converter}) # year, inc, pvote


nes = nes[nes[:,0] == 1992] # get only the data for 1992

# get only non Nan data
nes = nes[(nes[:,2] < 3)  | np.isnan(nes[:,2])] # get where presvote < 3 or not nan
nes[:,2] -= 1 # convert pres vals into 0 or 1 for republicans 
                        # like gelman now

nes = nes[np.isnan(nes[:,2]) == False] 
nes = nes[np.isnan(nes[:,1]) == False] # drop nans

df = pd.DataFrame(nes[:,1:], columns = [['income','vote']])

mdlm = smf.logit("vote ~ income", df)
mdlmf = mdlm.fit()
print(mdlmf.summary())
