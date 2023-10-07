#!/bin/bash

port="53"

open_port_ips=()

# Initialize a counter to track iterations
iteration=0

start_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "Script started at: $start_time"

# Loop through subnets from 0.0.0.0/24 to 255.255.255.0/24
for subnet in {8..255}.{8..255}.{8..255}.0/24; do
    ip_range="$subnet"

    # Use nmap -sL to list IP addresses in the subnet
    ip_list=$(nmap -sL $ip_range | awk '/Nmap scan report for/{gsub(/\(|\)/, "", $NF); print $NF}')

    for current_ip in $ip_list; do
        current_time=$(date +"%Y-%m-%d %H:%M:%S")
        echo "[$current_time] Checking IP: $current_ip"
       
       
        # Use nmap to check if port 53 UDP is open
        nmap -p 53 -sU "$current_ip" | grep "53/udp open" > /dev/null

        if [ "$?" -eq 0 ]; then
            open_port_ips+=("$current_ip")
            echo "Open Port 53 found at: $current_ip"  
        fi

        ((iteration++))

        # Every thousand iterations, save results to a file
        if [ "$(($iteration % 10))" -eq 0 ]; then
            output_file="open_port_ips_${iteration}.txt"
            echo "IPs with Port 53 Open (UDP):" > "$output_file"
            for ip in "${open_port_ips[@]}"; do
                echo "$ip" >> "$output_file"
                echo "Open Port 53 (UDP): $ip" >> "$output_file"
            done
            echo "Results saved in $output_file"
            open_port_ips=()  # Clear the list for the next batch
        fi
    done
done

# Save any remaining results
output_file="open_port_ips_remaining.txt"
echo "IPs with Port 53 Open (UDP):" > "$output_file"
for ip in "${open_port_ips[@]}"; do
    echo "$ip" >> "$output_file"
    echo "Open Port 53 (UDP): $ip" >> "$output_file"
done
echo "Results saved in $output_file"

end_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "Script completed at: $end_time"

echo "Scan completed."

