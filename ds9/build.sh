
case "$(uname)" in
  Linux)
    LDFLAGS='-m64'
    ;;

  Darwin)
    LDFLAGS='-arch x86_64 -m64'

    # Needed for conda-forge clang 20 to build some source bundled in v8.6:
    export CFLAGS="-std=gnu11 ${CFLAGS}"
    export CXXFLAGS="-std=gnu++11 ${CXXFLAGS}"

    sed -i -e '/codesign/d' ds9/unix/Makefile.in
    ;;

  *)
    echo "Unsupported"
    exit 1
    ;;
esac

# Patches are applied in meta.yaml so everything can be built against X11 libs
# from the conda env and the latest ds9 Makefile won't override TKFLAGS.

# Also dynamically patch several Makefiles that dubiously pass CFLAGS instead
# of CXXFLAGS to the C++ compiler (for historical reasons), causing failures
# when C++ therefore gets passed the C "-std" option above:
find . -name "Makefile.in" -exec sed -ie '/COMPILE_CXX[[:space:]]*=/s|\$(CFLAGS)|\$(CXXFLAGS)|g' {} \;

# Needed to find xorgproto (which replaces xproto) during the build:
PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${PREFIX}/share/pkgconfig

unix/configure --x-includes=${PREFIX}/include --x-libraries=${PREFIX}/lib TKFLAGS="--disable-xss"  # not all machines have libXss
make
mkdir -p $PREFIX/bin
cp -a bin/ds9* bin/x* $PREFIX/bin
