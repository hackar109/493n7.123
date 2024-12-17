#!/bin/bash

# Website Enumeration Tool

echo "=== Website Enumeration Tool ==="
read -p "Enter the target domain (e.g., example.com): " domain

# DNS Lookup
echo -e "\n[+] DNS Records:"
host $domain || echo "Failed to fetch DNS records."

# WHOIS Lookup
echo -e "\n[+] WHOIS Lookup:"
whois $domain || echo "Failed to perform WHOIS lookup."

# Subdomain Enumeration
echo -e "\n[+] Subdomain Enumeration:"
subdomains=("www" "mail" "ftp" "test" "dev")
for sub in "${subdomains[@]}"; do
    subdomain="$sub.$domain"
    if curl -s --head --request GET "http://$subdomain" | grep "200 OK" > /dev/null; then
        echo " - Found: $subdomain"
    fi
done

# Banner Grabbing
echo -e "\n[+] Banner Grabbing:"
ip=$(dig +short $domain | head -n 1)
if [ -n "$ip" ]; then
    echo " - IP Address: $ip"
    echo " - Banner:"
    (echo -e "HEAD / HTTP/1.0\r\n\r\n"; sleep 1) | nc $ip 80 || echo "Failed to grab banner."
else
    echo "Failed to resolve IP address."
fi

echo -e "\n[+] Enumeration completed."

