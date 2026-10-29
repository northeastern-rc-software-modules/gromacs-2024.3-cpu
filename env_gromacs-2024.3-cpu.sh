#!/bin/bash

module load explorer/1.0
module load cmake/3.30.2
module load gcc/13.2.0

export SOFTWARE_NAME=GROMACS
export SOFTWARE_VERSION=2024.3-cpu

# For dry run:
#export CLUSTER_DIRECTORY=/scratch/$USER

# For final deployment:
export CLUSTER_DIRECTORY=/shared/EL9/explorer

export GITHUB_URL=https://github.com/northeastern-rc-software-modules/gromacs-2024.3-cpu

export SOFTWARE_DIRECTORY=$CLUSTER_DIRECTORY/$SOFTWARE_NAME/$SOFTWARE_VERSION

export PATH=$SOFTWARE_DIRECTORY/bin:$PATH
export LIBRARY_PATH=$SOFTWARE_DIRECTORY/lib:$LIBRARY_PATH
export LD_LIBRARY_PATH=$SOFTWARE_DIRECTORY/lib:$LD_LIBRARY_PATH
export CPATH=$SOFTWARE_DIRECTORY/include:$CPATH
