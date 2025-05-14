#!/bin/bash
#SBATCH --job-name=openfoam_run
#SBATCH --output=slurm_%j.out
#SBATCH --partition=common
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=8        # <--- Will be overridden by manager.slurm
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=500

module load rocky8-spack openfoam openmpi/4.1.6-gcc-10.3.0-r8-tcp

# source $FOAM_BASH

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMPI_MCA_opal_warn_on_missing_libcuda=0

CORES=$SLURM_NTASKS

echo "Running with $CORES cores..."

# Cleanup from any previous runs
rm -rf processor*
rm -f log.run$CORES

# Update numberOfSubdomains in decomposeParDict
sed -i "s/^\s*numberOfSubdomains.*/numberOfSubdomains $CORES;/" system/decomposeParDict

# Compute decomposition coeffs n = (x y z), x * y * z = CORES!
decomposition() {
    local N=$1
    local best_x=1 best_y=1 best_z=$N
    local min_diff=$N  # Initialize to a large number

    for x in $(seq 1 $N); do
        for y in $(seq $x $((N / x))); do
            z=$((N / (x * y)))
            if ((x * y * z == N)); then
                # Calculate max difference between dimensions
                max_dim=$(printf "$x\n$y\n$z" | sort -nr | head -1)
                min_dim=$(printf "$x\n$y\n$z" | sort -n | head -1)
                diff=$((max_dim - min_dim))

                if ((diff < min_diff)); then
                    best_x=$x
                    best_y=$y
                    best_z=$z
                    min_diff=$diff
                fi
            fi
        done
    done

    echo "$best_x $best_y $best_z"
}

read X Y Z <<< $(decomposition $CORES)
COEFF_STRING="($X $Y $Z)"
echo "Coeffs n $COEFF_STRING"

# Update coeffs 'n' line in decomposeParDict
sed -i "s/^\s*n\s*(.*);/    n           $COEFF_STRING;/" system/decomposeParDict

# Run solver with timing
decomposePar -force

start=$(date +%s)

# run it in parallel
mpirun -np $CORES buoyantPimpleFoam -parallel > log.run$CORES

end=$(date +%s)

elapsed=$((end - start))
echo "$CORES,$elapsed" >> parallel_run.csv

reconstructPar -newTimes