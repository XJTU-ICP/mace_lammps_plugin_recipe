#!/bin/bash

mkdir -p build
cd build
export CUDA_TOOLKIT_ROOT_DIR="${PREFIX}"
cmake -DLAMMPS_SOURCE_DIR=${SRC_DIR}/lammps/src -DLAMMPS_BINARY_ROOT=${PREFIX}/lib -DCMAKE_PREFIX_PATH=`python -c 'import torch;print(torch.utils.cmake_prefix_path)'` -D CMAKE_INSTALL_PREFIX=${PREFIX} ..
make -j${NUM_CPUS}
make install

for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done