#!/bin/bash

cd $HOME
mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
export PATH=$HOME/homebrew/bin:$PATH
export LD_LIBRARY_PATH=$HOME/homebrew/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$HOME/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH

cd $HOME/homebrew
brew update
brew tap homebrew/science

brew install ccache pkg-config automake
brew install --ignore-dependencies gtk-doc
brew install   shared-mime-info

brew install cairo
#cairo_version=$(brew info cairo | head -n 1 | cut -d"," -f 1 | cut -d" " -f 3)
#(cd Cellar/cairo/${cairo_version} && patch -p 1 < ../../../cairo-phf.patch) || exit 1
patch -p1 < $TRAVIS_BUILD_DIR/cairo-hb-displayprofile.patch
cat Library/Taps/homebrew/homebrew-core/Formula/cairo.rb
brew reinstall --build-from-source cairo

#if [ "x" = "y" ]; then
brew install   gobject-introspection
#brew install   gobject-introspection
brew install   fftw
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
#fi
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
brew install  gtkmm 
brew info  gtkmm 
brew install  gtk-mac-integration
brew info  gtk-mac-integration
brew install  pugixml
brew info  pugixml
brew install  vips
brew info  vips
