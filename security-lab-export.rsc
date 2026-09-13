# 2026-09-13 12:58:01 by RouterOS 7v
# software id = UMI8-E5JM
#
# model = E50UG
# serial number = *******
/disk
add parent=usb1 partition-number=1 partition-offset=1048576 partition-size=\
    500105740288 type=partition
/interface bridge
add fast-forward=no mtu=1500 name=bridge1
/interface list
add name=WAN
add name=LAN
/ip pool
add name=dhcp_pool ranges=192.168.88.10-192.168.88.254
/ip dhcp-server
add address-pool=dhcp_pool interface=bridge1 lease-time=1d name=dhcp1
/queue type
add fq-codel-limit=1000 fq-codel-memlimit=4096.0KiB kind=fq-codel name=\
    my_fq_codel
/queue simple
add disabled=yes max-limit=4M/29M name=Bufferbloat-Fix queue=\
    my_fq_codel/my_fq_codel target=bridge1
/queue tree
add max-limit=32M name=Down_total parent=bridge1 priority=1 queue=\
    pcq-download-default
add max-limit=5200k name=Up_total parent=global priority=2 queue=\
    pcq-upload-default
add disabled=yes limit-at=27M max-limit=29M name=GFN-Download packet-mark=\
    geforce-now-traffic parent=global priority=1 queue=my_fq_codel
add disabled=yes limit-at=3M max-limit=4M name=GFN-Upload packet-mark=\
    geforce-now-traffic parent=global priority=2 queue=my_fq_codel
add max-limit=29M name=Web_down packet-mark=Web_down parent=Down_total \
    priority=3 queue=my_fq_codel
add max-limit=4600k name=Web_up packet-mark=Web_up parent=Up_total priority=4 \
    queue=my_fq_codel
/certificate settings
set crl-download=yes
/container config
set tmpdir=/disk1/tmp
/interface bridge port
add bridge=bridge1 hw=no interface=ether2
add bridge=bridge1 interface=ether3
add bridge=bridge1 interface=ether4
add bridge=bridge1 interface=ether5
/interface bridge settings
set allow-fast-path=no use-ip-firewall=yes
/ip firewall connection tracking
set tcp-close-wait-timeout=1m
/ip neighbor discovery-settings
set discover-interface-list=all
/ip settings
set tcp-syncookies=yes
/ipv6 settings
set accept-redirects=no accept-router-advertisements=yes \
    accept-router-advertisements-on=WAN allow-fast-path=no
/interface list member
add interface=ether1 list=WAN
add interface=ether2 list=LAN
add interface=ether3 list=LAN
add interface=ether4 list=LAN
add interface=ether5 list=LAN
add interface=bridge1 list=LAN
/ip address
add address=192.168.88.1/24 interface=ether2 network=192.168.88.0
add address=192.168.88.1/24 interface=bridge1 network=192.168.88.0
add address=172.17.0.1/24 interface=*8 network=172.17.0.0
/ip dhcp-client
add interface=ether1 name=client1 use-peer-dns=no
/ip dhcp-server lease
add address=192.168.88.33 client-id=1:f8:e4:3b:5a:5e:5f mac-address=\
    AA:BB:CC:DD:EE:FF server=dhcp1
/ip dhcp-server network
add address=192.168.88.0/24 gateway=192.168.88.1
/ip dns
set allow-remote-requests=yes max-concurrent-queries=500 \
    max-concurrent-tcp-sessions=100 servers=1.1.1.1,1.0.0.1
/ip dns static
add address=1.1.1.1 name=Cloudflare type=A
add address=1.0.0.1 name=Cloudflare2 type=A
/ip firewall address-list
add list=ddos-attackers
add list=ddos-targets
add address=95.211.91.87 list=blacklist
/ip firewall filter
add action=accept chain=output protocol=icmp
add action=fasttrack-connection chain=forward connection-state=\
    established,related disabled=yes
add action=accept chain=forward comment="Allow Established Replies" \
    connection-state=established,related
add action=accept chain=input connection-state=established,related
add action=accept chain=input comment="ALLOW: Local Admin Access" \
    connection-state="" in-interface-list=LAN src-address=192.168.88.0/24
add action=drop chain=forward comment="DROP: Malformed packets to LAN" \
    connection-state=invalid
add action=drop chain=forward comment="Block Outbound Spam (Port 25)" \
    dst-port=25 out-interface=ether1 protocol=tcp
add action=accept chain=forward comment=\
    "ALLOW: Traffic requested by LAN devices" connection-state=new \
    in-interface-list=LAN out-interface-list=WAN
add action=drop chain=input comment="WALL: Global Drop all other WAN traffic" \
    in-interface-list=WAN
add action=drop chain=forward comment="WALL: Drop unsolicited WAN to LAN" \
    connection-nat-state=!dstnat in-interface-list=WAN
/ip firewall mangle
add action=mark-connection chain=prerouting new-connection-mark=ICMP_conn \
    protocol=icmp
add action=mark-packet chain=prerouting connection-mark=ICMP_conn \
    in-interface=bridge1 new-packet-mark=ICMP_Up passthrough=no
add action=mark-packet chain=prerouting connection-mark=ICMP_conn \
    in-interface=ether1 new-packet-mark=ICMP_Down passthrough=no
add action=mark-packet chain=prerouting comment="GeForce NOW - Stream Data" \
    disabled=yes dst-port=10000-20000 new-packet-mark=geforce-now-traffic \
    passthrough=no protocol=udp
add action=mark-packet chain=prerouting comment=\
    "GeForce NOW - Stream Control" disabled=yes dst-port=5004 \
    new-packet-mark=geforce-now-traffic passthrough=no protocol=udp
add action=mark-packet chain=prerouting comment="GFN Incoming Video Stream" \
    disabled=yes new-packet-mark=geforce-now-traffic passthrough=no protocol=\
    udp src-port=10000-20000
add action=mark-connection chain=prerouting comment="Web Browsing" dst-port=\
    80,443 new-connection-mark=Web_conn protocol=tcp tcp-flags=syn tcp-mss=\
    1411-65535
add action=mark-connection chain=prerouting dst-port=80,443 \
    new-connection-mark=Web_conn protocol=udp
add action=mark-packet chain=prerouting connection-mark=Web_conn \
    in-interface=bridge1 new-packet-mark=Web_up passthrough=no
add action=mark-packet chain=prerouting connection-mark=Web_conn \
    in-interface=ether1 new-packet-mark=Web_down passthrough=no
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1 src-address=\
    192.168.88.0/24
/ip firewall raw
add action=add-src-to-address-list address-list=Honeypot_Attackers \
    address-list-timeout=1d chain=prerouting comment=\
    "HONEYPOT: Catch and blacklist port scanners" dst-port=22,23,3389,8080 \
    in-interface-list=WAN protocol=tcp
add action=drop chain=prerouting comment=\
    "HONEYPOT: Drop all traffic from blacklisted IPs" src-address-list=\
    Honeypot_Attackers
/ip firewall service-port
set sip disabled=yes
/ip service
set ftp disabled=yes
set ssh disabled=yes
set telnet disabled=yes
set www disabled=yes
set winbox available-from=192.168.88.0/24 port=*****
set api disabled=yes
set api-ssl disabled=yes
/ipv6 address
# address pool error: pool not found: fe80::xxxx:xxxx:xxxx:xxxx/64 (4)
add address=::1 from-pool=fe80::xxxx:xxxx:xxxx:xxxx/64 interface=bridge1
/ipv6 dhcp-client
add allow-reconfigure=yes interface=ether1 pool-name=ipv6pool \
    pool-prefix-length=64 request=prefix use-interface-duid=yes use-peer-dns=\
    no
/ipv6 firewall filter
add action=accept chain=input comment="ALLOW: Local IPv6 Admin Access" \
    src-address=fe80::/10
add action=drop chain=input comment="Block external scans"
add action=accept chain=input comment="Allow return traffic to router" \
    connection-state=established,related
add action=accept chain=input comment="REQUIRED: IPv6 depends on this" \
    protocol=icmpv6
add action=drop chain=input comment="BLOCK: IPv6 DNS from WAN (UDP)" \
    dst-port=53 in-interface=ether1 protocol=udp
add action=drop chain=input comment="BLOCK: IPv6 DNS from WAN (TCP)" \
    dst-port=53 in-interface=ether1 protocol=tcp
add action=accept chain=input comment="REQUIRED: DHCPv6 Client for ISP router" \
    port=546 protocol=udp
add action=accept chain=forward comment="Accept your device traffic" \
    connection-state=established,related in-interface=bridge1 out-interface=\
    ether1
add action=accept chain=forward comment="Required for MTU Discovery" \
    protocol=icmpv6
add action=drop chain=forward comment="Drop all external to Mac/iPad/iPhones" \
    in-interface=ether1
/ipv6 firewall mangle
add action=change-mss chain=forward comment="Fix IPv6 Timeouts" new-mss=\
    clamp-to-pmtu protocol=tcp tcp-flags=syn
/ipv6 nd
set [ find default=yes ] interface=bridge1 managed-address-configuration=yes \
    other-configuration=yes
/system clock
set time-zone-name=[**TimeZone]
/system identity
set name=MicroTech
/system logging
set 0 action=disk
/system ntp client
set enabled=yes
/system ntp client servers
add address=0.pool.ntp.org
add address=1.pool.ntp.org
add address=162.159.200.1
add address=216.239.35.0
/tool mac-server mac-winbox
set allowed-interface-list=LAN
/tool sniffer
set filter-interface=ether1 filter-stream=yes memory-limit=1000KiB \
    streaming-enabled=yes streaming-server=192.168.*.*
