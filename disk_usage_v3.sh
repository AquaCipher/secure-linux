#!/bin/bash
THRESHOLD=80
USER_TO_ALERT="orangepanda"
LOGFILE="/var/log/disk_monitor.log"
MOUNTS=("/" "/home" "/var")  # Add or remove mount points here

for MOUNT in "${MOUNTS[@]}"; do
    USAGE=$(df -h "$MOUNT" | awk 'NR==2 {print $5}' | sed 's/%//')
    
    if [ "$USAGE" -ge "$THRESHOLD" ]; then
        TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
        MESSAGE="[$TIMESTAMP] Disk usage is at ${USAGE}% on ${MOUNT}."

        echo "$MESSAGE" | mail -s "Disk Alert: $MOUNT" "$USER_TO_ALERT"
        echo "$MESSAGE" >> "$LOGFILE"
    fi
done
