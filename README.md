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

The images ships with a default build script. For simple projects, this should be sufficient. Remember to change the binary file name "your_file_name" in line 3 of build.sh.
`build.sh` uses emscripten (https://emscripten.org/index.html) to compile C/C++ to wasm.

## If you don't have a Makefile
build.sh expects a Makefile in the directory to run. In case you do not have a Makefile, use the one provided in this repository. Again, replace "your_file_name" with the name of the script you want to compile.

The compiled wasm file that is created in ./output can be uploaded to biolib when creating a new app.
