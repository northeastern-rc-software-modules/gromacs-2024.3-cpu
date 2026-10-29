#!/bin/bash
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p short
#SBATCH -t 02:00:00
#SBATCH --job-name=gromacs-2024.3-cpu-build
#SBATCH --output=slurm-%j.out

source env_gromacs-2024.3-cpu.sh

mkdir -p $SOFTWARE_DIRECTORY/src

cd $SOFTWARE_DIRECTORY/src
wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.6.tar.gz
tar -xvf openmpi-4.1.6.tar.gz
cd openmpi-4.1.6
./configure --prefix=$SOFTWARE_DIRECTORY --with-pmix --without-verbs
make -j 32
make install

cd $SOFTWARE_DIRECTORY/src
wget https://ftp.gromacs.org/gromacs/gromacs-2024.3.tar.gz
tar -xvf gromacs-2024.3.tar.gz
cd gromacs-2024.3
mkdir build
cd build

cmake .. \
-DGMX_MPI=ON \
-DGMX_GPU=OFF \
-DGMX_SIMD=AVX2_256 \
-DGMX_BUILD_OWN_FFTW=ON \
-DBUILD_TESTING=OFF \
-DCMAKE_INSTALL_PREFIX=$SOFTWARE_DIRECTORY

make -j 32
make install

touch $SOFTWARE_VERSION
echo "#%Module" >> $SOFTWARE_VERSION
echo "module-whatis \"Loads $SOFTWARE_NAME/$SOFTWARE_VERSION module." >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "This module was built on $(date)" >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "GROMACS (https://www.gromacs.org/) is a molecular dynamics package." >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "The script used to build this module can be found here: $GITHUB_URL" >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "To load the module, type:" >> $SOFTWARE_VERSION
echo "module load $SOFTWARE_NAME/$SOFTWARE_VERSION" >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "\"" >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "conflict $SOFTWARE_NAME" >> $SOFTWARE_VERSION
echo "prepend-path PATH $SOFTWARE_DIRECTORY/bin" >> $SOFTWARE_VERSION
echo "prepend-path LIBRARY_PATH $SOFTWARE_DIRECTORY/lib" >> $SOFTWARE_VERSION
echo "prepend-path LD_LIBRARY_PATH $SOFTWARE_DIRECTORY/lib" >> $SOFTWARE_VERSION
echo "prepend-path CPATH $SOFTWARE_DIRECTORY/include" >> $SOFTWARE_VERSION

mkdir -p $CLUSTER_DIRECTORY/modulefiles/$SOFTWARE_NAME
cp $SOFTWARE_VERSION $CLUSTER_DIRECTORY/modulefiles/$SOFTWARE_NAME/$SOFTWARE_VERSION
