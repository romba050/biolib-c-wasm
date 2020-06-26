# build an executable named your_file_name from your_file_name.c
all: your_file_name.c
	emcc -g -O2 -Wall -o your_file_name your_file_name.c -lz -lm

# rule to remove old executables
clean:
	rm -f your_file_name
    