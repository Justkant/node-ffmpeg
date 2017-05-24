FROM node:7.10.0-alpine
MAINTAINER Quentin Jaccarino <quentin@tracktl.com>

ENV FDKAAC_VERSION=0.1.5 \
    VPX_VERSION=1.6.1 \
    FFMPEG_VERSION=3.2.4 \
    SRC=/usr/local \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

# RUN echo "${SRC}/lib" > /etc/ld.so.conf.d/libc.conf

RUN apk add --update \
  build-base \
  python \
  libass-dev \
  freetype-dev \
  libtheora-dev \
  libtool \
  libvorbis-dev \
  texinfo \
  yasm \
  yasm-dev \
  x264-dev \
  lame-dev \
  opus-dev \
  coreutils \
  autoconf \
  automake \
  openssl-dev \
  curl \
  tzdata && \
  DIR=$(mktemp -d) && cd ${DIR} && \
  curl -s https://codeload.github.com/webmproject/libvpx/tar.gz/v${VPX_VERSION} | \
  tar zxf - -C . && \
  cd libvpx-${VPX_VERSION} && \
  ./configure --prefix="${SRC}" --enable-vp8 --enable-vp9 --disable-examples --disable-docs --enable-pic --enable-runtime-cpu-detect && \
  njobs=$(nproc) && \
  make -j$njobs && \
  make install && \
  make clean && \
  rm -rf ${DIR} && \
  DIR=$(mktemp -d) && cd ${DIR} && \
  curl -s https://codeload.github.com/mstorsjo/fdk-aac/tar.gz/v${FDKAAC_VERSION} | \
  tar zxf - -C . && \
  cd fdk-aac-${FDKAAC_VERSION} && \
  autoreconf -fiv && \
  ./configure --prefix="${SRC}" --disable-shared --datadir="${DIR}" && \
  njobs=$(nproc) && \
  make -j$njobs && \
  make install && \
  make distclean && \
  rm -rf ${DIR} && \
  DIR=$(mktemp -d) && cd ${DIR} && \
  curl -s http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | \
  tar zxf - -C . && \
  cd ffmpeg-${FFMPEG_VERSION} && \
  ./configure --prefix="${SRC}" \
  --extra-cflags="-I${SRC}/include" \
  --extra-ldflags="-L${SRC}/lib" \
  --bindir="${SRC}/bin" \
  --disable-doc \
  --extra-libs=-ldl \
  --enable-version3 \
  --enable-libfdk_aac \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libx264 \
  --enable-postproc \
  --enable-nonfree \
  --enable-gpl \
  --disable-debug \
  --enable-small \
  --enable-openssl \
  --enable-runtime-cpudetect && \
  njobs=$(nproc) && \
  make -j$njobs && \
  make install && \
  make distclean && \
  hash -r && \
  cd tools && \
  make qt-faststart && \
  cp qt-faststart ${SRC}/bin && \
  rm -rf ${DIR} && \
  ffmpeg -buildconf && \
  apk del curl tar bzip2 x264 openssl nasm  coreutils autoconf automake libc-dev fortify-headers build-base && rm -rf /var/cache/apk/*