import siftimp
import pandas as pd

def sift(fin):
    res = siftimp.sift_imp(fin)
    fout = "/tmp/" + fin.replace(".pgm",".key")
    df = pd.read_csv(fout,sep=' ',header=None)
    return df

    

