# Module php-imagick in this instance has no SVG support

При использовании официального Nextcloud образа Docker вы увидите сообщение вроде:

![](../images/docker/nextcloud/nextcloud-docker-php-imagick.png)

Чтобы исправить это предупреждение в docker нужно установить пакет `libmagickcore-6.q16-6-extra`:

```bash
docker exec nextcloud apt -y update
docker exec nextcloud apt -y install libmagickcore-6.q16-6-extra
```

После этого предупреждение пропало.

Если мы создадим контейнер заново, это изменение будет потеряно. На мой взгляд, здесь лучше выбрать простое решение и делать это каждый раз при обновлении образа, в отличие от постоянной, но гораздо более трудоемкой процедуры. Такой, как обновление docker-контейнера и возврата к официальному образу.
