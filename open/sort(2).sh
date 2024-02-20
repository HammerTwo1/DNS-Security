#!/bin/bash

# Directory containing the files
directory="/home/bishop/Desktop/DNSSec/DNS-Security/open"



output_file="extracted_unique_ips.txt"

# Initialize an array to store unique IPs
declare -A unique_ips


for file in "$directory"/*; do
    if [ -f "$file" ]; then
        # Extract lines with IP addresses from the current file and check for duplicates
        while IFS= read -r line; do
            if [[ $line =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                
                if [ -z "${unique_ips[$line]}" ]; then
                    unique_ips["$line"]=1
                    echo "$line" >> "$output_file"
                fi
            fi
        done < "$file"
    fi
done

echo "Unique IP addresses extracted and saved in $output_file"



