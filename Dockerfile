FROM phusion/baseimage:0.11
WORKDIR /usr/src/c-wasm

# install dependencies
RUN apt-get update -y && apt-get install -y --no-install-recommends \
  ca-certificates \
  clang \
  cmake \
  curl \
  git \
  libc6-dev \
  make \
  nodejs \
  python \
  xz-utils \
  build-essential \
  default-jre \
  autoconf \
  autogen \
  libtool \
  shtool \
  autopoint

# install wabt (converts wasm binary to text)
RUN git clone --recursive https://github.com/WebAssembly/wabt
RUN make -C wabt -j$(nproc)

# add C -> wasm compiler
RUN git clone https://github.com/emscripten-core/emsdk.git
RUN cd emsdk && ./emsdk install 1.39.8-upstream && ./emsdk activate 1.39.8-upstream

# pre-fill cache with common libs
COPY test/sample_c_file.c /sample_c_file.c
RUN /bin/bash -c " \
  source /usr/src/c-wasm/emsdk/emsdk_env.sh && \
  emcc \
    -s USE_ZLIB=1 \
    -s USE_PTHREADS \
    -s USE_BZIP2 \
    -o sample_c_file.mjs /sample_c_file.c"

# move over default build script
COPY build.sh /build.sh

# make copy of input volume and run the build script on this
# also moves .wasm, .mjs and .wat to the output volume
CMD ["/bin/bash", "-c", "\
  cp -R /input/. /input-copy && \
  cd /input-copy && \
  source /usr/src/c-wasm/emsdk/emsdk_env.sh && \
  /build.sh && \
  /bin/bash -c '/usr/src/c-wasm/wabt/bin/wasm2wat $1 > $1.wat' /bin/bash *.wasm && \
  shopt -s nullglob && \
  mv *.mjs *.wasm *.wat /output \
"]
