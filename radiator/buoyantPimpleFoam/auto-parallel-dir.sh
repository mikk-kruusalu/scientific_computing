#!/bin/bash

# chmod +x ./parallel-dir.sh # make exicutables
# chmod +x ./withstl-parallel/parallel-test.sh

for cores in $(seq 8 4 64); do
    echo "Setting up test with $cores cores"
    ./parallel-dir.sh $cores
    cd withstl-parallel-$cores

    ./parallel-test.sh $cores
    
    cd ..
done

echo "All tests submitted to the queue"