#!/bin/sh
VL_SIFT_DIR=/home/burak/devprogs/vlfeat-0.9.8/vl
gcc -Wall -g -O3 -DNDEBUG -Wno-variadic-macros -DVL_LOWE_STRICT -DVL_USEFASTMATH -shared -o vlsiftpy.so -I$VL_SIFT_DIR -I/usr/include/python2.5 -lpython2.5 vlsiftpy.c 
cp vlsiftpy.so ../../
