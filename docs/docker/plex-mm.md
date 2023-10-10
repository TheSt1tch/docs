# Plex Meta Managers

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

## Фильмы

??? example "Конфиг файл"

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
    playlist_files:
    - pmm: playlist
    settings:
      cache: true
      cache_expiration: 60
      asset_directory: config/assets
      asset_folders: true
      asset_depth: 0
      create_asset_folders: false
      prioritize_assets: false
      dimensional_asset_rename: false
      download_url_assets: false
      show_missing_season_assets: false
      show_missing_episode_assets: false
      show_asset_not_needed: true
      sync_mode: append
      minimum_items: 1
      default_collection_order:
      delete_below_minimum: true
      delete_not_scheduled: false
      run_again_delay: 2
      missing_only_released: false
      only_filter_missing: false
      show_unmanaged: true
      show_filtered: false
      show_options: false
      show_missing: true
      show_missing_assets: true
      save_report: false
      tvdb_language: rus
      ignore_ids:
      ignore_imdb_ids:
      item_refresh_delay: 0
      playlist_sync_to_user: all
      playlist_report: false
      verify_ssl: true
      custom_repo:
      check_nightly: false
      show_unconfigured: true
      playlist_exclude_users:
    webhooks:                                       # Can be individually specified per library as well
      error:
      version:
      run_start:
      run_end:
      changes:
      delete:
    plex:                                           # Can be individually specified per library as well; REQUIRED for the script to run
      url: http://
      token: token
      timeout: 60
      clean_bundles: false
      empty_trash: false
      optimize: false
    tmdb:                                           # REQUIRED for the script to run
      apikey: api
      language: ru
      cache_expiration: 60
      region:
    trakt:
      client_id: id
      client_secret: secret
      pin: pin
      authorization:
        # everything below is autofilled by the script
        access_token:
        token_type:
        expires_in:
        refresh_token:
        scope: public
        created_at:
    ```

## Сериалы

??? example "Конфиг файл"

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
        - pmm: ratings                                                       # 3, 4
          template_variables:
            rating1: audience
            rating1_image: trakt
            horizontal_position: right                                     # the set of ratings is on the right of the poster
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