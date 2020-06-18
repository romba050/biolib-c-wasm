# biolib-c-wasm
This repository contains a Dockerfile and a build script to assist with compilation of C and C++ to Wasm.

## Getting Started
Download `build.sh` and place it in the folder of the project you wish to compile.

You can fetch and run the docker image directly from Docker Hub by running the following command:
```
docker run -v $PWD/build.sh:/build.sh -v $PWD:/input -v $PWD/output:/output biolib/c-wasm
```

The command takes in 3 volume mappings:
- `/build.sh` the build script that will be used to compile your tool to wasm
- `/input` the directory of your C/C++ project that you wish to compile
- `/output` the directory where the compiled wasm binaries should be placed

## The build.sh script

The images ships with a default build script. For simple projects, this should be sufficient. It looks like the following (see build.sh in the repository for the update-to-date version. 
Remember to change the binary file name "your_file_name" in line 3.

```
make clean
emmake make
export BINNAME=your_file_name
mv $BINNAME $BINNAME.bc
BIOLIB_REQ_FLAGS="\
    -s WASM=1 \
    -s WASM_MEM_MAX=512MB \
    -s TOTAL_MEMORY=512MB \
    -s -g2 \
    -s EMIT_EMSCRIPTEN_METADATA=1 \
    -s LEGALIZE_JS_FFI=1 \
    -s FORCE_FILESYSTEM=1 \
    -lidbfs.js \
    -lnodefs.js \
    -s EXIT_RUNTIME=1"
APP_ADDITIONAL_FLAGS="-s ERROR_ON_UNDEFINED_SYMBOLS=0"
emcc \
    $BIOLIB_REQ_FLAGS \
    $APP_ADDITIONAL_FLAGS \
    -o $BINNAME.mjs $BINNAME.bc
```

## If you don't have a make file
Emscripten (https://emscripten.org/index.html) can be used to compile C/C++ to wasm. It looks something like this (see makefile in the repository).
```
# build an executable named your_file_name from your_file_name.c
all: your_file_name.c 
    emcc -g -O2 -Wall -o your_file_name your_file_name.c -lz -lm

# rule to remove old executables
clean: 
    rm -f your_file_name

```