# Полезные команды

## Диски

**Дата и температура дисков**

```plaintext
date && hddtemp /dev/sda /dev/sdb /dev/sdd /dev/sde
```

где `/dev/sda /dev/sdb /dev/sdd /dev/sde` - список дисков

**Просмотр SMART диска**

```plaintext
smartctl -a /dev/sda
```

## Plex

**Добавление сертификата LetsEncrypt в Plex**

Для тех случаев, если Plex работает не через обратный прокси

```plaintext
openssl pkcs12 -export -out ~/certificate.pfx -inkey /etc/letsencrypt/live/example.com/privkey.pem -in /etc/letsencrypt/live/example.com/cert.pem -certfile /etc/letsencrypt/live/example.com/chain.pem
```

вводим пароль для импорта, после перемещаем в каталог с установленным Plex

```plaintext
mv ~/certificate.pfx /var/lib/plexmediaserver
```

Задаем права

```plaintext
chown plex:plex /var/lib/plexmediaserver/certificate.pfx
```

Рестартим Apache и Plex

```plaintext
service apache2 restart
service plexmediaserver restart
```