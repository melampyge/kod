import unittest
from dist6 import *

class Size: pass

class TestTrapezoid(unittest.TestCase):
    
    def test_fallsin(self):
        size = Size()
        size.height = 480
        res = is_point_in_region(size, [20,20], front_region)
        self.assertFalse (res)
                    
if __name__ == '__main__':
    unittest.main()

