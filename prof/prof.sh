nsys profile \
	--nic-metrics=true \
	--trace=cuda,nvtx \
	--backtrace=dwarf \
	--gpu-metrics-device=3 \
	--capture-range=cudaProfilerApi \
	--force=true \
	$@
