## Получить SSL-сертификат

[https://letsencrypt.org/](https://letsencrypt.org/) - бесплатно, обновляется автоматически (раз в 3 месяца), срок действия не ограничен

[https://github.com/Neilpang/acme.sh](https://github.com/Neilpang/acme.sh) - An ACME Shell script

[https://www.globalsign.com/ssl/ssl-open-source/](https://www.globalsign.com/ssl/ssl-open-source/) - бесплатные сертификаты для некоммерческих целей

## Настройка сервера

Покажу пример настройки для Let's Encrypt SSL. Запущенный веб сервер с виртуальным хостом сконфигурирован для example.com на порту 80.

обновим все пакеты `apt-get update && apt-get upgrade`

скачаем `certbot-auto` Let’s Encrypt клиент и сохраним в `/usr/sbin` директорию:

```bash
sudo wget https://dl.eff.org/certbot-auto -O /usr/sbin/certbot-auto
sudo chmod a+x /usr/sbin/certbot-auto
```

запросим сертификат

```bash
sudo certbot-auto certonly –standalone -d example.com -d www.example.com
```

проверим сертификат

```bash
cd /etc/letsencrypt/live/example.com
ls
cert.pem chain.pem fullchain.pem privkey.pem
```

## Конфигурация веб сервера {.tabset}

### nginx

```nginx
ssl on; 
ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem; 
ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
```
### Apache

```apache
SSLEngine on
SSLCertificateFile /etc/letsencrypt/live/example.com/cert.pem
SSLCertificateKeyFile /etc/letsencrypt/live/example.com/privkey.pem
SSLCertificateChainFile /etc/letsencrypt/live/example.com/chain.pem
```
Конфигурация автоматического обновления. Добавить в `crontab`:
```crontab
0 2 * * * sudo /usr/sbin/certbot-auto -q renew
```
## Проверка сертификата

[https://sslcheck.globalsign.com](https://sslcheck.globalsign.com/) [https://www.sslshopper.com/ssl-checker.html](https://www.sslshopper.com/ssl-checker.html)

## Domain blacklisted

Если при валидации домена получаете сообщение «Domain Blacklisted. Domain «YOU-DOMAIN.ru» appears on a blacklist. Please try it again or email the Certmaster for further information.» - значит что Google в последние 90 дней находил на сайте вирусы.

Проверить можно тут: [http://www.google.com/safebrowsing/diagnostic?site=YOU-DOMAIN.ru](https://www.google.com/safebrowsing/diagnostic?site=YOU-DOMAIN.ru)