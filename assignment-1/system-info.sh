#!/usr/bin/env bash

echo ------------
echo "Hostname: ${HOSTNAME}"
CURRENT_USER=${USER}
echo "User: $CURRENT_USER"
DATE=$(date)
echo "Date: $DATE"
OPERATING_SYSTEM=$(uname -o)
echo "Operating System: $OPERATING_SYSTEM"
KERNEL_VERSION=$(uname -r)
echo "Kernel Version: $KERNEL_VERSION"
UPTIME=$(uptime -p 2>/dev/null || uptime)
echo "Uptime: $UPTIME"
CPU_INFO=$(grep "model name" /proc/cpuinfo |head -n1)
echo "CPU Info: $CPU_INFO"
MEM_INFO=$(grep -E "MemTotal|MemFree|MemAvailable" /proc/meminfo | awk '{printf "%s %.2f GB\n", $1, $2/1024/1024}')
echo "Memory Info: $MEM_INFO"
DIR=$(pwd)
echo "Directory: $DIR"

#create log dir
mkdir -p logs

#save the operation to a log file
echo "$(date '+%Y-%m-%d %H:%M:%S') - Collected system information" >> logs/system-info.log


