#!/bin/bash

if [ ! -z "$OMPI_COMM_WORLD_RANK" ]; then
    export RANK=$OMPI_COMM_WORLD_RANK
    export LOCAL_RANK=$OMPI_COMM_WORLD_LOCAL_RANK
    export WORLD_SIZE=$OMPI_COMM_WORLD_SIZE
elif [ ! -z "$PMI_RANK" ]; then
    export RANK=$PMI_RANK
    export LOCAL_RANK=$PMI_LOCAL_RANK
    export WORLD_SIZE=$(expr $PMI_SIZE + 0)
elif [ ! -z "$PALS_RANKID" ]; then
    export RANK=$PALS_RANKID
    export LOCAL_RANK=$PALS_LOCAL_RANKID
    if [[ "${WORLD_SIZE}" == "" ]]; then
        echo "Error: WORLD_SIZE must be set for PALS systems"
        exit 1
    fi
else
    echo "Error: no OpenMPI or MPICH found."
    exit 1
fi

if [ ! -z "$PBS_NODEFILE" ]; then
    MASTER_ADDR=$(head -n 1 $PBS_NODEFILE)
    export MASTER_ADDR
elif [ ! -z "$SLURM_NODELIST" ]; then
    MASTER_ADDR=$(scontrol show hostnames $SLURM_NODELIST | head -n 1)
    export MASTER_ADDR
else
    MASTER_ADDR=`hostname`
    export MASTER_ADDR
fi

export MASTER_PORT=29500

"$@"

