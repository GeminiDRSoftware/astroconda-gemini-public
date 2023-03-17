
case "$(uname)" in
Linux)
LDFLAGS='-m64'
;;
Darwin)
LDFLAGS='-arch x86_64 -m64'

sed -i -e '/codesign/d' ds9/unix/Makefile.in
;;
*)
echo "Unsupported"
exit 1
;;
esac

# Patches are applied in meta.yaml so everything can be built against X11 libs
# from the conda env and the latest ds9 Makefile won't override TKFLAGS.

unix/configure --x-includes=${PREFIX}/include --x-libraries=${PREFIX}/lib TKFLAGS="--disable-xss"  # not all machines have libXss
make
mkdir -p $PREFIX/bin
cp -a bin/ds9* bin/x* $PREFIX/bin
