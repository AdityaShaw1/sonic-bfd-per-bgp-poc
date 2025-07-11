# 🔍 Troubleshooting BFD Per BGP Session in SONiC

This guide provides solutions to common issues encountered when enabling BFD per BGP session in SONiC.

---

## ❌ 1. `bfdd is not running`

### 🔎 Symptoms:
- Output of `show bfd peers` says:  

bfdd is not running

### ✅ Fix:
Manually start `bfdd` inside the BGP container:

```bash
docker exec -it bgp bash
/usr/lib/frr/bfdd &
exit

Or check if bfdd is installed under /usr/lib/frr/

❌ 2. No BFD Peers Found

🔎 Symptoms:

show bfd peers returns:

No BFD peers found

✅ Fixes:

1. Check BFD config is applied to the BGP neighbor:
docker exec -it bgp vtysh -c "show running-config"
neighbor 10.0.0.2 bfd

2. Make sure both sides (leaf & spine) have BFD enabled for the neighbor.

3. BFD session needs successful BGP neighbor establishment.

❌ 3. Can't Configure Neighbor in FRR

🔎 Symptoms:

Error in vtysh:
% Can not configure the local system as neighbor

✅ Fix:
router bgp <your_local_asn>

Do not try to configure neighbors in global config mode.

❌ 4. config feature bfdd not available

🔎 Symptoms:

    Running this gives:
    config feature bfdd enabled

Error: Unknown feature: bfdd
✅ Fix:

This means bfdd is not exposed as a configurable feature in this SONiC build.

You must run bfdd manually inside the BGP container as shown above.

❌ 5. BFD Interface Not Working

🔎 Symptoms:

    BFD doesn't come up even if config is correct.

✅ Fix:

    
    Check if the underlay interface (e.g., Ethernet0, eth0) is up and reachable.

Run:

ping <peer-ip>
docker exec -it bgp vtysh -c "show interface"

✅ General Debugging Commands

show ip bgp summary
show bfd peers
docker exec -it bgp bash
docker exec -it bgp vtysh -c "show run"
docker exec -it bgp vtysh -c "show bfd peers"

🛠️ Logs and Daemon Status

Check logs:

docker exec -it bgp cat /var/log/frr/frr.log

Restart FRR inside container:

docker exec -it bgp bash
supervisorctl restart all


