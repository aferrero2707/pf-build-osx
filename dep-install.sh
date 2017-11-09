#!/bin/bash

brew tap homebrew/science
brew update
#if [ "x" = "y" ]; then
brew install ccache pkg-config automake
brew install --ignore-dependencies gtk-doc
brew reinstall   gobject-introspection
#brew reinstall   gobject-introspection
brew reinstall   fftw
brew info   fftw
brew reinstall  mozjpeg
brew info  mozjpeg
brew reinstall  libexif
brew info  libexif
brew reinstall   libpng
brew info   libpng
#brew reinstall  webp
#brew info  webp
brew reinstall  libtiff
brew info  libtiff
brew reinstall   swig
brew info   swig
#brew reinstall  imagemagick
#brew info  imagemagick
brew reinstall   cfitsio
brew info   cfitsio
#brew reinstall  libmatio
#brew info  libmatio
brew reinstall   orc
brew info   orc
brew reinstall  little-cms2
brew info  little-cms2
#fi

#brew reinstall cairo
#cairo_version=$(brew info cairo | head -n 1 | cut -d"," -f 1 | cut -d" " -f 3)
#(cd Cellar/cairo/${cairo_version} && patch -p 1 < ../../../cairo-phf.patch) || exit 1
patch -p1 < $TRAVIS_BUILD_DIR/osx/cairo-hb-displayprofile.patch
cat Library/Taps/homebrew/homebrew-core/Formula/cairo.rb
brew reinstall --build-from-source cairo

brew reinstall  poppler
brew info  poppler
brew reinstall   pango
brew info   pango
brew reinstall  libgsf
brew info  libgsf
brew reinstall  openslide
brew info  openslide
brew reinstall   librsvg
brew info   librsvg
brew reinstall  giflib
brew info  giflib
brew reinstall  openexr
brew info  openexr
#brew reinstall   python
#brew info   python
#brew reinstall  pygobject3
#brew info  pygobject3
#brew reinstall   gexiv2
#brew info   gexiv2
brew reinstall  gtk+
brew info  gtk+
#brew reinstall  pygtk
#brew info  pygtk
brew reinstall  gtkmm 
brew info  gtkmm 
brew reinstall  gtk-mac-integration
brew info  gtk-mac-integration
brew reinstall  pugixml
brew info  pugixml
brew reinstall  vips
brew info  vips
