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

```bash
PPPOE_USERNAME='<your PPPoE username>'
PPPOE_PASSWORD='<your PPPoE password>'
uci set network.wan.proto="pppoe"
uci set network.wan.username="$PPPOE_USERNAME"
uci set network.wan.password="$PPPOE_PASSWORD"
uci changes network
uci commit network
/etc/init.d/network restart
```

### Set hostname

```bash
uci show system
uci set system.@system[0].hostname=turris
uci commit system
/etc/init.d/system restart
```

### Install SSH keys

```bash
cd /etc/dropbear
wget https://public.tkdev.space/authorized_keys
/etc/init.d/network restart
```

### Change the IP address

```bash
uci set network.lan.ipaddr='192.168.71.1'
uci commit network
/etc/init.d/network restart
```

### Disable SSH passwords

```bash
uci set dropbear.@dropbear[0].PasswordAuth='off'
uci set dropbear.@dropbear[0].RootPasswordAuth='off'
uci commit dropbear
/etc/init.d/network restart
```