# Mushroom Cards

## Выпадающий список к карточке

Объединение нескольких карточек, для управления подсветкой ТВ и медиаплеером

![](https://community-assets.home-assistant.io/original/4X/6/0/0/6002f8a3af520e53d3f95f8bb5e061c1bd4d1554.gif)

??? tip "Пример"

    ```yaml
    type: custom:stack-in-card
    cards:
      - type: custom:layout-card
        layout_type: custom:grid-layout
        layout:
          grid-template-columns: auto 20px
          margin: '-4px -4px -8px -4px'
        cards:
          - type: custom:mushroom-media-player-card
            entity: media_player.shield_universal
            name: Shield TV
            icon: mdi:play
            use_media_info: true
            use_media_artwork: false
            show_volume_level: true
            media_controls:
              - on_off
              - play_pause_stop
              - previous
              - next
            volume_controls:
              - volume_set
              - volume_mute
            fill_container: true
            card_mod:
              style: |
                mushroom-shape-icon {
                  {% set media_type = state_attr(config.entity, 'media_content_type') %}
                  --card-mod-icon: 
                  {% if media_type == 'tvshow' %}
                    mdi:television-classic
                  {% elif media_type == 'movie' %}
                    mdi:movie-open
                  {% elif media_type == 'music' %}
                    mdi:music
                  {% elif media_type == 'playlist' %}
                    mdi:music
                  {% else %}
                    mdi:play
                  {% endif %};   
                } 
                :host {
                  {% if not is_state(config.entity, 'off') %}
                    background: url( '{{ state_attr(config.entity, "entity_picture") }}' ), linear-gradient(to left, transparent, rgb(var(--rgb-card-background-color)) 50%);
                  {% endif %}  
                  background-size: 50%, 100%;
                  background-position: right;
                  background-repeat: no-repeat;
                  background-blend-mode: lighten;
                }
                :host([dark-mode]) {
                  background-blend-mode: darken;
                }  

                  ha-card {
                    background: none;
                    --ha-card-box-shadow: 0px;
                  }
          - type: custom:mushroom-template-card
            entity: input_boolean.ambilight_dropdown
            primary: ''
            secondary: ''
            icon: >-
              {{ 'mdi:chevron-down' if is_state(entity, 'off') else 'mdi:chevron-up'
              }}
            icon_color: disabled
            hold_action:
              action: none
            card_mod:
              style: |
                ha-card {
                  align-items: flex-end;
                  background: none;
                  --ha-card-box-shadow: 0px;
                }
                mushroom-shape-icon {
                  --shape-color: none !important;
                }  
      - type: conditional
        conditions:
          - entity: input_boolean.ambilight_dropdown
            state: 'on'
        card:
          type: custom:stack-in-card
          cards:
            - type: custom:mushroom-light-card
              entity: light.ambilight_wled
              icon: mdi:television-ambient-light
              name: Ambilight
              layout: horizontal
              show_brightness_control: true
              show_color_temp_control: true
              show_color_control: true
              use_light_color: true
              card_mod:
                style: |
                  ha-card {
                    background: none;
                    --ha-card-box-shadow: 0px;
                  }
    ```
[Ссылка на источник](https://community.home-assistant.io/t/mushroom-cards-build-a-beautiful-dashboard-easily-part-1/388590/2691)
## Pop-Up включенный свет

![](https://community-assets.home-assistant.io/original/4X/0/6/3/063c45de8d627d6f5bf7a091c0077e2db2b11d78.jpeg)

Общий код с карточкой и поп-апом:

??? tip

    ```yaml
    type: grid
    cards:
      - type: heading
        heading: Новый раздел
      - type: vertical-stack
        cards:
          - type: custom:bubble-card
            card_type: pop-up
            hash: "#test"
          - type: custom:mushroom-title-card
            title: "Включенный свет:"
          - type: entity-filter
            entities:
              - light.light_1
              - light.rozetka_11
              - light.light_dim_21
            state_filter:
              - "on"
      - type: custom:mushroom-template-card
        primary: ""
        secondary: >-

          {{expand(state_attr('light.1_light_all', 'entity_id')) |
          selectattr('state','eq','on') | list | count }}
        icon: mdi:town-hall
        tap_action:
          action: navigate
          navigation_path: "#test"
        icon_color: |-
          {% if is_state('light.1_light_all', 'on') %}
            orange
          {% endif %}
        grid_options:
          columns: 3
          rows: 1
    ```

Требуется создать группу на свет и после заменить `1_light_all` на свое название группы

[Ссылка на источник](https://community.home-assistant.io/t/mushroom-cards-build-a-beautiful-dashboard-easily-part-1/388590/1990)

## Климатическая карточка

![](https://community-assets.home-assistant.io/original/4X/e/6/e/e6e9098904e57cacc0fc16ff6080d0d466bce6d8.jpeg)

??? tip

    ```yaml
    type: custom:stack-in-card
    cards:
      - type: custom:mushroom-climate-card
        entity: climate.thermostat_sejour
        hvac_modes:
          - heat
          - auto
          - fan_only
        show_temperature_control: true
        layout: horizontal
        name: Climat
        icon: mdi:thermometer-auto
        double_tap_action:
          action: more-info
      - type: custom:stack-in-card
        cards:
          - type: grid
            square: false
            columns: 2
            cards:
              - type: custom:mushroom-entity-card
                entity: sensor.sonde_salon_temp
                primary_info: state
                secondary_info: name
                name: Temperature
                icon_color: green
              - type: custom:mushroom-entity-card
                entity: sensor.sonde_salon_hum
                primary_info: state
                secondary_info: name
                name: Humidity
                icon: mdi:water-percent
                icon_color: blue
          - type: custom:mini-graph-card
            entities:
              - entity: sensor.sonde_salon_temp
                name: Temperature
                color: green
              - entity: sensor.sonde_salon_hum
                name: Humidity
                color: '#2196f3'
                y_axis: secondary
            hours_to_show: 24
            points_per_hour: 2
            line_width: 3
            font_size: 50
            animate: true
            show:
              name: false
              icon: false
              labels: true
              state: false
              legend: false
              fill: fade
    card_mod:
      style: |
        mushroom-shape-icon {
          {% if is_state(config.entity, 'heat_cool') %}
            --card-mod-icon: mdi:autorenew;
            animation: spin 3s ease-in-out infinite alternate;
          {% elif is_state(config.entity, 'heat') %}
            --card-mod-icon: mdi:fire;
            animation: heat 2s infinite;
          {% elif is_state(config.entity, 'cool') %}
            --card-mod-icon: mdi:snowflake;
            animation: cool 6s ease-in-out infinite;
          {% elif is_state(config.entity, 'dry') %}
            --card-mod-icon: mdi:water-percent;
            animation: dry 1.5s linear infinite;
          {% elif is_state(config.entity, 'fan_only') %}
            --card-mod-icon: mdi:fan;
            animation: spin 1s linear infinite;
          {% else %}
            --card-mod-icon: mdi:air-conditioner; 
          {% endif %}
          display: flex;
        }
        @keyframes cool {
          0%, 100% { transform: rotate(25deg); }
          25% { transform: rotate(-25deg); }
          50% { transform: rotate(50deg); }
          75% { transform: rotate(-50deg); }
        }
        @keyframes heat {
          0%, 100% { --icon-color: rgba(var(--rgb-red), 1); }
          10%, 90% { --icon-color: rgba(var(--rgb-red), 0.8); }
          20%, 80% { --icon-color: rgba(var(--rgb-red), 0.6); }
          30%, 70% { --icon-color: rgba(var(--rgb-red), 0.4); }
          40%, 60% { --icon-color: rgba(var(--rgb-red), 0.2); }
          50% { --icon-color: rgba(var(--rgb-red), 0); }
        }
        @keyframes dry {
          0%, 100% { --icon-symbol-size: 21px; }
          10%, 90% { --icon-symbol-size: 22px; }
          20%, 80% { --icon-symbol-size: 23px; }
          30%, 70% { --icon-symbol-size: 24px; }
          40%, 60% { --icon-symbol-size: 25px; }
          50% { --icon-symbol-size: 26px; }
        }    
    ```
[Ссылка на источник]()

