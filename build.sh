#!/usr/bin/env bash


TARGET=$(dirname "$0")
echo "Installing to folder: $TARGET (ctrl-c within 5s to abort!)"
sleep 5

cd $TARGET
cd src
cd colmap
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$TARGET
make && make install
cd ../..

mkdir eigen_build && cd eigen_build
cmake . ../eigen  -DCMAKE_INSTALL_PREFIX=$TARGET
make && make install
cd ..

mkdir openMVS_build && cd openMVS_build
cmake . ../openMVS -DCMAKE_INSTALL_PREFIX=$TARGET -DCMAKE_BUILD_TYPE=Release -DVCG_DIR="$TARGET/src/vcglib" -DEIGEN_DIR=$TARGET/include/eigen3
make && make install
cd ..
