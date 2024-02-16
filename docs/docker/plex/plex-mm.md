# Plex Meta Managers

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/meisnate12/Plex-Meta-Manager?style=plastic)](https://github.com/meisnate12/Plex-Meta-Manager/releases)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/meisnate12/plex-meta-manager?label=docker&sort=semver&style=plastic)](https://hub.docker.com/r/meisnate12/plex-meta-manager)
[![Docker Pulls](https://img.shields.io/docker/pulls/meisnate12/plex-meta-manager?style=plastic)](https://hub.docker.com/r/meisnate12/plex-meta-manager)

[![Reddit](https://img.shields.io/reddit/subreddit-subscribers/PlexMetaManager?color=%2300bc8c&label=r%2FPlexMetaManager&style=plastic)](https://www.reddit.com/r/PlexMetaManager/)

```yaml title="docker-compose.yml"
version: "3.7"
services:
  plexmm:
    image: lscr.io/linuxserver/plex-meta-manager:latest
    container_name: plexmm
    restart: "no"
    security_opt:
      - no-new-privileges:true
    environment:
      TZ: "Asia/Yekaterinburg"
      PUID: 1000
      PGID: 1000
      PMM_CONFIG: /config/config.yml #optional
      PMM_TIME: 03:00 #optional
      PMM_RUN: "True" #optional
      PMM_TEST: "False" #optional
      PMM_NO_MISSING: "False" #optional
    volumes:
      - ./plexmm:/config
```

## Конфиги под разные типы библиотек

=== "Фильмы"

    ```yaml title="./plexmm/config.yml"
    ## This file is a template remove the .template to use the file
    libraries:
      Фильмы:
        metadata_path:
        - file: config/Movies/Genre.yml
        - file: config/Movies/Studio.yml
        - folder: config/Movies/Collections
        - folder: config/Movies/Metadata/Collections
        - pmm: basic
        - pmm: imdb
        - pmm: franchise
        overlay_path:
        - remove_overlays: false
        - reapply_overlay: false
        - pmm: resolution
        - pmm: commonsense
        - pmm: ratings
          template_variables:
            rating1: critic
            rating1_image: imdb
            rating2: audience
            rating2_image: trakt
            rating3: user
            rating3_image: tmdb
            horizontal_position: right
        operations:
          mass_critic_rating_update: imdb
          mass_audience_rating_update: mdb_trakt
          mass_user_rating_update: tmdb
    ```

=== "Сериалы"

    ```yaml title="./plexmm/config.yml"
    libraries:
      Сериалы:
        metadata_path:
        - file: config/TV-Shows/Collections.yml
        - folder: config/TV-Shows/Metadata/Anime
        - folder: config/TV-Shows/Metadata/TV
        - pmm: basic
        - pmm: imdb
        overlay_path:
        - remove_overlays: false
        - reapply_overlay: false
        - pmm: ratings
          template_variables:
            rating1: critic
            rating1_image: imdb
            rating2: audience
            rating2_image: trakt
            rating3: user
            rating3_image: tmdb
            horizontal_position: right
        - pmm: resolution
          template_variables:
            overlay_level: season
        - pmm: resolution
          template_variables:
            overlay_level: episode
        - pmm: ratings # 3, 4
          template_variables:
            rating1: audience
            rating1_image: trakt
            horizontal_position: right # the set of ratings is on the right of the poster
            overlay_level: episode
        - pmm: status
          template_variables:
            font_size: 75
            #font: config/fonts/Juventus-Fans-Bold.ttf
            back_color: "#262626" # darker
            back_width: 1920
            back_height: 125
            horizontal_align: center
            vertical_align: top
            vertical_offset: 0
    ```

## Улучшения

### Статус сериала (TMDB)

В конфиге добавить этот текст для библиотеки, в которой нужно отображение:

```yaml
    - pmm: status
      template_variables:
        text_canceled: Отменен
        text_airing: Идет сезон
        text_returning: Продолжится
        text_ended: Завершен
        font_size: 75
        #back_color: "#262626" # darker
        back_width: 1920
        back_height: 125
        horizontal_align: center
        vertical_align: top
        vertical_offset: 0
```

[Документация](https://metamanager.wiki/en/latest/defaults/overlays/mediastinger.html)