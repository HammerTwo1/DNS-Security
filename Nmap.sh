#!/bin/bash

if [! -f "$1"]; then
    echo "Usage: $0 <file>"
    exit 1
fi

file="$1"
while IFS= read -r ip; do
    echo -n "Scanning $ip: "

    nmap -p 53 "$ip" | grep "53/open" > /dev/null

    if [$? -eq 0]; then
        echo "Port 53 open"
    else
        echo "Port 53 closed"
    fi
done < "$file"
