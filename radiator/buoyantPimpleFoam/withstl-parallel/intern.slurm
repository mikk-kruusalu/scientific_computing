#!/bin/bash
#SBATCH --job-name=openfoam_run
#SBATCH --output=slurm_%j.out
#SBATCH --partition=common
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=8        # <--- Will be overridden by submit_all.sh
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=500

module load rocky8-spack openfoam openmpi
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

CORES=$SLURM_NTASKS
SLOTS=3  # For decomposition layout

echo "Running with $CORES cores..."

# Cleanup from any previous runs
rm -rf processor*
rm -f log.run$CORES

# Update numberOfSubdomains in decomposeParDict
sed -i "s/^\s*numberOfSubdomains.*/numberOfSubdomains $CORES;/" system/decomposeParDict

# Compute decomposition coeffs
DIV=$(( (CORES + SLOTS - 1) / SLOTS ))
LEFT=$CORES
COEFFS=()

for ((i=0; i<$SLOTS; i++)); do
    if ((LEFT >= DIV)); then
        COEFFS[i]=$DIV
        LEFT=$((LEFT - DIV))
    else
        COEFFS[i]=$LEFT
        LEFT=0
    fi
done

COEFF_STRING="(${COEFFS[0]} ${COEFFS[1]} ${COEFFS[2]})"
echo "Tasks distribution: $COEFF_STRING"

# Update 'n' line in decomposeParDict
sed -i "s/^\s*n\s*(.*);/    n           $COEFF_STRING;/" system/decomposeParDict

# Run solver with timing
decomposePar -force
start=$(date +%s)
srun buoyantPimpleFoam -parallel > log.run$CORES
end=$(date +%s)

elapsed=$((end - start))
echo "$CORES,$elapsed" >> parallel_run.csv

reconstructPar -newTimes