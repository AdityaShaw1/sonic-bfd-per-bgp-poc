#!/bin/bash

echo "🔍 Checking BFD and BGP Session Status on SONiC..."

# Check BFD Peers
echo -e "\n--- BFD Peers ---"
docker exec -it bgp vtysh -c "show bfd peers"

# Check BGP Summary
echo -e "\n--- BGP Summary ---"
docker exec -it bgp vtysh -c "show ip bgp summary"

echo -e "\n✅ BFD and BGP status check completed."
