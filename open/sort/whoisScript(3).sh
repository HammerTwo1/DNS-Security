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

    whois_info=$(whois "$ip")

    org_name=$(echo "$whois_info" | awk -F':' '/^OrgName/{print $2}' | tr -d '[:space:]')
    org_tech_name=$(echo "$whois_info" | awk -F':' '/^OrgTechName/{print $2}' | tr -d '[:space:]')
    address=$(echo "$whois_info" | awk -F':' '/^Address/{print $2}' | tr -d '[:space:]')
    organization=$(echo "$whois_info" | awk -F':' '/^Organization/{print $2}' | tr -d '[:space:]')
    netname=$(echo "$whois_info" | awk -F':' '/^netname/{print $2}' | tr -d '[:space:]')
    descr=$(echo "$whois_info" | awk -F':' '/^descr/{print $2}' | tr -d '[:space:]')

    echo "IP: $ip, OrgName: $org_name, OrgTechName: $org_tech_name, Address: $address, Organization: $organization, netname: $netname, descr: $descr" >> "$output_file"


    ip_seen["$ip"]=1
done

end_datetime=$(date "+%Y-%m-%d %H:%M:%S")
echo "End Date and Time: $end_datetime" >> "$output_file"

