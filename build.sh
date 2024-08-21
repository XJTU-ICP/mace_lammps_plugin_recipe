#!/bin/bash

mkdir -p build
cd build
if [[ "${target_platform}" != "${build_platform}" ]]; then
    export CUDA_TOOLKIT_ROOT=${CUDA_HOME}
fi
if [[ ${cuda_compiler_version} == 9.0* ]]; then
    export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;7.0+PTX"
    export CUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME
elif [[ ${cuda_compiler_version} == 9.2* ]]; then
    export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0+PTX"
    export CUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME
elif [[ ${cuda_compiler_version} == 10.* ]]; then
    export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5+PTX"
    export CUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME
elif [[ ${cuda_compiler_version} == 11.0* ]]; then
    export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0+PTX"
    export CUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME
elif [[ ${cuda_compiler_version} == 11.1 ]]; then
    export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6+PTX"
    export CUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME
elif [[ ${cuda_compiler_version} == 11.2 ]]; then
    export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6+PTX"
    export CUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME
elif [[ ${cuda_compiler_version} == 11.8 ]]; then
    export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6;8.9+PTX"
    export CUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME
elif [[ ${cuda_compiler_version} == 12.* ]]; then
    export TORCH_CUDA_ARCH_LIST="5.0;6.0;6.1;7.0;7.5;8.0;8.6;8.9;9.0+PTX"
    # $CUDA_HOME not set in CUDA 12.0. Using $PREFIX
    export CUDA_TOOLKIT_ROOT_DIR=${BUILD_PREFIX}/targets/x86_64-linux/
    export CUDA_TOOLKIT_ROOT=${BUILD_PREFIX}/targets/x86_64-linux/
    if [[ "${target_platform}" != "${build_platform}" ]]; then
        export CUDA_TOOLKIT_ROOT=${PREFIX}
    fi
else
    echo "unsupported cuda version. edit build.sh"
    exit 1
fi

PT_ABI_FLAG=$(python -c "import torch; print(int(torch.compiled_with_cxx11_abi()))")

cmake -DLAMMPS_SOURCE_DIR=${SRC_DIR}/lammps/src \
      -DLAMMPS_BINARY_ROOT=${PREFIX}/lib \
      -DCMAKE_PREFIX_PATH=$(python -c 'import torch; print(torch.utils.cmake_prefix_path)') \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_CXX11_ABI=${PT_ABI_FLAG}" ..
make -j${NUM_CPUS}
make install

for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done