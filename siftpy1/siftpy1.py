import siftimp, os
import pandas as pd

def sift(fin, threshold=10):
    fout = "/tmp/" + fin.replace(".pgm",".key")
    if os.path.exists(fout): os.remove(fout)
    res = siftimp.sift_imp(fin, str(threshold))
    df = pd.read_csv(fout,sep=' ',header=None)
    return df

    

