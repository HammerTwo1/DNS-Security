#!/bin/bash
output_file="whois.txt"

declare -A ip_seen

start_datetime=$(date "+%Y-%m-%d %H:%M:%S")
echo "Start Date and Time: $start_datetime" >> "$output_file"

for ip in $(cat OpenPort.txt); do
    # Check if the IP address is already seen, and skip if it's a duplicate
    if [[ -n "${ip_seen[$ip]}" ]]; then
        continue
    fi

    org_name=$(whois "$ip" | awk -F':' '/^OrgName/{print $2}' | tr -d '[:space:]')
    echo "IP: $ip, OrgName: $org_name" >> "$output_file"

    # Mark the IP as seen
    ip_seen["$ip"]=1
done

end_datetime=$(date "+%Y-%m-%d %H:%M:%S")
echo "End Date and Time: $end_datetime" >> "$output_file"
