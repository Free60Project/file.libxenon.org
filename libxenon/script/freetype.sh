VERSION=2.4.8

wget -c http://download.savannah.gnu.org/releases/freetype/freetype-$VERSION.tar.gz
tar xzf freetype-$VERSION.tar.gz
cd freetype-$VERSION

export CC=xenon-gcc
export CFLAGS="-mcpu=cell -mtune=cell -m32 -fno-pic -mpowerpc64 $DEVKITXENON/usr/lib/libxenon.a -L$DEVKITXENON/xenon/lib/32/ -T$DEVKITXENON/app.lds -u read -u _start -u exc_base -L$DEVKITXENON/usr/lib -I$DEVKITXENON/usr/include"
export LDFLAGS=""

mv builds/unix/config.sub builds/unix/config.sub.orig
sed /'ps2)/ i\
	ppu)\
		basic_machine=powerpc64-unknown\
		os=-none\
		;;\
	xenon)\
		basic_machine=powerpc64-unknown\
		os=-none\
		;;' builds/unix/config.sub.orig > builds/unix/config.sub


./configure --prefix=$DEVKITXENON/usr --host=xenon --disable-shared

make CROSS_COMPILE=xenon-

echo ""
echo "Compiling done..." 
echo Please enter the freetype-$VERSION directory and run:
echo '"sudo PATH=$PATH:$DEVKITXENON/bin make install"'
