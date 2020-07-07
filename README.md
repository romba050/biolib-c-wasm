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

The image ships with a default build script. For simple projects, this should be sufficient. Remember to change the binary file name "your_file_name" in line 3 of build.sh.
Build.sh uses emscripten (https://emscripten.org/index.html) to compile C/C++ to wasm.

## If you don't have a Makefile
`build.sh` expects a Makefile in the directory to run. In case you do not have a `Makefile`, use the one provided in this repository. Again, replace "your_file_name" with the name of the script you want to compile.

## If you do have a Makefile
In the Makefile, replace all instances of the C/C++ compiler (e.g. g++) with emcc (on Linux/MacOS, works for both C and C++, use em++ to force compilation as C++).

## Creating the Biolib App
The compiled wasm file that is created in ./output can now be uploaded to biolib when creating a new app.
See https://github.com/romba050/biolib-c-wasm/tree/update_readme on how to create a biolib app.

When creating the Biolib app, make sure to select FileType -> WebAssembly and compiler -> C/C++.
