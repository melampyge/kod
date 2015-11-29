import siftpy1
df1 = siftpy1.sift("crans_1_small.pgm",threshold=2)
print len(df1)
df1 = siftpy1.sift("crans_1_small.pgm",threshold=5)
print len(df1)
df1 = siftpy1.sift("crans_1_small.pgm",threshold=2)
print len(df1)

