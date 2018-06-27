#!/usr/bin/env bash


TARGET="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Installing to folder: $TARGET (ctrl-c within 5s to abort!)"
sleep 5

cd $TARGET/src
cd colmap
mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$TARGET
make && make install

cd $TARGET/src
mkdir -p eigen_build && cd eigen_build
cmake . ../eigen  -DCMAKE_INSTALL_PREFIX=$TARGET
make && make install

cd $TARGET/src
mkdir -p openMVS_build && cd openMVS_build
cmake . ../openMVS -DCMAKE_INSTALL_PREFIX=$TARGET -DCMAKE_BUILD_TYPE=Release -DVCG_DIR="$TARGET/src/VCG" -DEIGEN_DIR=$TARGET/include/eigen3
make && make install
