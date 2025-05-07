#!/bin/bash
#SBATCH --partition=common    ### Partition
#SBATCH --time=08:00:00       ### Time limit         -t
#SBATCH --nodes=1             ### Number of Nodes    -N
#SBATCH --ntasks-per-node=10  ### Number of tasks (MPI processes)
#SBATCH --cpus-per-task=1     ### Number of threads per task (OMP threads)
#SBATCH --mem-per-cpu=500     ### Min RAM required in MB

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK     ### setup environment

module load rocky8-spack openfoam openmpi

decomposePar -force
srun buoyantPimpleFoam -parallel
reconstructPar -newTimes

