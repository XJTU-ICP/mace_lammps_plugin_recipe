export LD_LIBRARY_PATH=$(echo ${LD_LIBRARY_PATH} | awk -v RS=: -v ORS=: '/torch/ {next} {print}' | sed 's/:*$//')
export LAMMPS_PLUGIN_PATH=$(echo ${LAMMPS_PLUGIN_PATH} | awk -v RS=: -v ORS=: '/mace_lmphigh/ {next} {print}' | sed 's/:*$//')