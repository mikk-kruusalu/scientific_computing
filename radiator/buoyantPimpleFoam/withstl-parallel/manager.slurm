#!/bin/bash

for CORES in $(seq 8 4 64); do
    JOB_FILE="run_${CORES}.slurm"
    cp run_template.slurm $JOB_FILE
    sed -i "s/^#SBATCH --ntasks=.*/#SBATCH --ntasks=$CORES/" $JOB_FILE
    echo "Submitting job with $CORES cores..."
    sbatch $JOB_FILE
done
