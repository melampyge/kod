# to save a matlab matrix
# save('dosya','A')
import pandas as pd, sys
from scipy import io as spio
import numpy as np, os

base = '%s/Dropbox/Public/data' % os.environ['HOME']
a = spio.loadmat(base + '/inputData_USDCAD_20120426.mat')
cols = ['cl','lo','hi','hhmm','op']
df = pd.concat([pd.DataFrame(a[x]) for x in cols], axis=1)
df.columns = cols
print df

sys.path.append('/home/burak/Documents/classnotes/tser/tser_coint')
from johansen import coint_johansen
res = coint_johansen(df[['ewa','ewc']], 0, 1)

