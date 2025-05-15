#!/bin/bash

CORES=$1

mkdir withstl-parallel-$CORES
cd withstl-parallel-$CORES

ln -s ../withstl-parallel/0.orig 0.orig
ln -s ../withstl-parallel/constant constant
ln -s ../withstl-parallel/parallel-test.sh

cp -r ../withstl-parallel/system system
cp ../withstl-parallel/*.slurm .

