from pylab import *
import time

class Map: 
    def __init__(self, enabled = True):
        self.enable = enabled
        self.__max__ = 600
        self.robot_x = 50
        self.robot_y = 50        
        if (self.enable):
            ion()
            fig = plt.figure()
            self.ax = fig.add_subplot(111)
            # plot the point on max otherwise the plot does not show
            # in dims [max x max]
            self.ax.plot([self.__max__],[self.__max__]) 
            self.ax.plot([-200],[-200]) 
            hold(False)
            
            
    def plot_kalman_line(self, fr, to):        
        if (self.enable):
            self.ax.plot([fr[0],to[0]], [fr[1],to[1]], 'r-')
            self.ax.set_xlim(-200, self.__max__)
            self.ax.set_ylim(-200, self.__max__)
            hold(True)
            draw()
            
    def plot_manual_line(self, fr, to):
        if (self.enable):
            self.ax.set_xlim(-200, self.__max__)
            self.ax.set_ylim(-200, self.__max__)
            self.ax.plot([fr[0],to[0]], [fr[1],to[1]], 'g-')
            hold(True)
            draw()
            

    def plot_done(self):
        if (self.enable):
            hold(False)
            
if __name__ == "__main__":		
    m = Map()
    m.plot_kalman_line([100, 100], [400, 400])
    time.sleep(1)
    m.plot_manual_line([0, 0], [100, 100])
    time.sleep(1)
    m.plot_manual_line([0, 0], [200, 100])
    time.sleep(1)
