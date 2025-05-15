#!/bin/bash

CORES=$1

echo "Running with $CORES cores"

# Cleanup from any previous runs
rm -rf processor*
rm -rf 0.[0-9]*
mkdir 0
cp -r 0.orig/* 0/
   
#----- Update OpenFOAM decomposition files -----
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
echo "Decomposition n $COEFF_STRING"
    
# Update coeffs 'n' line in decomposeParDict
sed -i "s/^\s*n\s*(.*);/    n           $COEFF_STRING;/" system/decomposeParDict
# ----- -----
   
# Change ntasks value 
sed -i "s/^#SBATCH --ntasks=.*/#SBATCH --ntasks=$CORES/" solve.slurm
   
echo "$CORES,\"$COEFF_STRING\",$elapsed" >> parallel-test.csv

sbatch solve.slurm


