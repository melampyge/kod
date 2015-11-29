from distutils.core import setup, Extension
import os

setup(name='siftpy1',
      version='1.0',
      ext_modules = [Extension('siftpy1',
                               ['sift-driver.cpp'],
                               include_dirs=['.']) ]
)
