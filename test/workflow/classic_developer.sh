#! /bin/bash

set -e
set -x

if [[ "$ENVNAME" =~ jun19 ]]
then
  no_boost_cmake=1
fi

unset FAIRSOFT_ROOT
export SIMPATH="$(realpath ./fairsoft)"
cmake="$SIMPATH/bin/cmake"
spack view --dependencies true -e fairroot symlink -i $SIMPATH fairroot cmake

git clone --branch dev https://github.com/FairRootGroup/FairRoot
pushd FairRoot
export FAIRROOTPATH="$(realpath ./install)"
$cmake -S. -Bbuild \
  -DUSE_DIFFERENT_COMPILER=ON \
  ${no_boost_cmake:+-DBoost_NO_BOOST_CMAKE=ON} \
  -DCMAKE_INSTALL_PREFIX=$FAIRROOTPATH
$cmake --build build --target install -j $SLURM_CPUS_PER_TASK
$cmake --build build --target test
popd
