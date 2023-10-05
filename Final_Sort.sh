#!/bin/bash


organizations=("Google" "CiscoOpenDNS" "Cisco" "Cloudflare" "Amazon" "Quad9" "SoftLayer" "Microsoft" "Cloudfanatic" "Godaddy" "Oracle" "Akamai" "Controld" "Alternate")


declare -A ip_addresses


while IFS= read -r line; do

    for org in "${organizations[@]}"; do
        # Check if the line contains the organization name
        if [[ "$line" == *"$org"* ]]; then
          
            if [[ "$line" =~ IP:\ ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+) ]]; then
                ip="${BASH_REMATCH[1]}"
                ip_addresses["$org"]+=" $ip"
            fi
        fi
    done
done < whois.txt

# Save the sorted results to the output file
output_file="sorted_org_ips.txt"
rm -f "$output_file"

for org in $(echo "${organizations[@]}" | tr ' ' '\n' | sort); do
    ips="${ip_addresses["$org"]}"
    if [ -n "$ips" ]; then
        echo "Organization: $org" >> "$output_file"
        echo "IP addresses: $ips" >> "$output_file"
        echo >> "$output_file"  
    fi
done

echo "Sorted results saved in $output_file"

