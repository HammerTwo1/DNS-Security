
# DNS-Security

This project is to determine the security levels of DNS resolvers hosted on the cloud by cloud providers. The scripts provided are meant to scan IPv4 IPs for open DNS, port 53 UDP; gather information from the Whois database, and filter through to extract available IPs from cloud providers. The data will be used to build a database and analyze the resolvers from a local DNS server.



## Usage/Examples Brute-Force_Nmap(1).sh 

There are 4 main scripts. All are numbered in the file name.

The first script, "Brute-Force_Nmap(1).sh," is meant to scan a subnet range of IPs.
For a more effective scan, it is recommended to create multiple directories, approximately 10, and copy the script to each directory, which will be edited for each subnet and executed in parallel. 

For example, in the test2 directory, the script is set with the scan range 2.0.0.0 - 3.0.0.0. The syntax is as follows.

```Bash
# Loop through subnets from 0.0.0.0/24 to 255.255.255.0/24
for subnet in {2..3}.{0..255}.{0..255}.0/24; do # The subnet needs to be modified as needed for scan range.
    ip_range="$subnet

```
Note that the scan will stop at 2.255.255.255. 
The subnet needs to be edited as needed.

The script uses Nmap for port scanning.

```Bash
# Check if port 53 UDP is open
    nmap -p 53 -sU -T4 --open --min-rate=256 "$current_ip" | grep "53/udp open" > /dev/null
```

For every 1,000 IPs with port 53 open, the script will save a file within the directory.

```Bash
# Every thousand iterations, save results to a file
    if [ "$(($iteration % 1000))" -eq 0 ]; then
        output_file="open_port_ips_${iteration}.txt"
        for ip in "${open_port_ips[@]}"; do
            echo "$ip" >> "$output_file"
        done
        echo "Results saved in $output_file"
        open_port_ips=()  # Clear the list for the next batch

```

Each script will have a start, current, and an end date/time.
```Bash
start_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "Script started at: $start_time"

current_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "[$current_time] Checking IP: $current_ip"

end_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "Script completed at: $end_time"

```

To execute the script, make sure the file is set as executable. "chmod -x 'File_Name.sh'" 

sudo ./Brute-Force_Nmap(1).sh

To run the script in the background run: sudo ./Brute-Force_Nmap(1).sh &>/dev/null &

![Alt text]([HammerTwo1/DNS-Security/blob/main/Screenshot at 2024-03-11 21-25-58.png](https://github.com/HammerTwo1/DNS-Security/blob/main/Screenshot%20at%202024-03-11%2021-25-58.png)raw=true )

## Usage/Example sort(2).sh

It is recommended that the collected IPs be sorted as often as possible.

Please move the collected IPs, .txt files, to a separate directory called open. 

The variable "directory" should be modified to your appropriate directory path.

```Bash
directory="apropreate dirctory path"
```
All .txt files will be combined into one .txt file, called extracted_unique_ips.txt.
```Bash
output_file="extracted_unique_ips.txt"
```
The for loop will open every .txt file in the directory and list the IPs in a single line, storing each IP in an array.

```Bash
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
```

To execute the script, make sure the file is set as executable. "chmod -x 'File_Name.sh'" and the script is located with all the collected IPs.

sudo ./sort(2).sh
## Usage/Example whoisScript(3).sh

From sort(2).sh, the extracted_unique_ips.txt file will be used as an input for our third script.

The purpose of this script is to see where the IPs are from. What organization or company are they from? 

The output file will be called "whois.txt"


These variables can be edited/modified to extract more information provided by Whois.

```Bash
whois_info=$(whois "$ip")

    org_name=$(echo "$whois_info" | awk -F':' '/^OrgName/{print $2}' | tr -d '[:space:]')
    org_tech_name=$(echo "$whois_info" | awk -F':' '/^OrgTechName/{print $2}' | tr -d '[:space:]')
    address=$(echo "$whois_info" | awk -F':' '/^Address/{print $2}' | tr -d '[:space:]')
    organization=$(echo "$whois_info" | awk -F':' '/^Organization/{print $2}' | tr -d '[:space:]')
    netname=$(echo "$whois_info" | awk -F':' '/^netname/{print $2}' | tr -d '[:space:]')
    descr=$(echo "$whois_info" | awk -F':' '/^descr/{print $2}' | tr -d '[:space:]')

echo "IP: $ip, OrgName: $org_name, OrgTechName: $org_tech_name, Address: $address, Organization: $organization, netname: $netname, descr: $descr" >> "$output_file"
```
To execute the script, make sure the file is set as executable. "chmod -x 'File_Name.sh'" and the script is located with sorted IPs.

sudo ./whoisScript(3).sh
## Usage/Example Final_Sort(4).sh

The last script will filter the IPs from whoisScript(3) to organiz any cloud providers that we specify.


More organizations can be added or removed.
```Bash
organizations=("Google" "CiscoOpenDNS" "Cisco" "Cloudflare" "Amazon" "Quad9" "SoftLayer" "Microsoft" "Cloudfanatic" "Godaddy" "Oracle" "Akamai" "Controld" "Alternate")
```

The output will be saved in a file called "sorted_org_ips.txt"

To execute the script, make sure the file is set as executable. "chmod -x 'File_Name.sh'" and the script is located with sorted IPs.

sudo ./Final_Sort(4).sh
