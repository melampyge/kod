#!/bin/sh
gcc  -o fund -g `pkg-config opencv --cflags --libs glib-2.0` fundem.cpp
