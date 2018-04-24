wget http://zlib.net/zlib-1.2.5.tar.bz2
tar xjf zlib-1.2.5.tar.bz2
cd zlib-1.2.5

export CC=xenon-gcc
export CFLAGS="-mcpu=cell -mtune=cell -m32 -fno-pic -mpowerpc64 $DEVKITXENON/usr/lib/libxenon.a -L$DEVKITXENON/xenon/lib/32/ -T$DEVKITXENON/app.lds -u read -u _start -u exc_base -L$DEVKITXENON/usr/lib -I$DEVKITXENON/usr/include"
export LDFLAGS=""

export TARGET=`gcc -v 2>&1 | sed -n '2p' | awk '{print $2}'`
echo $TARGET

./configure --prefix=$DEVKITXENON/usr

sed '/cp $(SHAREDLIBV) $(DESTDIR)$(sharedlibdir)/d' Makefile > Makefile.xenon
cp Makefile.xenon Makefile
rm Makefile.xenon

make CROSS_COMPILE=xenon-

echo ""
echo "Compiling done..." 
echo "Please enter the zlib-1.2.5 directory and run 'sudo make install'"
