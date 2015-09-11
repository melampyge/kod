# to save a matlab matrix
# save('dosya','A')
from scipy import io as spio
a = spio.loadmat('dosya')['A']
