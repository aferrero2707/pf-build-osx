#!/bin/bash

step=$1

#export PATH=$HOME/homebrew/bin:$PATH
export PATH=$HOME/homebrew/opt/python/libexec/bin:$HOME/homebrew/bin:$PATH
export LD_LIBRARY_PATH=$HOME/homebrew/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$HOME/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH

cachefile=homebrew-cache-pf-step$((step-1)).tar.gz
cacheurl=https://github.com/aferrero2707/pf-build-osx/releases/download/continuous/$cachefile

cd $HOME
if [ x"$step" != "x1" ]; then
  (curl -L $cacheurl > $cachefile && tar xzf $cachefile && rm -f $cachefile) || exit 1
fi


if [ x"$step" = "x1" ]; then
rm -rf homebrew && mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
cd $HOME/homebrew
brew update
brew tap homebrew/science

brew install -v pkg-config automake
brew install -v --ignore-dependencies gtk-doc
brew install -v shared-mime-info

brew install -v $(brew deps cairo)
#cairo_version=$(brew info cairo | head -n 1 | cut -d"," -f 1 | cut -d" " -f 3)
#(cd Cellar/cairo/${cairo_version} && patch -p 1 < ../../../cairo-phf.patch) || exit 1
patch -p1 < $TRAVIS_BUILD_DIR/cairo-hb-displayprofile.patch
cat Library/Taps/homebrew/homebrew-core/Formula/cairo.rb
brew reinstall --build-from-source --ignore-dependencies cairo

brew install -v   gobject-introspection
#brew install -v   gobject-introspection
brew install -v   fftw
brew info   fftw
brew install -v  mozjpeg
brew info  mozjpeg
brew install -v  libexif
brew info  libexif
brew install -v   libpng
brew info   libpng
#brew install -v  webp
#brew info  webp
brew install -v  libtiff
brew info  libtiff
brew install -v   swig
brew info   swig
#brew install -v  imagemagick
#brew info  imagemagick
brew install -v   cfitsio
brew info   cfitsio
#brew install -v  libmatio
#brew info  libmatio
brew install -v   orc
brew info   orc
brew install -v  little-cms2
brew info  little-cms2
fi

if [ x"$step" = "x2" ]; then
brew install -v  poppler
brew info  poppler
brew install -v   pango
brew info   pango
brew install -v  libgsf
brew info  libgsf
brew install -v  openslide
brew info  openslide
brew install -v   librsvg
brew info   librsvg
brew install -v  giflib
brew info  giflib
brew install -v  openexr
brew info  openexr
#brew install -v   python
#brew info   python
#brew install -v  pygobject3
#brew info  pygobject3
#brew install -v   gexiv2
#brew info   gexiv2
brew install -v  gtk+
brew info  gtk+
#brew install -v  pygtk
#brew info  pygtk
fi

if [ x"$step" = "x3" ]; then
brew install -v  gtk-engines
brew info  gtk-engines 
brew install -v  gtkmm 
brew info  gtkmm
brew install -v  openssl 
brew info  openssl
brew install -v --verbose gtk+3
brew info gtk+3
brew install -v  gtk-mac-integration
brew info  gtk-mac-integration
brew install -v  pugixml
brew info  pugixml
fi

if [ x"$step" = "x4" ]; then
brew reinstall -v python && brew info python
brew install -v python3 && brew info python3
brew install -v  vips
brew info  vips
fi

if [ x"$step" = "x5" ]; then
brew reinstall -v  vips
brew info  vips
brew reinstall -v  lensfun
brew info  lensfun
fi
