# Docker Networking on OpenWrt

This document describes how to configure OpenWrt firewall to allow LAN clients to access Docker containers running on the router.

## Problem

By default, Docker creates its own zone in OpenWrt firewall, but there's no forwarding rule allowing LAN clients (WiFi/Ethernet devices) to access containers exposed on the router's ports.

### Symptoms

- Container accessible from router itself (`wget http://localhost:8000` works)
- Container NOT accessible from LAN clients (timeout when accessing `http://192.168.72.1:8000`)
- Docker container running with proper port mapping (e.g., `0.0.0.0:8000->8080/tcp`)

## Solution

Add a firewall forwarding rule to allow traffic from LAN zone to Docker zone.

```bash
# Add named forwarding rule
uci set firewall.lan_docker=forwarding
uci set firewall.lan_docker.src='lan'
uci set firewall.lan_docker.dest='docker'
uci commit firewall
/etc/init.d/firewall reload
```

## Verification

```bash
# Check the firewall configuration
uci show firewall.lan_docker

# Should output:
# firewall.lan_docker=forwarding
# firewall.lan_docker.src='lan'
# firewall.lan_docker.dest='docker'

# Test from LAN client
curl http://192.168.72.1:8000
```

## Background

OpenWrt uses UCI-based firewall configuration (fw4 with nftables). The Docker package automatically creates a `docker` zone but doesn't add forwarding rules. This is intentional for security - you must explicitly allow LAN→Docker forwarding.

The solution creates a named forwarding rule `lan_docker` which persists across reboots.
