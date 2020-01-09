#!/bin/sh
#
# This scripts uses CMake to build libArcus with shared libraries targeting
# Linux x64. It also creates a debian package with cpack. The contents of the
# package are installed under "/usr".
#

# Include binaries in the cura development environment
CURA_DEV_ENV_ROOT=/opt/cura-dev
export PATH="${CURA_DEV_ENV_ROOT}/bin:${PATH}"
export PKG_CONFIG_PATH="${CURA_DEV_ENV_ROOT}/lib/pkgconfig:${PKG_CONFIG_PATH}"

mkdir build
cd build
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH="${CURA_DEV_ENV_ROOT}" \
    -DCMAKE_INSTALL_PREFIX="${CURA_DEV_ENV_ROOT}" \
    -DBUILD_PYTHON=ON \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_STATIC=OFF \
    ..
make
ctest --output-on-failure -T Test
cpack \
    --config ../cmake/cpack_config_deb_amd64.cmake \
    -D CPACK_INSTALL_CMAKE_PROJECTS="$(pwd);libArcus;ALL;/"
