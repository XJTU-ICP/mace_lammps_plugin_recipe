export LD_LIBRARY_PATH=`python -c "import torch;import os;libtorch_path = os.path.join(os.path.dirname(torch.__file__), 'lib');print(libtorch_path)
"`${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
export LAMMPS_PLUGIN_PATH=${CONDA_PREFIX}/lib/mace_lmphigh/${LAMMPS_PLUGIN_PATH:+:$LAMMPS_PLUGIN_PATH}