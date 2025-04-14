#!/bin/bash
# Monitors disk usage and sends local mail if usage exceeds threshold

THRESHOLD=80
USER_TO_ALERT="orangepanda"
LOGFILE="/var/log/disk_monitor.log"

df -h | grep '^/dev/' | while read line; do
    USAGE=$(echo "$line" | awk '{print $5}' | sed 's/%//')
    MOUNTPOINT=$(echo "$line" | awk '{print $6}')

    if [ "$USAGE" -ge "$THRESHOLD" ]; then
        TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
        MESSAGE="[$TIMESTAMP] Disk usage is at ${USAGE}% on ${MOUNTPOINT}."

        echo "$MESSAGE" | mail -s "Disk Alert: $MOUNTPOINT" "$USER_TO_ALERT"
        echo "$MESSAGE" >> "$LOGFILE"
    fi
done
