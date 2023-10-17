---
draft: false 
date: 2023-10-17
slug: cloudflare-cname
---

# Cоздание новой DNS-записи CNAME на Cloudflare

Я рекомендую получить собственное доменное имя, указывающее на IP-адрес вашего дома в глобальной сети. Частное доменное имя через reg.ru будет стоить 850 рублей в год. Есть несколько причин, почему я рекомендую это:

-   В моем тестировании я никогда не мог заставить некоторые контейнеры докеров работать в качестве подкаталога (даже на моем собственном частном доменном имени) за обратным прокси-сервером Traefik. В таких ситуациях вам останется создать несколько динамических субдоменов DNS, чтобы разместить все ваши службы. Большинство бесплатных динамических DNS-сервисов ограничивают количество субдоменов, которые вы можете создать.
-   Afraid DNS не является одним из поддерживаемых поставщиков wildcard сертификатов. Хотя DuckDNS указан как поддерживаемый, он еще не тестировался.

В моей настройке использую собственное доменное имя, все мои приложения в качестве отдельных хостов и Traefik 2.9 с сертификатами Wildcard. Мой провайдер DNS — Cloudflare, который  [протестирован и подтвержден](https://doc.traefik.io/traefik/v1.7/configuration/acme/#wildcard-domains)  для работы с подстановочными сертификатами Traefik Let’s Encrypt. Если у вас есть собственное доменное имя, а ваш провайдер DNS не указан в списке поддерживаемых, то я рекомендую перенести ваш DNS на Cloudflare, который удивительно быстр и бесплатен.
<!-- more -->
В Cloudflare вы должны указать свой корневой домен (example.com) на свой IP-адрес WAN. Затем добавьте CNAME с подстановочным знаком (*.example.com) или отдельные субдомены, указывающие на ваш корневой домен (@ для хоста), как показано ниже (для этого не требуется платная учетная запись).

[![Cloudflare Dns Entries](https://www.smarthomebeginner.com/images/2018/05/cloudflare-dns-records-screenshot-740x495.png "Traefik Tutorial: Traefik Reverse Proxy with LetsEncrypt for Docker Media Server 3")](https://www.smarthomebeginner.com/images/2018/05/cloudflare-dns-records-screenshot.png)

Cloudflare Dns Entries For Traefik Dns Challenge

In addition to creating the DNS records, you will have to adjust Cloudflares SSL settings to avoid indefinite redirects. Go to **Crypto** settings for the domain and change **SSL** to **Full** as shown below.

[![Cloudflare &Quot;Full&Quot; Ssl](https://www.smarthomebeginner.com/images/2018/05/cloudflare-crypto-full-ssl-740x358.png "Traefik Tutorial: Traefik Reverse Proxy with LetsEncrypt for Docker Media Server 4")](https://www.smarthomebeginner.com/images/2018/05/cloudflare-crypto-full-ssl.png)

Cloudflare “Full” Ssl

Note that you may have to wait for a few minutes for the DNS entries to propagate. If you run Traefik before that, DNS challenge may fail and no SSL certificate will be generated. If you keep trying, [Let’s Encrypt may ban you temporarily](https://letsencrypt.org/docs/rate-limits/) for reaching the request limits. To counter this I have added a 5 min wait in the traefik configuration below but you may need longer. Until validation is complete, Traefik’s default certificate will be used and your browser will throw a warning.