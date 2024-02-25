# OpenWrt Install Notes

This document captures my notes I took when installing OpenWrt on Turris Omnia (original version) router from CZ.NIC.

## Initial State

This guide starts at initial state of fresh OpenWrt installation. The process of flashing the OpenWrt on Turris Omnia is described at https://openwrt.org/toh/turris/turris_omnia.

**It's important to update Update U-Boot to 2019.07 or later** before flashing OpenWrt as described at https://openwrt.org/toh/turris/turris_omnia#update_u-boot_if_needed.

When running OpenWrt already, it's possible to return to the original state by ... jfss

## First setup

### Set root password

Password login will be disabled later.
```
# passwd
```

### Connect to internet (PPPoE)

```
# PPPOE_USERNAME='<your PPPoE username>'
# PPPOE_PASSWORD='<your PPPoE password>'
# uci set network.wan.proto="pppoe"
# uci set network.wan.username="$PPPOE_USERNAME"
# uci set network.wan.password="$PPPOE_PASSWORD"
# uci changes network
# uci commit network
```

