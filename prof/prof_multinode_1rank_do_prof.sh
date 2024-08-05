#!/bin/bash

params="--trace=cuda,nvtx 
        --backtrace=dwarf 
        --capture-range=cudaProfilerApi
        --mpi-impl=mpich	  "

if [[ $PMI_RANK -eq 0 ]]
then
  nsys profile $params \
	--gpu-metrics-device=all --nic-metrics=true \
	--output=multinode_prof_size_${PMI_SIZE}_rank_$PMI_RANK.nsys-rep \
	$@
else
	$@
fi

