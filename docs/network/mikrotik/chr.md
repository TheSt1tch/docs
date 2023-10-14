# Cloud Hosted Router

## Установка IP адреса

=== "У MikroTik CHR статический IP"

    ```
    /ip address add interface=ether1 address=10.103.0.111 netmask=255.255.255.0
    /ip route add gateway=10.103.0.254 dst-address=0.0.0.0/0 distance=1
    ```

=== "У MikroTik CHR автоматический IP(dhcp)"

    ```
    /ip dhcp-client add disabled=no interface=ether1
    ```

## Настройка NTP

```
/system ntp client
set enabled=yes
/system ntp client servers
add address=193.171.23.163
add address=85.114.26.194
```

## Настройка Firewall

=== "Filter"

    ```
    /ip firewall filter
    add action=accept chain=input dst-port=22024,29514 in-interface=ether1 \
        protocol=tcp src-address-list=Admin_IP
    add action=accept chain=input comment="VPN Wireguard" dst-port=34567 \
        in-interface=ether1 protocol=udp
    add action=accept chain=input dst-port=34568 in-interface=ether1 protocol=udp \
        src-address=5.189.70.251
    add action=accept chain=input dst-port=34569 in-interface=ether1 protocol=udp
    add action=accept chain=input comment=l2tp port=1701,500,4500 protocol=udp \
        src-address=95.59.244.153
    add action=accept chain=input protocol=ipsec-esp
    add action=accept chain=input comment=Socks5 dst-port=24444 \
        in-interface-list=VPN protocol=tcp
    add action=drop chain=input dst-port=24444 in-interface-list=!VPN protocol=\
        tcp
    add action=accept chain=input comment="Web Proxy" dst-port=25555 \
        in-interface-list=VPN log=yes log-prefix=webproxy protocol=tcp
    add action=drop chain=input connection-state="" dst-port=8080 \
        in-interface-list=!VPN port="" protocol=tcp src-port=""
    add action=drop chain=input connection-state="" dst-port=25555 \
        in-interface-list=!VPN port="" protocol=tcp src-port=""
    add action=return chain=detect-ddos comment="Anti DDos" dst-limit=\
        32,32,src-and-dst-addresses/10s
    add action=add-dst-to-address-list address-list=ddos-target \
        address-list-timeout=10m chain=detect-ddos
    add action=add-src-to-address-list address-list=ddos-attackers \
        address-list-timeout=10m chain=detect-ddos
    add action=return chain=detect-ddos dst-limit=32,32,src-and-dst-addresses/10s \
        protocol=tcp tcp-flags=syn,ack
    add action=fasttrack-connection chain=forward comment=" fasttrack" \
        connection-state=established,related hw-offload=yes
    add action=accept chain=input comment="\D0\E0\E7\F0\E5\F8\E0\E5\EC \F3\F1\F2\
        \E0\ED\EE\E2\EB\E5\ED\ED\FB\E5 \E8 \F1\E2\FF\E7\E0\ED\ED\FB\E5 \E2\F5\EE\
        \E4\F9\E8\E5 \F1\EE\E5\E4\E8\ED\E5\ED\E8\FF" connection-state=\
        established,related,untracked
    add action=accept chain=forward connection-state=\
        established,related,untracked
    add action=drop chain=input comment="Drop invalid" connection-state=invalid \
        log-prefix=invalid
    add action=drop chain=forward connection-state=invalid log-prefix=invalid
    add action=drop chain=input connection-state="" dst-port=53 \
        in-interface-list=WAN port="" protocol=udp src-port=""
    add action=drop chain=input comment=NTP connection-state=new dst-port=123 \
        in-interface-list=WAN log-prefix=" " protocol=tcp
    add action=drop chain=input connection-state=new dst-port=123 \
        in-interface-list=WAN log-prefix=" " protocol=udp
    add action=drop chain=input comment="Drop SSH brutforce" dst-port=22-23 \
        protocol=tcp
    add action=accept chain=input comment="defconf: accept ICMP after RAW" \
        protocol=icmp
    add action=accept chain=input comment="\F0\E0\E7\F0\E5\F8\E0\E5\EC \EF\EE\E4\
        \EA\EB\FE\F7\E5\ED\E8\FF \E8\E7 \ED\E0\F8\E5\E9 \EB\EE\EA \F1\E5\F2\E8" \
        in-interface=!ether1 src-address=192.168.3.0/24
    add action=drop chain=forward comment=\
        "defconf:  drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
        connection-state=new in-interface-list=WAN
    add action=drop chain=forward comment="defconf: drop bad forward IPs" \
        dst-address-list=no_forward_ipv4
    add action=drop chain=forward comment="defconf: drop bad forward IPs" \
        src-address-list=no_forward_ipv4
    add action=drop chain=input comment="defconf: drop all not coming from LAN" \
        in-interface-list=!VPN log-prefix=drop
    ```

=== "NAT"
    ```
    /ip firewall nat
    add action=masquerade chain=srcnat
    add action=masquerade chain=srcnat out-interface=ether1 src-address=\
    192.168.3.1
    ```

=== "RAW"
    ```
    /ip firewall raw
    add action=accept chain=prerouting comment=\
        "defconf: enable for transparent firewall" disabled=yes
    add action=accept chain=prerouting comment="defconf: accept DHCP discover" \
        dst-address=255.255.255.255 dst-port=67 in-interface-list=LAN protocol=\
        udp src-address=0.0.0.0 src-port=68
    add action=drop chain=prerouting comment="defconf: drop bogon IP's" \
        src-address-list=bad_ipv4
    add action=drop chain=prerouting comment="defconf: drop bogon IP's" disabled=\
        yes dst-address-list=bad_ipv4 log=yes log-prefix=132
    add action=drop chain=prerouting comment="defconf: drop bogon IP's" \
        src-address-list=bad_src_ipv4
    add action=drop chain=prerouting comment="defconf: drop bogon IP's" disabled=\
        yes dst-address-list=bad_dst_ipv4 log=yes
    add action=drop chain=prerouting comment="defconf: drop non global from WAN" \
        in-interface=ether1 src-address-list=not_global_ipv4
    add action=drop chain=prerouting comment=\
        "defconf: drop forward to local lan from WAN" dst-address=192.168.1.0/24 \
        in-interface-list=WAN
    add action=drop chain=prerouting comment=\
        "defconf: drop local if not from default IP range" in-interface-list=LAN \
        log=yes src-address=!192.168.3.0/24
    add action=drop chain=prerouting comment="defconf: drop bad UDP" log-prefix=\
        123 port=0 protocol=udp
    add action=jump chain=prerouting comment="defconf: jump to ICMP chain" \
        jump-target=icmp4 protocol=icmp
    add action=jump chain=prerouting comment="defconf: jump to TCP chain" \
        jump-target=bad_tcp protocol=tcp
    add action=accept chain=prerouting comment=\
        "defconf: accept everything else from LAN" in-interface-list=VPN
    add action=accept chain=prerouting comment=\
        "defconf: accept everything else from WAN" in-interface-list=WAN
    add action=drop chain=bad_tcp comment="defconf: TCP flag filter" protocol=tcp \
        tcp-flags=!fin,!syn,!rst,!ack
    add action=drop chain=bad_tcp comment=defconf protocol=tcp tcp-flags=fin,syn
    add action=drop chain=bad_tcp comment=defconf protocol=tcp tcp-flags=fin,rst
    add action=drop chain=bad_tcp comment=defconf protocol=tcp tcp-flags=fin,!ack
    add action=drop chain=bad_tcp comment=defconf protocol=tcp tcp-flags=fin,urg
    add action=drop chain=bad_tcp comment=defconf protocol=tcp tcp-flags=syn,rst
    add action=drop chain=bad_tcp comment=defconf protocol=tcp tcp-flags=rst,urg
    add action=drop chain=bad_tcp comment="defconf: TCP port 0 drop" port=0 \
        protocol=tcp
    ```

=== "Address List"

    ```
    /ip firewall address-list
    add address=192.168.1.2-192.168.88.254 list=allowed_to_router
    add address=0.0.0.0/8 comment="defconf: RFC6890" list=no_forward_ipv4
    add address=169.254.0.0/16 comment="defconf: RFC6890" list=no_forward_ipv4
    add address=224.0.0.0/4 comment="defconf: multicast" list=no_forward_ipv4
    add address=255.255.255.255 comment="defconf: RFC6890" list=no_forward_ipv4
    add address=127.0.0.0/8 comment="defconf: RFC6890" list=bad_ipv4
    add address=192.0.0.0/24 comment="defconf: RFC6890" list=bad_ipv4
    add address=192.0.2.0/24 comment="defconf: RFC6890 documentation" list=\
        bad_ipv4
    add address=198.51.100.0/24 comment="defconf: RFC6890 documentation" list=\
        bad_ipv4
    add address=203.0.113.0/24 comment="defconf: RFC6890 documentation" list=\
        bad_ipv4
    add address=240.0.0.0/4 comment="defconf: RFC6890 reserved" list=bad_ipv4
    add address=0.0.0.0/8 comment="defconf: RFC6890" list=not_global_ipv4
    add address=10.0.0.0/8 comment="defconf: RFC6890" list=not_global_ipv4
    add address=100.64.0.0/10 comment="defconf: RFC6890" list=not_global_ipv4
    add address=169.254.0.0/16 comment="defconf: RFC6890" list=not_global_ipv4
    add address=172.16.0.0/12 comment="defconf: RFC6890" list=not_global_ipv4
    add address=192.0.0.0/29 comment="defconf: RFC6890" list=not_global_ipv4
    add address=192.168.0.0/16 comment="defconf: RFC6890" list=not_global_ipv4
    add address=198.18.0.0/15 comment="defconf: RFC6890 benchmark" list=\
        not_global_ipv4
    add address=255.255.255.255 comment="defconf: RFC6890" list=not_global_ipv4
    add address=224.0.0.0/4 comment="defconf: multicast" list=bad_src_ipv4
    add address=255.255.255.255 comment="defconf: RFC6890" list=bad_src_ipv4
    add address=0.0.0.0/8 comment="defconf: RFC6890" list=bad_dst_ipv4
    add address=224.0.0.0/4 comment="defconf: RFC6890" list=bad_dst_ipv4
    add list=ddos-attackers
    add list=ddos-target
    add address=5.189.70.251 list=Admin_IP
    add address=10.0.10.2 list=Admin_IP
    add address=95.59.244.153 list=Admin_IP
    ```