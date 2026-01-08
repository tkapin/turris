#!/bin/sh

uci set firewall.blocktv.enabled='1'
uci commit firewall
/etc/init.d/firewall reload
echo "[$(date)] TV access denied (blocking enabled)" | tee -a "/root/tv.log"
