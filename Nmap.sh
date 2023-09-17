#!/bin/bash

if [ -z "$2" ]; then
    echo "Usage: $0 <input_file> <output_file>"
    exit 1
fi

input_file="$1"
output_file="$2"


> "$output_file"

while IFS= read -r ip; do
    echo -n "Scanning $ip: "

    # Use Nmap to scan port 53
    nmap -p 53 "$ip" | grep "53/tcp open" > /dev/null

    # Check the exit status of the previous command
    if [ $? -eq 0 ]; then
        echo "Port 53 is open for $ip"
        echo "$ip" >> "$output_file"
    else
        nmap -Pn 53 "$ip" | grep "53/tcp open" > /dev/null

        if [ $? -eq 0 ]; then
            echo "Port 53 is open for $ip"
            echo "$ip" >> "$output_file"
        else
            echo "Port 53 is closed for $ip"
        fi
    fi
done < "$input_file"

echo "Results saved in $output_file"

