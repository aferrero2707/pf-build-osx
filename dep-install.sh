#!/bin/bash

./bin/brew tap homebrew/science
./bin/brew update
#if [ "x" = "y" ]; then
./bin/brew install ccache pkg-config automake
./bin/brew install --ignore-dependencies gtk-doc
./bin/brew reinstall   gobject-introspection
#./bin/brew reinstall   gobject-introspection
./bin/brew reinstall   fftw
./bin/brew info   fftw
./bin/brew reinstall  mozjpeg
./bin/brew info  mozjpeg
./bin/brew reinstall  libexif
./bin/brew info  libexif
./bin/brew reinstall   libpng
./bin/brew info   libpng
./bin/brew reinstall  webp
./bin/brew info  webp
./bin/brew reinstall  libtiff
./bin/brew info  libtiff
./bin/brew reinstall   swig
./bin/brew info   swig
#./bin/brew reinstall  imagemagick
#./bin/brew info  imagemagick
./bin/brew reinstall   cfitsio
./bin/brew info   cfitsio
./bin/brew reinstall  libmatio
./bin/brew info  libmatio
./bin/brew reinstall   orc
./bin/brew info   orc
./bin/brew reinstall  little-cms2
./bin/brew info  little-cms2
#fi

#./bin/brew reinstall cairo
#cairo_version=$(./bin/brew info cairo | head -n 1 | cut -d"," -f 1 | cut -d" " -f 3)
#(cd Cellar/cairo/${cairo_version} && patch -p 1 < ../../../cairo-phf.patch) || exit 1
patch -p1 < $TRAVIS_BUILD_DIR/osx/cairo-hb-displayprofile.patch
cat Library/Taps/homebrew/homebrew-core/Formula/cairo.rb
./bin/brew reinstall --build-from-source cairo

./bin/brew reinstall  poppler
./bin/brew info  poppler
./bin/brew reinstall   pango
./bin/brew info   pango
./bin/brew reinstall  libgsf
./bin/brew info  libgsf
./bin/brew reinstall  openslide
./bin/brew info  openslide
./bin/brew reinstall   librsvg
./bin/brew info   librsvg
./bin/brew reinstall  giflib
./bin/brew info  giflib
./bin/brew reinstall  openexr
./bin/brew info  openexr
#./bin/brew reinstall   python
#./bin/brew info   python
#./bin/brew reinstall  pygobject3
#./bin/brew info  pygobject3
#./bin/brew reinstall   gexiv2
#./bin/brew info   gexiv2
./bin/brew reinstall  gtk+
./bin/brew info  gtk+
#./bin/brew reinstall  pygtk
#./bin/brew info  pygtk
./bin/brew reinstall  gtkmm 
./bin/brew info  gtkmm 
./bin/brew reinstall  gtk-mac-integration
./bin/brew info  gtk-mac-integration
./bin/brew reinstall  pugixml
./bin/brew info  pugixml
./bin/brew reinstall  vips
./bin/brew info  vips
