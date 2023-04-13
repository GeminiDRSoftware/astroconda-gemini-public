rm -rf aclocal.m4 autom4te.cache
libtoolize -f -i
autoreconf -i

./configure --prefix=$PREFIX \
    --with-fftw-libdir=$PREFIX/lib \
    --with-fftw-incdir=$PREFIX/include \
    ${OPTIONS}

make -j ${CPU_COUNT} LDFLAGS=-liomp5
make install
