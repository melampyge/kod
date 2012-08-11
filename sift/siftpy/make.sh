#!/bin/sh
SIFT_DIR=/home/burak/kod/sift/siftpp
g++ -fPIC -Wall -g -O3 -DNDEBUG -Wno-variadic-macros -DVL_LOWE_STRICT -DVL_USEFASTMATH -shared -o siftpy.so -I$SIFT_DIR -I/usr/include/python2.7 -lpython2.7 siftpy.c 
