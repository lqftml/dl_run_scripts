#!/bin/bash

### Run on rank 0 to monitor for checkpoint creation.
###  - Periodically copies data to permanent storage path
###  - Quits with non-zero exit code if checkpoint was not recently modified


SLEEP_TIME=$1
CKPT_PATH=$2
SAVE_PATH=$3

function usage() {
    echo "$0 <sleep_time> <ckpt_path> <save_path>"
    exit 1
}

if [[ "${SLEEP_TIME}" == "" ]]; then
    usage
fi
if [[ "${CKPT_PATH}" == "" ]]; then
    usage
fi
if [[ "${SAVE_PATH}" == "" ]]; then
    usage
fi

fail_count=0
last_modified=""
while true; do
    sleep $SLEEP_TIME
    dir=$(ls ${CKPT_PATH} | head -n1)
    echo "Checking log directory: ${CKPT_PATH}/${dir}"
    last_mod=$(date -r "${CKPT_PATH}/${dir}/model.pt")
    echo "PATH" "${CKPT_PATH}/${dir}/model.pt"
    echo "last_mod=${last_mod}"
    if [[ ! -f "${CKPT_PATH}/${dir}/config.pickle" ]]; then
        echo "Config.pickle not found"
        ((fail_count++))
    elif [[ "${last_modified}" == "${last_mod}" ]]; then
        echo "No change in checkpoint"
        find "${CKPT_PATH}/${dir}"
        ((fail_count++))
    else
        echo "Syncing checkpoints"
        rsync -aRP ${CKPT_PATH}/./${dir} ${SAVE_PATH}/
    fi
    last_modified="${last_mod}"
    if (( fail_count > 10 )); then
        echo "Too many failed updates, exiting!"
        exit 1
    fi
done
