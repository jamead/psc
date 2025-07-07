# Name of the output binary
TARGET = caen_fast_genpacket_gui

# Source files
SRC = caen_fast_genpacket_gui.c

# Compiler and flags
CC = gcc
CFLAGS = `pkg-config --cflags gtk+-3.0`
LIBS = `pkg-config --libs gtk+-3.0`

# Default target
all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) -o $(TARGET) $(SRC) $(CFLAGS) $(LIBS)

# Clean build artifacts
clean:
	rm -f $(TARGET)

