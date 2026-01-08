#!/bin/sh

uci set firewall.blocktv.enabled='0'
uci commit firewall
/etc/init.d/firewall reload
echo "[$(date)] TV access allowed (blocking disabled)" | tee -a "/root/tv.log"
