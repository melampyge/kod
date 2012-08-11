from kalman_1d import Kalman

class Lines:

    def __init__(self):
        self.ends = {}
        self.beg = {}
        
    def process(self, was_x, was_y, is_x, is_y):
                
        for i in xrange(len(was_x)):
            was_x[i] = round(was_x[i], 2)
            was_y[i] = round(was_y[i], 2)
            is_x[i] = round(is_x[i], 2)
            is_y[i] = round(is_y[i], 2)            
            iskey = str(is_x[i]) + ":" + str(is_y[i])
            waskey = str(was_x[i]) + ":" + str(was_y[i]) 
            
            # if the "was" point does not appear in existing 
            # "ends" dictionary, that means this is the beginning
            # of a new line, not continuation of a previous one. 
            # create a new "beg" dictionary item, also add it to ends. 
            if ((waskey in self.ends) == False):
                self.beg[waskey] = [Kalman([was_y[i], 0]), was_x[i], was_y[i]]
                self.ends[iskey] = [was_x[i], was_y[i]] # map the end of line to beginning
                print "new"

            # if point appears in existing ends, we need to append data to this
            # line, get its Kalman Filter, update, and change the curr ends.
            if (waskey in self.ends):                
                linekey = self.ends[waskey]
                begofexistingendkey = str(linekey[0]) + ":" + str(linekey[1])
                line = self.beg[begofexistingendkey]
                kf = line[0] # get kalman filter, it's the zeroth item in the list
                kf.process(is_y[i], (is_x[i] - was_x[i]))
                #self.beg[iskey] = [kf, line[1], line[2]] # causes kf explosion
                del self.ends[waskey] # previous 'ends' points are not correct anymore
                self.ends[iskey] = [line[1], line[2]]

if __name__ == "__main__":		

    lines = Lines()
    # was at 10,10, then 20,20, then 30,30, then 40,40
    was_x_test = [10, 20, 30]
    was_y_test = [10, 20, 30] 
    is_x_test = [20, 30, 40] 
    is_y_test = [20, 30, 40]

    lines.process(was_x_test, was_y_test, is_x_test, is_y_test)
