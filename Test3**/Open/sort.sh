#!/bin/bash

# Directory containing the files
directory="/home/bishop/Desktop/DNSSec/Test3/Open"


# Output file for extracted unique IPs
output_file="extracted_unique_ips.txt"

# Initialize an array to store unique IPs
declare -A unique_ips

# Loop through files in the directory
for file in "$directory"/*; do
    if [ -f "$file" ]; then
        # Extract lines with IP addresses from the current file and check for duplicates
        while IFS= read -r line; do
            if [[ $line =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                # Check if the IP address is not already in the unique_ips array
                if [ -z "${unique_ips[$line]}" ]; then
                    unique_ips["$line"]=1
                    echo "$line" >> "$output_file"
                fi
            fi
        done < "$file"
    fi
done

echo "Unique IP addresses extracted and saved in $output_file"



