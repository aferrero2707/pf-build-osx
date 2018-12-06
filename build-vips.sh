#! /bin/bash

wd=$(pwd)

export PATH="$HOME/homebrew/opt/mozjpeg/bin:$HOME/homebrew/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/homebrew/opt/mozjpeg/lib:$HOME/homebrew/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="$HOME/homebrew/opt/mozjpeg/lib/pkgconfig:$HOME/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"

#export CC=$HOME/homebrew/bin/gcc-6
#export CXX=$HOME/homebrew/bin/g++-6
#export CMAKE_CC_COMPILER=$CC
#export CMAKE_CXX_COMPILER=$CXX

cd $HOME
mkdir -p VIPS || exit 1
cd VIPS || exit 1
curl -L -O https://github.com/libvips/libvips/releases/download/v8.7.2/vips-8.7.2.tar.gz || exit 1
tar xzvf vips-8.7.2.tar.gz || exit 1
cd vips-8.7.2 || exit 1
FLAGS="-g -O2 -march=nocona -mno-sse3 -mtune=generic -ftree-vectorize" CFLAGS="${FLAGS}" CXXFLAGS="${FLAGS} -fpermissive" \
./configure --prefix="$HOME/homebrew" --disable-gtk-doc --disable-gtk-doc-html --disable-introspection \
  --enable-debug=no --without-python --without-magick --without-libwebp --enable-pyvips8=no \
  --with-jpeg-includes=$HOME/homebrew/opt/mozjpeg/include --with-jpeg-libraries=$HOME/homebrew/opt/mozjpeg/lib \
  --enable-shared=yes --enable-static=no
make -j 3 install

