#!/bin/bash

# difference to other script: additional 3rd argument to check for a particular model string, which allows running several different jobs from the same folder without the checkpoint monitor checking the wrong folder/file.

### Run on rank 0 to monitor for checkpoint creation.
###  - Quits with non-zero exit code if checkpoint was not recently modified
### No longer required, so doesn't copy data to permanent storage path


SLEEP_TIME=$1
CKPT_PATH=$2
SAVE_STR=$3

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
    file=$(ls ${CKPT_PATH}/*${SAVE_STR}* | tail -n1)
    log "Checking file: ${CKPT_PATH}/${file}"
    last_mod=$(date -r "${CKPT_PATH}/${file}")
    log "last_mod=${last_mod}"
    if [[ "${last_modified}" == "${last_mod}" ]]; then
	log "No change in checkpoint"
	find "${CKPT_PATH}/${file}"
	((fail_count++))
    else
	log "Checkpoint updated"
    fi
    last_modified="${last_mod}"
    if (( fail_count > 10 )); then
        log "Too many failed updates, exiting!"
        exit 1
    fi
done
