#!/bin/bash
#
echo "Hello from rank $RANK (local rank $LOCAL_RANK) out of size $WORLD_SIZE. Master address $MASTER_ADDR, master port $MASTER_PORT. My CUDA_VISIBLE_DEVICES={$CUDA_VISIBLE_DEVICES}."
