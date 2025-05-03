#!/bin/bash
#SBATCH --partition=common    ### Partition
#SBATCH --time=01:30:00       ### Time limit         -t
#SBATCH --nodes=1             ### Number of Nodes    -N
#SBATCH --ntasks-per-node=1   ### Number of tasks (MPI processes)
#SBATCH --cpus-per-task=3     ### Number of threads per task (OMP threads)
#SBATCH --mem-per-cpu=400     ### Min RAM required in MB

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK     ### setup environment
module load rocky8-spack openfoam
srun snappyHexMesh -overwrite
