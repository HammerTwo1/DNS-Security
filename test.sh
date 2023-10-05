#!/bin/bash

start_ip="0.0.0.0"
end_ip="255.255.255.255"
port="53"

open_port_ips=()

# Initialize a counter to track iterations
iteration=0

# Loop through subnets from 0.0.0.0/24 to 255.255.255.0/24
for subnet in {0..255}.{0..255}.{0..255}.0/24; do
    ip_range="0.0.0.0/24"

    ip_list=$(nmap -sL $subnet | awk '/Nmap scan report for/{print $NF}')

    for current_ip in $ip_list; do
        echo "Checking IP: $current_ip"

       
        nmap -p "$port" -sU -sT "$current_ip" | grep "53/tcp open\|53/udp open" > /dev/null

     
        if [ "$?" -eq 0 ]; then
            open_port_ips+=("$current_ip")
            echo "Open Port 53 found at: $current_ip"  
        fi

        ((iteration++))

        # Every thousand iterations, save results to a file
        if [ "$(($iteration % 1000))" -eq 0 ]; then
            output_file="open_port_ips_${iteration}.txt"
            echo "IPs with Port 53 Open (TCP/UDP):" > "$output_file"
            for ip in "${open_port_ips[@]}"; do
                echo "$ip" >> "$output_file"
                echo "Open Port 53 (TCP/UDP): $ip" >> "$output_file"
            done
            echo "Results saved in $output_file"
            open_port_ips=()  # Clear the list for the next batch
        fi
    done
done

# Save any remaining results
output_file="open_port_ips_remaining.txt"
echo "IPs with Port 53 Open (TCP/UDP):" > "$output_file"
for ip in "${open_port_ips[@]}"; do
    echo "$ip" >> "$output_file"
    echo "Open Port 53 (TCP/UDP): $ip" >> "$output_file"
done
echo "Results saved in $output_file"

echo "Scan completed."

