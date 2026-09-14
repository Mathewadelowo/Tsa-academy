#!/usr/bin/env bash

# Exit codes
# 0 — success
# 1 — operational/runtime failure
# 2 — invalid command or input


mkdir -p logs/
log_message(){
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> logs/app.log
}

show_help() {
    echo "Usage: diagnostic.sh <command> [options]"
    echo ""
    echo "Commands:"
    echo "  system-info         Display system metrics (CPU, Memory, Hostname)"
    echo "  check-host <host>   Resolve a host"
    echo "  check-port <host> <port> Check TCP connectivity to a port"
    echo "  help             Display this help message"

}   

COMMAND=$1

case "$COMMAND" in

system-info)
    echo "System Metrics:"
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p)"
    echo "Architecture: $(uname -m)"
    echo "Kernel: $(uname -s) $(uname -r)"
    echo "----------------"

    cpu_usage=$(top -bn1 | grep -i "Cpu(s)" | awk '{print $2 + $4}')
    echo "CPU Usage: ${cpu_usage}%"
    log_message "CPU Usage: ${cpu_usage}%"

    memory_usage=$(free -m | awk 'NR==2 {printf "%.2f%%", ($2 - $7) * 100 / $2}')
    echo "Memory Usage: ${memory_usage}"
    log_message "Memory Usage: ${memory_usage}"

    if [[ -r /proc/meminfo ]]; then
        awk '/MemTotal|MemFree|MemAvailable/ {
            printf "%s %.2f GB\n", $1, $2 / 1024 / 1024
        }' /proc/meminfo
        log_message "Memory information retrieved successfully."
        exit 0
        
    else
        echo "Memory information not available" >&2
        log_message "Memory information not available."
        exit 1
        
    fi
    ;;

check-host)
    HOST=$2

    if [[ -z "$HOST" ]]; then
        echo "Error: Target host is required." >&2
        log_message "Error: Target host is required."
        exit 2
    fi

    ##Resolving host address
    RESOLVED_ADDR=$(getent ahosts "$HOST" |grep -v ':' |awk '{print $1}'| head -n 1)
    
    #fallback of the resolved_addr
    if [[ -n "$RESOLVED_ADDR" ]]; then
        echo "Resolved $HOST"
        echo "Resolved IPv4: $RESOLVED_ADDR"
        log_message "Resolved $HOST to $RESOLVED_ADDR"
        exit 0
    else
        echo "Error: Failed to resolve hostname $HOST." >&2
        log_message "Error: Failed to resolve hostname $HOST."
        exit 1
    fi
    ;;

check-port)
    HOST=$2
    PORT=$3

    if [[ -z "$HOST" ]]; then
        echo "Error: target host is required." >&2
        log_message "Error: Target host is required"
        exit 2
       
    fi

    if [[ -z "$PORT" ]]; then
        echo "Error: port is required." >&2
        log_message "Error: Port is required"
        exit 2
    fi
    
    case "$PORT" in
     ''|*[!0-9]*)
        echo "Error: port must be an integer (got '${PORT}')" >&2   
        exit 2
        ;;
    esac

    if [ "$PORT" -lt 1 ] || [ "$PORT"  -gt 65535 ]; then
        echo "Error: Invalid port $PORT. Port must be an integer between 1 and 65535."
        exit 2
    fi 

    RESOLVED_ADDR=$(getent ahostsv4 "$HOST" 2>/dev/null | awk 'NR==1 {print $1}')

        if [[ -z "$RESOLVED_ADDR" ]]; then
            echo "Error: failed to resolve hostname '$HOST'." >&2
            exit 1
        fi

    echo "Checking connectivity to: ${RESOLVED_ADDR}:${PORT}..."
    echo "--------------------------------"

     if ! command -v nc >/dev/null 2>&1; then
        echo "Error: netcat (nc) is required for TCP connectivity checks." >&2
        exit 1
    fi


    if nc -vz -w 3 "$RESOLVED_ADDR" "$PORT" >/dev/null 2>&1; then
        echo "Status: SUCCESS! $HOST to $RESOLVED_ADDR on $PORT is reachable."
        log_message "SUCCESS: $HOST to $RESOLVED_ADDR on port $PORT is reachable."
        exit 0
    else
        echo "Status: FAILED! Cannot connect $HOST to $RESOLVED_ADDR on $PORT" >&2
        log_message "FAILED: Cannot connect $HOST to $RESOLVED_ADDR on port $PORT"
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