#!/bin/bash

#rm -rf ~/gtk

#jhbuild bootstrap --ignore-system
jhbuild bootstrap
jhbuild build meta-gtk-osx-bootstrap
jhbuild build meta-gtk-osx-core
jhbuild build meta-gtk-osx-gtkmm
jhbuild build meta-gtk-osx-themes
jhbuild build photoflow
#./package-nip2.sh

