#!/bin/sh
g++ -fPIC -Wall -g -O3 -DNDEBUG -Wno-variadic-macros -DVL_LOWE_STRICT -DVL_USEFASTMATH -shared -o siftpy1.so -I. -I/usr/include/python2.7 -lpython2.7 siftpy.c 
