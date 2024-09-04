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
  "$@"
else
  "$@" >& /dev/null
fi
