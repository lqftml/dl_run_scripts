#!/bin/bash

'''
This cript is used for running nsys on several nodes. Use this script like
mpiexec -n $N_PROCS --ppn $PPN \
 --env TMPDIR=/home/boyda/eagle/projects/scaling/runners/tmp \
 $AFFINITY \
 this_script_prof_multinode.sh \
 python train.py params ...

'''


params="--trace=cuda,nvtx
        --backtrace=dwarf
        --capture-range=cudaProfilerApi "


if [[ $PMI_RANK -eq 0 ]]
then
  nsys profile $params \
	--gpu-metrics-device=all --nic-metrics=true \
        --output=prof_s${PMI_SIZE}_r$PMI_RANK.nsys-rep \
	"$@"
else
  nsys profile $params \
        --output=prof_s${PMI_SIZE}_r$PMI_RANK.nsys-rep \
	"$@"
fi

