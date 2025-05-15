#!/bin/bash
#SBATCH --partition=common    ### Partition
#SBATCH --time=08:00:00       ### Time limit         -t
#SBATCH --ntasks=10
#SBATCH --cpus-per-task=1     ### Number of threads per task (OMP threads)
#SBATCH --mem-per-cpu=500     ### Min RAM required in MB

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK     ### setup environment

module load rocky8-spack openfoam openmpi

decomposePar -force

start=$(date +%s)
srun buoyantPimpleFoam -parallel
end=$(date +%s)
elapsed=$((end - start))
echo "Elapsed time $elapsed s"
sed -i "/^$SLURM_NTASKS/ s/$/$elapsed,$SLURM_JOB_ID/" parallel-test.csv

reconstructPar -newTimes

