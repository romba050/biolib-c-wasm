# biolib-c-wasm
This repository contains a Dockerfile and a build script to assist with the compilation of C and C++ to Wasm.

## Getting started with Docker
After copying  this repository, place `build.sh` in the folder of the project you wish to compile. See section "The build.sh script".

To install docker, see https://docs.docker.com/get-docker/.

From that same folder, you can fetch and run the docker image directly from Docker Hub by running the following command:
```
docker run -v $PWD/build.sh:/build.sh -v $PWD:/input -v $PWD/output:/output biolib/c-wasm
```

The command takes in 3 volume mappings:
- `/build.sh` the build script that will be used to compile your tool to wasm
- `/input` the directory of your C/C++ project that you wish to compile
- `/output` the directory where the compiled wasm binaries should be placed

## The build.sh script

The image ships with a default build script. For simple projects, this should be sufficient. Remember to change the binary file name "your_file_name" on line 3 of build.sh.
Build.sh uses Emscripten (https://emscripten.org/index.html) to compile C/C++ to wasm.

## Creating the Biolib App
The compiled wasm file that is created in ./output can now be uploaded to biolib when creating a new app.
See https://biolib.com/docs/first-app-video/ on how to create a biolib app.

When creating the Biolib app, make sure to select FileType -> WebAssembly and compiler -> C/C++.

## Common issues

### If your project doesn't have a Makefile
`build.sh` expects a Makefile in the directory to run. In case you do not have a `Makefile`, use the one provided in this repository. Again, replace "your_file_name" with the name of the script you want to compile.

### If your project does have a Makefile
In the Makefile, replace all instances of the C/C++ compiler (e.g. g++) with emcc (on Linux/MacOS, works for both C and C++, use em++ to force compilation as C++).

### If your project uses configure to build it's Makefile:
Add this code to your build.sh:
```
emmake make clean
emconfigure ./configure
emmake make
```

### If your wasm file complains about missing functions when executed:
This might be caused by library archives (.a files) that have not been linked. Search for .a files in your project:
```
find . -name "*.a"
```
Then link the archives you find by adjusting your build.sh like so:
```
library_arr="\
    path/to/archive/file1.a \
    path/to/archive/file2.a"

mv emboss/.libs/$BINNAME $BINNAME.bc

emcc \
    $BIOLIB_REQ_FLAGS \
    $APP_ADDITIONAL_FLAGS \
    -o $BINNAME.mjs $BINNAME.bc $library_arr
```

