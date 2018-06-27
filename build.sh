#!/usr/bin/env bash


TARGET="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Installing to folder: $TARGET (ctrl-c within 5s to abort!)"
sleep 5


cd $TARGET/src
mkdir -p eigen_build && cd eigen_build
cmake . ../eigen  -DCMAKE_INSTALL_PREFIX=$TARGET
make -j16 && make install

cd $TARGET/src
mkdir -p cgal_build && cd cgal_build
cmake . ../cgal -DCMAKE_INSTALL_PREFIX=$TARGET -DWITH_Eigen3=OFF
make -j16 && make install


cd $TARGET/src
mkdir -p colmap_build && cd colmap_build
cmake . ../colmap -DCMAKE_INSTALL_PREFIX=$TARGET
make -j16 && make install


cd $TARGET/src
mkdir -p openMVS_build && cd openMVS_build
cmake . ../openMVS -DCMAKE_INSTALL_PREFIX=$TARGET -DCMAKE_BUILD_TYPE=Release -DVCG_DIR="$TARGET/src/VCG" -DEIGEN_DIR=$TARGET/include/eigen3 -DCGAL_DIR=$TARGET/lib/cmake/CGAL
make -j16 && make install
