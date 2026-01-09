# OpenWrt Install Notes

This document captures my notes I took when installing OpenWrt on Turris Omnia (original version) router from CZ.NIC.

## Initial State

This guide starts at initial state of fresh OpenWrt installation. The process of flashing the OpenWrt on Turris Omnia is described at https://openwrt.org/toh/turris/turris_omnia.

**It's important to update Update U-Boot to 2019.07 or later** before flashing OpenWrt as described at https://openwrt.org/toh/turris/turris_omnia#update_u-boot_if_needed.

When running OpenWrt already, it's possible to return to the original state by ... jfss

## First setup

### Set root password

Password SSH login will be disabled later.

```bash
passwd
```

### Connect to internet (PPPoE)

```bash
export PPPOE_USERNAME='<your PPPoE username>'
export PPPOE_PASSWORD='<your PPPoE password>'
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

### Change the IP address

It's useful to not use the default 192.168.1.1 when connecting multiple VPN networks.

```bash
uci set network.lan.ipaddr='192.168.71.1'
uci commit network
/etc/init.d/network restart
```

### Install SSH keys

```bash
cd /etc/dropbear
wget https://public.tkdev.space/authorized_keys
/etc/init.d/network restart
```

### Disable SSH passwords

```bash
uci set dropbear.@dropbear[0].PasswordAuth='off'
uci set dropbear.@dropbear[0].RootPasswordAuth='off'
uci commit dropbear
/etc/init.d/network restart
```

### Set up Wi-Fi

```bash
# 5 GHz
uci set wireless.default_radio0.ssid='tk-wifi-rp-5'
uci set wireless.default_radio0.key='matching salt and pepper shakers'
uci set wireless.default_radio0.encryption='sae-mixed'
uci delete wireless.radio0.disabled
# 2.4 GHz
uci set wireless.default_radio1.ssid='tk-wifi-rp-2.4'
uci set wireless.default_radio1.key='matching salt and pepper shakers'
uci set wireless.default_radio1.encryption='sae-mixed'
uci delete wireless.radio1.disabled
uci commit wireless
/etc/init.d/network restart
```

### TV Blocker

```bash
uci set firewall.blocktv=rule
uci set firewall.blocktv.name='Block-TV'
uci set firewall.blocktv.src='lan'
uci set firewall.blocktv.src_mac='58:FD:B1:EF:8A:A0'
uci set firewall.blocktv.dest='wan'
uci set firewall.blocktv.target='REJECT'
uci set firewall.blocktv.enabled='1'
uci commit firewall
/etc/init.d/firewall restart
```