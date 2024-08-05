

mpiexec -n $N_PROCS --ppn $PPN \
        --env TMPDIR=/home/boyda/eagle/projects/scaling/runners/tmp \
        $AFFINITY \
	./prof_multinode.sh \
	python /home/boyda/eagle/projects/scaling/code/scaling_tests/pytorch_facked_imageNet.py  --epoch 200 --arch resnet18 --name profile-resnet18-$N_PROCS  --nnodes $N_PROCS --backend nccl --profile
