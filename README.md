# 🚀 PoC: Add BFD Support on Per BGP Session in SONiC

## 📌 Objective

Enable and test Bidirectional Forwarding Detection (BFD) **on a per-BGP session basis** in the SONiC NOS using NVIDIA Air.

---

## 🧰 Prerequisites

- NVIDIA Air access
- 2 SONiC VMs or leaf-spine setup
- Working `sonic-buildimage`
- Basic Docker and FRR knowledge

---

## 🏗️ Step-by-Step Setup

### Step 1: Clone SONiC build image

```bash
git clone https://github.com/sonic-net/sonic-buildimage.git
cd sonic-buildimage
make init
make configure PLATFORM=generic

### Step 2: Boot SONiC in NVIDIA Air (or your test lab)

Refer to NVIDIA Air documentation to spin up 2 SONiC devices.

### Step 3: Enable BFD Support (Per BGP Session)

🔧 Step 3.1: On Leaf (65001)

sudo vtysh
conf t
router bgp 65001
  neighbor 10.0.0.2 remote-as 65002
  neighbor 10.0.0.2 bfd
  network 10.0.0.1/32
exit
bfd
 peer 10.0.0.2
  no shutdown
  desired-min-tx 300
  required-min-rx 300
  detect-multiplier 3
exit
end
write

🔧 Step 3.2: On Spine (65002)

sudo vtysh
conf t
router bgp 65002
  neighbor 10.0.0.1 remote-as 65001
  neighbor 10.0.0.1 bfd
  network 10.0.0.2/32
exit
bfd
 peer 10.0.0.1
  no shutdown
  desired-min-tx 300
  required-min-rx 300
  detect-multiplier 3
exit
end
write

✅ Verification Commands (Run on both Leaf and Spine)

BFD Status
docker exec -it bgp vtysh -c "show bfd peers"

Expected output:
BFD Peers:
Peer 10.0.0.2, state: up, TX interval: 300 ms, RX interval: 300 ms

BGP Summary
docker exec -it bgp vtysh -c "show ip bgp summary"

💥 If bfdd is not running:

docker exec -it bgp bash
/usr/lib/frr/bfdd &

Step 4: Validate BFD Status

docker exec -it bgp vtysh -c "show bfd peers"

⚠️ Common Errors & Fixes

| Problem                  | Error Message                                      | Solution                                                                                        |
| ------------------------ | -------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| BFD not running          | `bfdd is not running`                              | Run `bfdd` inside bgp container manually OR check if `bfdd` is installed.                       |
| No BFD session           | `No BFD peers found`                               | Check `neighbor <ip> bfd` line in FRR config.                                                   |
| Feature not found        | `config feature bfdd` not available                | This means `bfdd` is not integrated into your SONiC build. Use `bfdd` from `/usr/lib/frr/bfdd`. |
| Can’t configure neighbor | `% Can not configure the local system as neighbor` | Ensure `router bgp` is entered with the correct ASN before setting neighbors.                   |

🗂 Sample Configs

    See configs/ folder for:

    bgp_config.json

    bfdd_config.json

🧪 Test Commands

show ip bgp summary
show bfd peers
docker exec -it bgp vtysh -c "show bfd peers"


🤝 Credits

    SONiC GitHub

    NVIDIA Air

