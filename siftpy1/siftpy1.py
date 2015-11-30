import numpy.linalg as lin
import siftimp, os
import pandas as pd

def sift(fin, threshold=10.0):
    fout = "/tmp/" + fin.replace(".pgm",".key")
    if os.path.exists(fout): os.remove(fout)
    res = siftimp.sift_imp(fin, str(threshold))
    df = pd.read_csv(fout,sep=' ',header=None)
    return df

def match(desc1,desc2):
    desc1 = np.array([d/lin.norm(d) for d in desc1])
    desc2 = np.array([d/lin.norm(d) for d in desc2])
    
    dist_ratio = 0.6
    desc1_size = desc1.shape
    
    matchscores = np.zeros((desc1_size[0]),'int')
    desc2t = desc2.T # precompute matrix transpose
    for i in range(desc1_size[0]):
        dotprods = np.dot(desc1[i,:],desc2t) # vector of dot products
        dotprods = 0.9999*dotprods
        # inverse cosine and sort, return index for features in second image
        indx = np.argsort(np.arccos(dotprods))
        
        # check if nearest neighbor has angle less than dist_ratio times 2nd
        if np.arccos(dotprods)[indx[0]] < dist_ratio * np.arccos(dotprods)[indx[1]]:
            matchscores[i] = int(indx[0])    
    return matchscores
    

