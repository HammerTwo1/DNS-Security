#!/bin/bash
for ip in $(cat OpenPort.txt); do whois $ip | echo "$ip $(grep 'OrgName')"; done > whois.txt
