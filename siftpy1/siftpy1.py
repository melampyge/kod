import siftimp
import pandas as pd

def sift(fin, threshold=10):
    res = siftimp.sift_imp(fin, str(threshold))
    fout = "/tmp/" + fin.replace(".pgm",".key")
    df = pd.read_csv(fout,sep=' ',header=None)
    return df

    

