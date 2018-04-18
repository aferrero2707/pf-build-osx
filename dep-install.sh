#!/bin/bash

step=$1

#export PATH=$HOME/homebrew/bin:$PATH
export PATH=$HOME/homebrew/opt/python/libexec/bin:$HOME/homebrew/bin:$PATH
export LD_LIBRARY_PATH=$HOME/homebrew/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$HOME/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH

cachefile=homebrew-cache-pf-step$((step-1)).tar.gz
cacheurl=https://github.com/aferrero2707/pf-build-osx/releases/download/continuous/$cachefile

cd $HOME
if [ x"$step" != "x0" ]; then
  (curl -L $cacheurl > $cachefile && tar xzf $cachefile && rm -f $cachefile) || exit 1
fi


if [ x"$step" = "x0" ]; then
rm -rf homebrew && mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
cd $HOME/homebrew
brew update
#brew tap homebrew/science

sed -i ".bak" -e "s/-march=native/-march=nocona -mno-sse3 -mtune=generic/g" Library/Homebrew/extend/ENV/super.rb

echo ""
echo "=============================================="
echo "Patched optimization settings:"
cat  Library/Homebrew/extend/ENV/super.rb | grep "march"
echo "=============================================="
echo ""

brew install pkg-config automake
brew install --ignore-dependencies gtk-doc
brew install shared-mime-info

echo ""
echo "=============================================="
echo "Cairo dependencies: $(brew deps cairo)"
echo "=============================================="
echo ""
brew install $(brew deps cairo)
fi

cd $HOME/homebrew
if [ x"$step" = "x1" ]; then
#cairo_version=$(brew info cairo | head -n 1 | cut -d"," -f 1 | cut -d" " -f 3)
#(cd Cellar/cairo/${cairo_version} && patch -p 1 < ../../../cairo-phf.patch) || exit 1
brew install cairo
cat Library/Taps/homebrew/homebrew-core/Formula/cairo.rb
patch -p1 < $TRAVIS_BUILD_DIR/cairo-hb-displayprofile.patch
cat Library/Taps/homebrew/homebrew-core/Formula/cairo.rb
brew reinstall --build-from-source --ignore-dependencies cairo

brew install   gobject-introspection
#brew install   gobject-introspection
brew install   fftw --without-fortran
brew info   fftw
brew install  mozjpeg
brew info  mozjpeg
brew install  libexif
brew info  libexif
brew install   libpng
brew info   libpng
#brew install  webp
#brew info  webp
brew install  libtiff
brew info  libtiff
brew install   swig
brew info   swig
#brew install  imagemagick
#brew info  imagemagick
brew install   cfitsio
brew info   cfitsio
#brew install  libmatio
#brew info  libmatio
brew install   orc
brew info   orc
brew install  little-cms2
brew info  little-cms2
fi

if [ x"$step" = "x2" ]; then
brew install  --verbose llvm
brew info   llvm
brew install  --verbose --with-llvm rust
brew info   rust
brew install  poppler
brew info  poppler
brew install   pango
brew info   pango
brew install  libgsf
brew info  libgsf
brew install  openslide
brew info  openslide
brew install   librsvg
brew info   librsvg
brew install  giflib
brew info  giflib
brew install  openexr
brew info  openexr
#brew install   python
#brew info   python
#brew install  pygobject3
#brew info  pygobject3
#brew install   gexiv2
#brew info   gexiv2
brew install  gtk+
brew info  gtk+
#brew install  pygtk
#brew info  pygtk
fi

if [ x"$step" = "x3" ]; then
brew install  gtk-engines
brew info  gtk-engines 
brew install  gtkmm 
brew info  gtkmm
brew install  openssl 
brew info  openssl
brew install --verbose gtk+3
brew info gtk+3
brew install  gtk-mac-integration
brew info  gtk-mac-integration
brew install  pugixml
brew info  pugixml
fi

if [ x"$step" = "x4" ]; then
brew reinstall python && brew info python
brew install python3 && brew info python3
fi

if [ x"$step" = "x5" ]; then
brew uninstall --ignore-dependencies cairo

cd $HOME
rm -rf homebrew-temp && mkdir homebrew-temp && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew-temp
cd homebrew-temp
bin/brew update
ls Library/Taps/homebrew/homebrew-core/Formula/cairo.rb
cd ..
cp homebrew-temp/Library/Taps/homebrew/homebrew-core/Formula/cairo.rb homebrew/Library/Taps/homebrew/homebrew-core/Formula/cairo.rb
cd $HOME/homebrew

#brew install --ignore-dependencies cairo
patch -p1 < $TRAVIS_BUILD_DIR/cairo-hb-displayprofile.patch
cat Library/Taps/homebrew/homebrew-core/Formula/cairo.rb
brew reinstall --build-from-source --ignore-dependencies cairo
fi

if [ x"$step" = "x6" ]; then
brew reinstall  vips --with-openexr
brew info  vips
brew reinstall --verbose lensfun
brew info  lensfun
fi
