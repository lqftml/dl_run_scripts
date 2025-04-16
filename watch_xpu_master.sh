#!/bin/bash

if [ ! -z "$OMPI_COMM_WORLD_RANK" ]; then
    export RANK=$OMPI_COMM_WORLD_RANK
elif [ ! -z "$PMI_RANK" ]; then
    export RANK=$PMI_RANK
elif [ ! -z "$PALS_RANKID" ]; then
    export RANK=$PALS_RANKID
else
    echo "Error: no OpenMPI or MPICH found."
    exit 1
fi

#https://stackoverflow.com/a/28099707/7674852
if [ $RANK -eq 0 ]
then
    echo '== START RUN ==' > profile.txt
    while true; do
        date >> profile.txt
        xpu-smi dump -d -1 -m 0,1,3 >> profile.txt
        sleep 2
    done &
    "$@"
    x=$(jobs)
    kill -INT %1
    echo '== JOBS ==' >> profile.txt
    echo "${x}" >> profile.txt
    echo '== END RUN ==' >> profile.txt
else
    "$@"
fi
