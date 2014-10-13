make
#./segment 0.5 500 20 ../../programming_computer_vision_with_python/pcv_book/C-uniform03.ppm /tmp/out.pgm
#./segment 0.5 450 10000 $HOME/lena.ppm $HOME/lena-out.pgm
convert /home/burak/Documents/classnotes/app-math-tr/eigseg/simple.png /tmp/simple.ppm
./segment 0.5 450 1 /tmp/simple.ppm /tmp/simple-out.ppm
