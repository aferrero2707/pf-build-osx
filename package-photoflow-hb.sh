#!/bin/bash

# transfer.sh
transfer() 
{ 
	if [ $# -eq 0 ]; then 
		echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; 		
		return 1; 
	fi
	tmpfile=$( mktemp -t transferXXX ); 
	if tty -s; then 
		basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); 
		curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; 
	else 
		curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; 
	fi; 
	cat $tmpfile; 
	rm -f $tmpfile; 
}

#long_version="$(date +%Y%m%d)"
#long_version="osx-$(date +%Y%m%d)-unstable"
TRAVIS_COMMIT_SHORT=$(echo "${TRAVIS_COMMIT}" | head -c 5)
long_version="git_${TRAVIS_BRANCH}_macos_$(date +%Y%m%d)_$(date +%H%M)_${TRAVIS_COMMIT_SHORT}"
#long_version="osx-$(date +%Y%m%d)_$(date +%H%M)-git-${TRAVIS_BRANCH}-${TRAVIS_COMMIT}"
#long_version="0.2.8"
version=${long_version}
year=`date +%Y`
copyright="copyright 2014-$year Andrea Ferrero"

#cp ../../Icon/photoflow.png Icon1024.png
#bash make_icon.sh

# photoflow.bundle writes here
bdir=$HOME/Scratch/PhotoFlow
rm -rf $bdir
mkdir -p $bdir
dst=$bdir/photoflow.app
dst_prefix=$dst/Contents/Resources

# jhbuild installs to here
src=$HOME/homebrew
#src=/usr/local

wd=$(pwd)

export PKG_CONFIG_PATH=$src/lib/pkgconfig:$PKG_CONFIG_PATH

function escape () {
        # escape slashes
	tmp=${1//\//\\\/}

	# escape colon
	tmp=${tmp//\:/\\:}

	# escape tilda
	tmp=${tmp//\~/\\~}

	# escape percent
	tmp=${tmp//\%/\\%}

	echo -n $tmp
}

function new () {
	echo > script.sed
}

function sub () {
        echo -n s/ >> script.sed
	escape "$1" >> script.sed
	echo -n / >> script.sed
	escape "$2" >> script.sed
	echo /g >> script.sed
}

function patch () {
	echo patching "$1"

	sed -f script.sed -i "" "$1"
}

cp Info.plist.in Info.plist
new
sub @LONG_VERSION@ "$long_version"
sub @VERSION@ "$version"
sub @COPYRIGHT@ "$copyright"
patch Info.plist

rm -rf $dst 
rm -rf $bdir/PhotoFlow_${version}.app

mkdir -p $bdir/tools && cd $bdir/tools
#curl -O http://ftp.gnome.org/pub/gnome/sources/gtk-mac-bundler/0.7/gtk-mac-bundler-0.7.4.tar.xz && \
#curl -O https://raw.githubusercontent.com/darktable-org/darktable/master/packaging/macosx/gtk-mac-bundler-0.7.4.patch && \
#tar -xf gtk-mac-bundler-0.7.4.tar.xz && \
#cd gtk-mac-bundler-0.7.4 && \
#/usr/bin/patch -p1 < ../gtk-mac-bundler-0.7.4.patch && \
#make install

cd $bdir/tools
rm -rf macdylibbundler
git clone https://github.com/aferrero2707/macdylibbundler.git
cd macdylibbundler
make

cd $wd

#JHBUILD_PREFIX=$src gtk-mac-bundler photoflow.bundle.hb

mkdir -p $dst_prefix/bin
cp -a $src/bin/photoflow $dst_prefix/bin
echo "Fixing dependencies of \"$dst_prefix/bin\""
$bdir/tools/macdylibbundler/dylibbundler -od -of -b -x $dst_prefix/bin/photoflow -d $dst_prefix/lib -p @executable_path/../lib > $bdir/dylibbundler.log
cp -a $src/share $src/etc $dst_prefix

gdk_pixbuf_src_moduledir=$($src/bin/pkg-config --variable=gdk_pixbuf_moduledir gdk-pixbuf-2.0)
gdk_pixbuf_dst_moduledir=$dst_prefix/lib/gdk-pixbuf-2.0/loaders
mkdir -p $gdk_pixbuf_dst_moduledir
echo "Copying \"$gdk_pixbuf_src_moduledir\"/* to \"$gdk_pixbuf_dst_moduledir\""
cp -L "$gdk_pixbuf_src_moduledir"/* "$gdk_pixbuf_dst_moduledir"

gdk_pixbuf_src_cache_file=$($src/bin/pkg-config --variable=gdk_pixbuf_cache_file gdk-pixbuf-2.0)
gdk_pixbuf_dst_cache_file=$dst_prefix/lib/gdk-pixbuf-2.0/loaders.cache
mkdir -p $(dirname "$gdk_pixbuf_dst_cache_file")
echo "Copying \"$gdk_pixbuf_src_cache_file\" to \"$gdk_pixbuf_dst_cache_file\""
cp -L "$gdk_pixbuf_src_cache_file" "$gdk_pixbuf_dst_cache_file"
sed -i -e "s|$gdk_pixbuf_src_moduledir|@executable_path/../lib/gdk-pixbuf-2.0/loaders|g" "$gdk_pixbuf_dst_cache_file"

for l in "$gdk_pixbuf_dst_moduledir"/*.so; do
  echo "Fixing dependencies of \"$l\""
  chmod u+w "$l"
  $bdir/tools/macdylibbundler/dylibbundler -of -b -x "$l" -d $dst_prefix/lib -p @loader_path/../lib > /dev/null
done

gtk_version=$($src/bin/pkg-config --variable=gtk_binary_version gtk+-2.0)
gtk_engines_src_pixmap="$src/lib/gtk-2.0/${gtk_version}/engines/libpixmap.so"
gtk_engines_dst_dir="$dst_prefix/lib/gtk-2.0/engines"
mkdir -p "$gtk_engines_dst_dir"
cp -L "$gtk_engines_src_pixmap" "$gtk_engines_dst_dir"
for l in "$gtk_engines_dst_dir"/*.so; do
  echo "Fixing dependencies of \"$l\""
  chmod u+w "$l"
  $bdir/tools/macdylibbundler/dylibbundler -of -b -x "$l" -d $dst_prefix/lib -p @loader_path/../lib > /dev/null
done

export PATH=$src/bin:$PATH
lensfun-update-data
echo "Contents of lensfun database:"
ls $HOME/.local/share/lensfun/updates/version_1
mkdir -p $dst_prefix/share/photoflow/lensfun/version_1
cp -a $HOME/.local/share/lensfun/updates/version_1/* $dst_prefix/share/photoflow/lensfun/version_1
echo "Contents of \"$dst_prefix/share/photoflow/lensfun/version_1\":"
ls $dst_prefix/share/photoflow/lensfun/version_1

echo "Contents of \"$dst_prefix/share/photoflow/lensfun\":"
ls $dst_prefix/share/photoflow/lensfun

echo "Contents of \"$dst_prefix/share/photoflow\":"
ls $dst_prefix/share/photoflow


#$src/bin/gdk-pixbuf-query-loaders > $dst_prefix/etc/gtk-2.0/gdk-pixbuf.loaders
#sed -i -e "s|$src/|././/|g'

mkdir -p $dst/Contents/MacOS
cp -a photoflow-launcher-hb.sh $dst/Contents/MacOS/photoflow
cp Info.plist $dst/Contents
cp MyIcon.icns $dst_prefix

echo "Entering \"$bdir\""
cd $bdir
ls
#echo "zip -r $HOME/photoflow-${version}.zip photoflow.app"
#zip -r $HOME/photoflow-${version}.zip photoflow.app

#ls -lh $HOME/photoflow-${version}.zip
#echo "transfer $HOME/photoflow-${version}.zip"
#transfer $HOME/photoflow-${version}.zip

#exit

#cp $src/lib/pango/1.8.0/modules.cache $dst_prefix/lib/pango/1.8.0
#new
#sub "$src/lib/pango/1.8.0/modules/" ""
#patch $dst_prefix/lib/pango/1.8.0/modules.cache

#rm $dst_prefix/etc/fonts/conf.d/*.conf
#( cd $dst_prefix/etc/fonts/conf.d ; \
#	ln -s ../../../share/fontconfig/conf.avail/*.conf . )

# we can't copy the IM share with photoflow.bundle because it drops the directory
# name, annoyingly
#cp -r $src/share/ImageMagick-* $dst_prefix/share

#cp ~/PhotoFlow/vips/transform-7.30/resample.plg $dst_prefix/lib

#mv $dst ~/Desktop/PhotoFlow/PhotoFlow_${version}.app

#echo built ~/Desktop/PhotoFlow/photoflow.app

cd $bdir
rm -rf tools *.log
ln -s /Applications .
#touch .Trash

echo "Building .dmg"
rm -f $HOME/PhotoFlow_${version}.dmg
size_MB=$(du -ms photoflow.app | cut -f 1)
size_MB=$((size_MB+150))
echo "hdiutil create -megabytes ${size_MB} -srcfolder $bdir -o $HOME/PhotoFlow_${version}.dmg"
hdiutil create -megabytes ${size_MB} -verbose -srcfolder $bdir -o $HOME/PhotoFlow_${version}.dmg
echo built $HOME/PhotoFlow_${version}.dmg
ls -lh $HOME/PhotoFlow_${version}.dmg
