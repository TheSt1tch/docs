# Получение кастомных маршрутов eBGP

Выпускаем трафик BGP с маршрутизатора

```
/ip firewall filter add action=accept chain=output protocol=tcp dst-address=51.75.66.20 dst-port=179 out-interface=site2
```

Прописываем маршрут до сервиса, который содержит маршруты BGP. Это нужно для того, чтобы избежать фильтрации BGP.

```
/ip route add dst-address=51.75.66.20/32 gateway=site2
```

Настраиваем пиринг с сервисом

!!! info "Mikrotik ROS7"

    ```
    /routing bgp template
    add as="64999" disabled=no hold-time=4m input.filter=bgp_in .ignore-as-path-len=yes keepalive-time=1m multihop=yes name=BGP_1 routing-table=main

    /routing bgp connection add as=64999 disabled=no hold-time=4m input.filter=bgp_in .ignore-as-path-len=yes keepalive-time=1m local.address=<local_IP> .role=\
    ebgp multihop=yes name=BGP1 output.filter-chain=discard \
    remote.address=51.75.66.20/32 .as=65444 router-id=<WAN_IP> \
    routing-table=main templates=BGP_1

    /routing filter rule
    add chain=bgp_in disabled=no rule="set gw site2; accept;
    add chain=discard disabled=no rule=reject
    ```