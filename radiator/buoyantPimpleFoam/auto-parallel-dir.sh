#!/bin/bash

# Run mesh.slurm first in withstl-paraller folder
# cd withstl-parallel
# sbatch mesh.slurm
# sleep 1080 # wait ~18 min
# cd ..

# optimal core number is where the ratio of cores = (x y z)
# is close to one
# optimal_cores=(16 24 27 32 36 48 54 60 64 72 80 81 96 108 120 125)
optimal_cores=(27 32 36 48 54 60 64 72)

for cores in "${optimal_cores[@]}"; do
    echo "Setting up test with $cores cores"
    ./parallel-dir.sh $cores
    cd withstl-parallel-$cores
    ./parallel-test.sh $cores
    cd ..
done

echo "All tests submitted to the queue"