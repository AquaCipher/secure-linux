#!/bin/bash

LOG_FILE="/var/log/auth.log"

# Fallback if /var/log/auth.log doesn't exist
if [[ ! -f "$LOG_FILE" ]]; then
    LOG_FILE="/var/log/secure"
fi

if [[ ! -f "$LOG_FILE" ]]; then
    echo "No authentication log found."
    exit 1
fi

echo "Parsing failed login attempts from $LOG_FILE..."

grep "Failed password" "$LOG_FILE" | awk '
{
    for (i=1; i<=NF; i++) {
        if ($i == "for") user=$(i+1)
        if ($i == "from") ip=$(i+1)
    }
    if (user && ip) {
        print "User: " user ", IP: " ip
    }
}'
