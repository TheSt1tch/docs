# BGP на RouteOS 7 

```
/routing bgp template
add as="ВАША ВЫДУМАННАЯ AS БЕЗ СКОБОК" disabled=no hold-time=4m input.filter=bgp_in .ignore-as-path-len=yes keepalive-time=1m multihop=yes name=antifilter routing-table=main

/routing bgp connection
add disabled=no hold-time=4m input.filter=bgp_in .ignore-as-path-len=yes keepalive-time=1m local.address= "ВАШ ВНУТРЕННИЙ ИП БЕЗ СКОБОК" .role=ebgp multihop=yes name=antifilter_bgp remote.address=45.154.73.71/32 .as=65432 router-id="ВАШ ВНЕШНИЙ ИП БЕЗ СКОБОК" routing-table=main templates=antifilter

/routing filter rule
add chain=bgp_in disabled=no rule="set gw "название VPN интерфейса"; accept;" 
```