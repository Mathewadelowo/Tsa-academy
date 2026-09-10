#!/usr/bin/env bash

# /disk-check.sh <threshold> [path]

THRESHOLD=$1
CHECK_PATH=${2:-/}

mkdir -p logs
log_message(){
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> logs/disk-check.log
}

#check if threshold is provided
if [ -z "$THRESHOLD" ]; then
echo "Error: Threshold value is required." >&2
echo "Usage: $0 <threshold> [path]" >&2
log_message "Error: Threshold value is required."
exit 2
fi

# Validate threshold is an integer between 1 and 100
if ! [[ "$THRESHOLD" =~ ^[0-9]+$ ]] || [ "$THRESHOLD" -lt 1 ] || [ "$THRESHOLD" -gt 100 ]; then
    echo "Error: Threshold must be an integer between 1 and 100." >&2
    log_message "Error: Invalid threshold $THRESHOLD value."
    exit 2
fi


#check if Path is provided
if ! [  -d $CHECK_PATH ]; then
    echo "Error: Path $CHECK_PATH does not exist." >&2
    log_message "Error: Path $CHECK_PATH does not exist."
    exit 2
fi

# Get the current disk usage percentage for the specified path
USAGE=$(df -P "$CHECK_PATH" | awk 'NR==2 {print $5}' | tr -d '%')

if [ -z "$USAGE" ]; then
    echo "Error: Unable to determine disk usage for $CHECK_PATH." >&2
    log_message "Error: Unable to determine disk usage for $CHECK_PATH."
    exit 1
fi

if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "Warning: Disk usage for $CHECK_PATH is at ${USAGE}% which exceeds the threshold of ${THRESHOLD}%."
    log_message "Warning: Disk usage for $CHECK_PATH is at ${USAGE}% which exceeds the threshold of ${THRESHOLD}%."
    exit 1
else
    echo "Disk usage for $CHECK_PATH is at ${USAGE}%, which is below the threshold of ${THRESHOLD}%."
    log_message "Disk usage for $CHECK_PATH is at ${USAGE}%, which is below the threshold of ${THRESHOLD}%."
    exit 0
fi