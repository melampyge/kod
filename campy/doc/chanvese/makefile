CC=g++
CFLAGS=-c -Wall -O2
SOURCES=main.cpp segment.cpp array.cpp
OBJECTS=$(SOURCES:.cpp=.o)
LIBPNG=-lpng

all: $(SOURCES) segment

segment: $(OBJECTS)
	$(CC) $(OBJECTS) $(LIBPNG) -o $@

.cpp:
	$(CC) $(OBJECTS) $< -o $@

clean:
	rm -rf *.o segment out-*
