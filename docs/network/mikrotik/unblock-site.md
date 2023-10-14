# Обход блокировок

Расписывать как поднять и настроить VPN через Wireguard или OpenVPN не буду. В сети достаточно инструкций. Чуть ниже слева есть еще одна от меня.

Варианта как обходить блокировки 2:

- через таблицу маршрутизации, куда вносим ресурсы руками или скриптами
- через BGP с одного "неизвестного" сайта

## Вариант 1: таблица маршрутизации

Статья о маркировке трафика, для отправки его в VPN: [Policy_Base_Routing](https://wiki.mikrotik.com/wiki/Policy_Base_Routing)

Формируем списки (`address-list`) для подсетей, трафик на которые будем гнать через VPN:
```
# auth.servarr.com - заблоченный ресурс
/ip firewall address-list add list=unblock address=auth.servarr.com
```
Вместо формирования руками, готовые списки можно выкачивать с [https://antifilter.download](https://antifilter.download)

Создаем таблицу маршрутизации

```
/routing table
add Disabled=no name=unblock fib
```
Настраиваем правила роутинга

```
/ip firewall mangle add disabled=no action=mark-routing chain=prerouting dst-address-list=unblock new-routing-mark=unblock passthrough=yes src-address=192.168.88.2-192.168.88.254
/ip route add disabled=no dst-address=0.0.0.0/0 type=unicast gateway=wireguard1 routing-mark=unblock scope=30 target-scope=10
/ip firewall nat add chain=srcnat src-address=192.168.88.0/24 out-interface=wireguard1 action=masquerade
```

## Вариант 2: BGP 

Проверяем, что VPN жив и работает. 

Выпускаем трафик BGP с маршрутизатора

```
/ip firewall filter add action=accept chain=output protocol=tcp dst-address=51.75.66.20 dst-port=179 out-interface=wireguard1
```

Прописываем маршрут до сервиса antifilter.network через VPN. Это нужно для того, чтобы если провайдер блочит или фильтрует BGP, на нас это не влияло.

```
/ip route add dst-address=51.75.66.20/32 gateway=wireguard1
```

Настраиваем пиринг с сервисом

!!! info "Mikrotik ROS7"

    ```
    /routing bgp template
    add as="64999" disabled=no hold-time=4m input.filter=bgp_in .ignore-as-path-len=yes keepalive-time=1m multihop=yes name=antifilter routing-table=main

    /routing bgp connection
    add as=64999 disabled=no hold-time=4m input.filter=bgp_in \
    .ignore-as-path-len=yes keepalive-time=1m local.address=<local_IP> .role=\
    ebgp multihop=yes name=bgp-antifilter.net output.filter-chain=discard \
    remote.address=51.75.66.20/32 .as=65444 router-id=<WAN_IP> \
    routing-table=main templates=antifilter

    /routing filter rule
    add chain=bgp_in disabled=no rule="set gw wireguard1; accept;
    add chain=discard disabled=no rule=reject
    ```