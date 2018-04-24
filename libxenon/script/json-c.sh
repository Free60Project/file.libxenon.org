wget http://oss.metaparadigm.com/json-c/json-c-0.9.tar.gz
tar xvf json-c-0.9.tar.gz
cd json-c-0.9

export CC=xenon-gcc
export CFLAGS="-mcpu=cell -mtune=cell -m32 -fno-pic -mpowerpc64 /usr/lib/libxenon.a -L/xenon/lib/32/ -T/app.lds -u read -u _start -u exc_base -L/usr/lib -I/usr/include"
export LDFLAGS=""

./configure --prefix=/usr --host=powerpc

make CROSS_COMPILE=xenon-

echo ""
echo "Compiling done..." 
echo "Please enter the json-c-0.9 directory and run 'sudo make install'"
