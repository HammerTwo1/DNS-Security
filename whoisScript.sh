#!/bin/bash

for ip in $(cat OpenPort.txt); do
    whois $ip | grep 'OrgName' >> whois.txt
done

