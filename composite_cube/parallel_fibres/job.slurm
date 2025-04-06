#!/bin/bash
#SBATCH --partition=common    ### Partition
#SBATCH --time=00:10:00       ### Time limit         -t
#SBATCH --nodes=1             ### Number of Nodes    -N
#SBATCH --ntasks-per-node=1   ### Number of tasks (MPI processes)
#SBATCH --cpus-per-task=1     ### Number of threads per task (OMP threads)
#SBATCH --mem-per-cpu=256     ### Min RAM required in MB

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK     ### setup environment

module load rocky8-spack elmerfem gmsh

mesh_dir=$1
case_dir=$2

if [ ! -d "$mesh_dir" ]; then
    gmsh ${mesh_dir}.geo -
    ElmerGrid 14 2 ${mesh_dir}.msh -autoclean
fi

cd ${case_dir}

# rename the mesh directory
sed -i "/Mesh DB/s@\"[^\"]*\"@\"../${mesh_dir}\"@2" case.sif
sed -i "/Results Directory/s|\"[^\"]*\"|\"../${mesh_dir}\"|g" case.sif

ElmerSolver
