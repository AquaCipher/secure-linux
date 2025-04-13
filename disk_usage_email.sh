#!/bin/bash
# Monitors disk usage and sends local mail if usage exceeds threshold

THRESHOLD=80                    # Alert threshold (in %)
USER_TO_ALERT="orangepanda"    # Local system user to receive the alert

df -h | grep '^/dev/' | while read line; do
    USAGE=$(echo "$line" | awk '{print $5}' | sed 's/%//')
    MOUNTPOINT=$(echo "$line" | awk '{print $6}')
    
    if [ "$USAGE" -ge "$THRESHOLD" ]; then
        MESSAGE="[$(date)] Disk usage is at ${USAGE}% on ${MOUNTPOINT}."
        echo "$MESSAGE" | mail -s "Disk Alert: $MOUNTPOINT" "$USER_TO_ALERT"
    fi
done
