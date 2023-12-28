#!/bin/bash
if [ "$PREFIX" != "$CONDA_PREFIX" ]
then
   cat << EOF
Warning:
This LAMMPS executable is in a conda environment, but the environment has
not been activated. Libraries may fail to load. To activate this environment
please see https://conda.io/activation.
EOF
fi
$PREFIX/bin/_lmp "$@"