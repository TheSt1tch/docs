# Pictshare - свой хостинг для картинок, гифок, видяшек и документов. 

[![](https://img.shields.io/docker/pulls/hascheksolutions/pictshare?color=brightgreen)](https://hub.docker.com/r/hascheksolutions/pictshare)
[![Apache License](https://img.shields.io/badge/license-Apache-brightgreen.svg?style=flat)](https://github.com/HaschekSolutions/pictshare/blob/master/LICENSE)
[![](https://img.shields.io/github/stars/HaschekSolutions/pictshare.svg?label=Stars&style=social)](https://github.com/HaschekSolutions/pictshare)

Таких сервисов много, это лиш один из них. Позводяет захостить у себя сервис по хранению и выдаче различных медия. Аля imgur.

## Запуск

Запуск простой, через docker:

```bash
docker run -d -p 8080:80 --name=pictshare ghcr.io/hascheksolutions/pictshare
```

После, открываем [http://localhost:8080/](http://localhost:8080) в браузере и пользуемся.

## Возможности

- Selfhostable
- [Простая загрузка через API](https://github.com/HaschekSolutions/pictshare/blob/master/rtfm/API.md) 
- Без БД
- [Масштабируемость](https://github.com/HaschekSolutions/pictshare/blob/master/rtfm/SCALING.md)
- Фильтры для картинок
- GIF в MP4 преобразование
- JPG, PNG в WEBP преобразование
- MP4 смена размера
- PictShare удаляет все данные exif, чтобы вы могли загружать фотографии со своего телефона, при этом все теги GPS и информация о модели камеры будут удалены.
- Изменяйте и изменяйте размеры своих изображений и видео, просто отредактировав URL-адрес.
- Дубликаты не занимают места. Если один и тот же файл загружается дважды, вторая загрузка будет связана с первой.
- [Много возможностей для настройки](https://github.com/HaschekSolutions/pictshare/blob/master/rtfm/CONFIG.md)
- Полный контроль над вашими данными. Удаление изображений с индивидуальными и глобальными кодами удаления



[Github](https://github.com/HaschekSolutions/pictshare){ .md-button .md-button--primary }