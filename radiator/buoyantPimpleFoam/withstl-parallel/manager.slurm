#!/bin/bash

module load rocky8-spack openfoam openmpi/4.1.6-gcc-10.3.0-r8-tcp

# source $FOAM_BASH # set project dir

./Allclean

# Run meshing once
sbatch mesh.slurm

# Then run the stuffs
for CORES in $(seq 8 4 16); do
    JOB_FILE="run_${CORES}.slurm"
    
    # copy intern.slurm logic for each run
    cp intern.slurm $JOB_FILE
    
    # Change ntasks value in run_.slurm 
    sed -i "s/^#SBATCH --ntasks=.*/#SBATCH --ntasks=$CORES/" $JOB_FILE
    
    echo "Submitting job with $CORES cores..."
    
    # Submit job and wait for it to complete before continuing
    sbatch --wait $JOB_FILE
done
