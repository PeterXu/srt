
build_ios() {
    arch="$1"
    build=".build_$arch"
    (
    mkdir -p $build
    cd $build
    cmake ../ -DENABLE_DEBUG=1 -DENABLE_SHARED=no -DENABLE_APPS=no -DIOS_ARCH="$arch" -C ../scripts/iOS.cmake
    make
    cp libsrt.a ../libsrt_$arch.a
    cp version.h ../
    )
}

merge_ios() {
    libs=$(ls libsrt_*.a)
    lipo $libs -create -output libsrt.a
}

make_ios() {
    build_ios "armv7"
    build_ios "armv7s"
    build_ios "arm64"
    merge_ios
}

make_linux() {
    build=".build"
    (
    mkdir -p $build
    cd $build
    cmake ../ -DENABLE_DEBUG=1 -DENABLE_SHARED=no -DENABLE_APPS=no
    make
    cp libsrt.a ../
    cp version.h ../
    )
}

os="$1"
if [ "$os" = "ios" ]; then
    make_ios
elif [ "$os" = "linux" ]; then
    make_linux
else
    echo "usage: $0 ios|linux"
fi

