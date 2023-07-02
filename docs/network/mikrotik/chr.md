# Cloud Hosted Router

У MikroTik CHR статический IP

```plaintext
/ip address add interface=ether1 address=10.103.0.111 netmask=255.255.255.0
/ip route add gateway=10.103.0.254 dst-address=0.0.0.0/0 distance=1
```

У MikroTik CHR автоматический IP(dhcp)

```plaintext
/ip dhcp-client add disabled=no interface=ether1
```