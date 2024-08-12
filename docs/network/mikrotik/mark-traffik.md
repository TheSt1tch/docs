# Маркировка траффика

Сделаем Policy-based Routing (PBR) - маршрутизация на основе определенных политик (правил, условий), которые являются относительно гибкими и устанавливаются Администратором. Другими словами это технология предоставляет условия гибкой маршрутизации (если смотреть на технологию с первоочередной ее задачи), по источнику или назначению пакета.

Формируем списки (`address-list`) для адресов или подсетей:
```
# auth.servarr.com - ресурс, у которого меняем маршрут
/ip firewall address-list add list=PBR address=auth.servarr.com
```

Создаем таблицу маршрутизации

```
/routing table
add Disabled=no name=PBR fib
```
Настраиваем правила роутинга

```
/ip firewall mangle add disabled=no action=mark-routing chain=prerouting dst-address-list=PBR new-routing-mark=PBR passthrough=yes src-address=192.168.88.2-192.168.88.254
/ip route add disabled=no dst-address=0.0.0.0/0 type=unicast gateway=site2 routing-mark=PBR scope=30 target-scope=10
/ip firewall nat add chain=srcnat src-address=192.168.88.0/24 out-interface=site2 action=masquerade
```