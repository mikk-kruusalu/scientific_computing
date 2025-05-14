#!/bin/bash

echo "cores,time_s" > parallel_run.csv
slots=3

for n_tasks in $(seq 8 4 64); do
    echo "Running with $n_tasks tasks..."
    # Backup n_tasks before we change it
    ntasks=$n_tasks
    left=$ntasks

    # Clean up from previous run
    echo "Cleaning up previous processor directories..."
    rm -rf processor*

    echo "Removing previous log file for this run..."
    rm -f log.run$n_tasks

    # Update decomposeParDict
    sed -i "s/^\s*numberOfSubdomains.*/numberOfSubdomains $ntasks;/" system/decomposeParDict

    # Distribute tasks across 3 slots
    divider=$(( (ntasks + slots - 1) / slots ))
    COEFFS=()

    for ((i=0; i<$slots; i++)); do
        if ((left >= divider)); then
            COEFFS[i]=$divider
            left=$((left - divider))
        else
            echo "Oops"
            COEFFS[i]=$left
            left=0
        fi
    done

    COEFF_STRING="(${COEFFS[0]} ${COEFFS[1]} ${COEFFS[2]})"
    echo "Tasks distribution: $COEFF_STRING"

    sed -i "s/^\s*n\s*(.*);/    n           $COEFF_STRING;/" system/decomposeParDict

    # Run OpenFOAM commands and time them
    decomposePar -force
    start=$(date +%s)
    srun buoyantPimpleFoam -parallel > log.run$ntasks
    end=$(date +%s)
    reconstructPar -newTimes

    elapsed_time=$((end - start))
    echo "$ntasks,$elapsed_time" >> parallel_run.csv

done
