#!/bin/bash
# Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
# Copyright (C) 2023 - UTC - Stéphane MOTTELET

# This script download and patch Sundials to be used by Scilab
# Patches are managed with quilt https://linux.die.net/man/1/quilt

SUNDIALS_VERSION=7.4.0
SUNDIALS_DIR=patched_sundials
rm -rf $SUNDIALS_DIR
rm -f sundials-$SUNDIALS_VERSION.tar.gz
curl -LO  https://github.com/LLNL/sundials/releases/download/v$SUNDIALS_VERSION/sundials-$SUNDIALS_VERSION.tar.gz
CMD="s/sundials-$SUNDIALS_VERSION/$SUNDIALS_DIR/"
tar --transform $CMD -xzf sundials-$SUNDIALS_VERSION.tar.gz
cd $SUNDIALS_DIR
patch -p1 < ../01-sundials-extension.patch
patch -p1 < ../02-lapack.patch
## can be used to configure a sundials build but will produce non-crossplatform configuration
# mkdir build
# cd build
# cmake -DENABLE_OPENMP=ON ..
#cd ..
#cp build/include/sundials/*.h include/sundials
patch -p1 < ../03-export-config-and-klu.patch
#rm -rf build
cd ..
cp -a $SUNDIALS_DIR ..
