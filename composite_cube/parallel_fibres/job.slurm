#!/bin/bash
#SBATCH --partition=common    ### Partition
#SBATCH --time=00:10:00       ### Time limit         -t
#SBATCH --nodes=1             ### Number of Nodes    -N
#SBATCH --ntasks-per-node=1   ### Number of tasks (MPI processes)
#SBATCH --cpus-per-task=1     ### Number of threads per task (OMP threads)
#SBATCH --mem-per-cpu=256     ### Min RAM required in MB

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK     ### setup environment

module load rocky8-spack elmerfem gmsh

gmsh cube.geo -
ElmerGrid 14 2 cube.msh -autoclean
ElmerSolver
