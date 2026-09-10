#!/usr/bin/env bash

# /network-check.sh <hostname-or-ip> [port]

HOST=$1
PORT=$2

mkdir -p logs/
log_message(){
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> logs/network-check.log
}

# # validate host argument

if [ -z "$HOST" ]; then
    echo "Error: Hostname or IP address is required." >&2
    echo "Usage: $1 <hostname-or-ip> [port]" >&2
    log_message "Error: Hostname or IP address is required."
    exit 2
fi

echo  "Checking network connectivity to $HOST... "

RESOLVED_ADDR=$(getent ahosts $HOST | grep -v ':' | awk '{print $1}' | head -n 1)

# # primary validation and fallback/error handling

if [ -n "$RESOLVED_ADDR" ]; then
    echo "Resolved $HOST to $RESOLVED_ADDR"
    log_message "Resolved $HOST to $RESOLVED_ADDR"

else
    echo "Error: Failed to resolve hostname $HOST." >&2
    log_message "Error: Failed to resolve hostname $HOST."
    exit 1
fi


#  # Basic connectivity check using ping
echo "Checking connectivity"
if [  "$RESOLVED_ADDR" ]; then
    if ping -c 1 -w 20 "$RESOLVED_ADDR" &> /dev/null; then
        echo "Ping to $RESOLVED_ADDR successful."
        log_message "Ping to $RESOLVED_ADDR successful."
    else
        echo "Error: Unable to reach $RESOLVED_ADDR." >&2
        log_message "Error: Unable to reach $RESOLVED_ADDR."
        exit 1
    fi
fi

# Display network interface information
echo "--- Network Interfaces ---"
if  command -v ip >/dev/null; then
    ip -brief addr show 2>/dev/null || ip addr show
elif command -v ifconfig >/dev/null 2>&1; then
    ifconfig
else
    echo "Interface information unavailable."
fi

# Optional Tcp check
if [ -n "$PORT" ]; then
    # Check that port is a number
    if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid port $PORT"
        log_message "ERROR: port must be a number."
        exit 2
    fi
    
    # Checking port range
    
    if [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
        echo "Error: Invalid port $PORT. Port must be an integer between 1 and 65535."
        log_message "ERROR: Invalid port number $PORT."
        exit 2
    fi

#     # Connection host to port
    if ! command -v nc &> /dev/null; then
        echo "Error: The 'nc' (netcat) utility is required but not installed." >&2
        log_message "ERROR: 'nc' utility missing."
        exit 1
    fi

    echo -n "Checking TCP connection to $HOST:$PORT... "
    if nc -z -w 5 "$HOST" "$PORT" &> /dev/null; then
        echo "Connection to $HOST:$PORT successful."
        log_message "Connection to $HOST:$PORT successful."
    else
        echo "Error: Unable to connect to $HOST: $PORT." >&2
        log_message "Error: Unable to connect to $HOST: $PORT."
        exit 1
    fi
fi



