#!/bin/bash

### Run on rank 0 to monitor for checkpoint creation.
###  - Quits with non-zero exit code if checkpoint was not recently modified
### No longer required, so doesn't copy data to permanent storage path


SLEEP_TIME=$1
CKPT_PATH=$2
# SAVE_PATH=$3

function usage() {
    echo "$0 <sleep_time> <ckpt_path>"
    exit 1
}

function log() {
    d=$(date)
    echo "MONITOR [$d]: $1"
}

if [[ "${SLEEP_TIME}" == "" ]]; then
    usage
fi
if [[ "${CKPT_PATH}" == "" ]]; then
    usage
fi
# if [[ "${SAVE_PATH}" == "" ]]; then
#     usage
# fi

fail_count=0
last_modified=""
while true; do
    sleep $SLEEP_TIME
    dir=$(ls ${CKPT_PATH} | tail -n1)
    log "Checking log directory: ${CKPT_PATH}/${dir}"
    if [[ ! -f "${CKPT_PATH}/${dir}/config.pickle" ]]; then
        log "Config.pickle not found"
        ((fail_count++))
    else
        last_mod=$(date -r "${CKPT_PATH}/${dir}/model.pt")
        log "PATH=${CKPT_PATH}/${dir}/model.pt"
        log "last_mod=${last_mod}"
        if [[ "${last_modified}" == "${last_mod}" ]]; then
            log "No change in checkpoint"
            find "${CKPT_PATH}/${dir}"
            ((fail_count++))
        else
            log "Checkpoint updated"
            # log "Syncing checkpoints"
            # rsync -aRP ${CKPT_PATH}/./${dir} ${SAVE_PATH}/
        fi
        last_modified="${last_mod}"
    fi
    if (( fail_count > 10 )); then
        log "Too many failed updates, exiting!"
        exit 1
    fi
done
