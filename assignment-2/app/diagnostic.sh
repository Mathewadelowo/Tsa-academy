#!/usr/bin/env bash

# Exit codes
# 0 — success
# 1 — operational/runtime failure
# 2 — invalid command or input

show_help() {
    echo "Usage: diagnostic.sh <command> [options]"
    echo ""
    echo "Commands:"
    echo "  system           Display system metrics (CPU, Memory, Hostname)"
    echo "  disk <threshold> Check disk usage against percentage threshold (1-100)"
    echo "  network <host>   Check host connectivity and ping"
    echo "  help             Display this help message"
}

COMMAND=$1

case "$COMMAND" in

system)
    echo "System Metrics:"
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p)"
    echo "----------------"

    cpu_usage=$(top -bn1 | grep -i "Cpu(s)" | awk '{print $2 + $4}')
    echo "CPU Usage: ${cpu_usage}%"

    memory_usage=$(free -m | awk 'NR==2 {printf "%.2f%%", ($2 - $7) * 100 / $2}')
    echo "Memory Usage: ${memory_usage}"

    if [[ -r /proc/meminfo ]]; then
        awk '/MemTotal|MemFree|MemAvailable/ {
            printf "%s %.2f GB\n", $1, $2 / 1024 / 1024
        }' /proc/meminfo
        exit 0
    else
        echo "Memory information not available" >&2
        exit 1
    fi
    ;;

disk)
    THRESHOLD=$2

    if [[ -z "$THRESHOLD" ]]; then
        echo "Error: Threshold is required. Please provide a value between 1 and 100." >&2
        exit 2
    fi

    if [[ ! "$THRESHOLD" =~ ^[0-9]+$ ]]; then
        echo "Error: Threshold must be a number between 1 and 100." >&2
        exit 2
    fi

    if [[ "$THRESHOLD" -lt 1 || "$THRESHOLD" -gt 100 ]]; then
        echo "Error: Threshold must be between 1 and 100." >&2
        exit 2
    fi

    USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

    echo "Current disk usage: ${USAGE}%"

    if [[ "$USAGE" -gt "$THRESHOLD" ]]; then
        echo "Warning: Disk usage is ABOVE the ${THRESHOLD}% threshold!"
        exit 1
    else
        echo "Disk usage is within safe limits."
        exit 0
    fi
    ;;

network)
    HOST=$2

    if [[ -z "$HOST" ]]; then
        echo "Error: Target host is required." >&2
        exit 2
    fi

    echo "Checking connectivity to: $HOST"
    echo "--------------------------------"

    if ping -c 2 -w 3 "$HOST" >/dev/null 2>&1; then
        echo "Status: SUCCESS! $HOST is reachable."
        exit 0
    else
        echo "Status: FAILED! Cannot connect to $HOST." >&2
        exit 1
    fi
    ;;

help)
    show_help
    exit 0
    ;;

*)
    echo "Invalid command. Use 'diagnostic.sh help' for usage information." >&2
    show_help
    exit 2
    ;;

esac