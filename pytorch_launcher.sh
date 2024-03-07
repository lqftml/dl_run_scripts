#!/bin/bash


echo "PyTorch MPI launcher script called. \
	This script parses MPI runner (mpirun or mpiexec) and \
	sets up env variable needed for initialization of DDP: \
	RANK, LOCAL_RANK, WORLD_SIZE."

if [ ! -z "$OMPI_COMM_WORLD_RANK" ]; then
    export RANK=$OMPI_COMM_WORLD_RANK
    export LOCAL_RANK=$OMPI_COMM_WORLD_LOCAL_RANK
    export WORLD_SIZE=$OMPI_COMM_WORLD_SIZE
elif [ ! -z "$PMI_RANK" ]; then
    export RANK=$PMI_RANK
    export LOCAL_RANK=$PMI_LOCAL_RANK
    export WORLD_SIZE=$(expr $PMI_SIZE + 0)
else
    echo "Error: MPI environment variables not found."
    exit 1
fi

$@

