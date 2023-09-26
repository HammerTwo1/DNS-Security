#!/bin/bash

if [ -z "$2" ]; then
    echo "Usage: $0 <input_file> <output_file>"
    exit 1
fi

input_file="$1"
output_file="$2"

# Check if the output file exists, and create it if not
if [ ! -f "$output_file" ]; then
    touch "$output_file"
fi

> "$output_file"

# Get the start date and time
start_datetime=$(date "+%Y-%m-%d %H:%M:%S")
echo "Start Date and Time: $start_datetime" >> "$output_file"

while IFS= read -r ip; do
    echo -n "Scanning $ip: "

    # Use Nmap to scan port 53 with both TCP and UDP
    nmap -p 53 -sU -sT "$ip" | grep "53/tcp open\|53/udp open" > /dev/null

    # Check the exit status of the previous command
    if [ $? -eq 0 ]; then
        echo "Port 53 is open for $ip"
        echo "$ip" >> "$output_file"
    else
        echo "Port 53 is closed for $ip"
    fi
done < "$input_file"

# Get the end date and time
end_datetime=$(date "+%Y-%m-%d %H:%M:%S")
echo "End Date and Time: $end_datetime" >> "$output_file"

echo "Results saved in $output_file"

