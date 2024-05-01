# Обновление пакета корневых сертификатов CA

Я столкнулся с проблемой, что мой Synology NAS не может получить данные из локального реестра Docker:

```
docker: Error response from daemon: Get "https://redacted-local-hostname.net/v2/": x509: certificate has expired or is not yet valid 
```

Оказывается, мой Synology не получает последние корневые сертификаты CA. Я обнаружил это, пытаясь скачать докер образ. Каждый раз выходила ошибка. Тогда я решил постучаться куда нить через **curl**.

```bash
curl -I https://st1t.ru  
curl: (60) SSL certificate problem: certificate has expired  
More details here: https://curl.haxx.se/docs/sslcerts.html  
...
```
Исправить оказалось довольно легко. Нужно лишь скачать актуальные корневые сертифиаты. Приведенные ниже команды загружают сертификаты с сайта Curl.se в формате PEM. Перемещаем их туда, где Synology хранит связку CA-сертификатов, перезаписывая его. Мы сделаем резервную копию исходного пакета сертификатов CA с *.backup* расширением на тот случай, если по какой-либо причине вы захотите вернуться.

```bash
cp /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt.backup  
wget --no-check-certificate https://curl.se/ca/cacert.pem  
mv cacert.pem /etc/ssl/certs/ca-certificates.crt  
```

После этого та же команда **curl** начала работать успешно. Однако Docker по-прежнему выдавал ту же ошибку — то есть не получал обновленные корневые сертификаты. Чтобы заставить работать, нужно перезапустить демон Synology Docker:

```bash
synoservice --restart pkgctl-Docker  
```