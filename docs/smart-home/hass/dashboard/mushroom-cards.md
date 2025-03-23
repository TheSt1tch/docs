# Mushroom Cards

## Выпадающий список к карточке

Объединение нескольких карточек, для управления подсветкой ТВ и медиаплеером

![](https://community-assets.home-assistant.io/original/4X/6/0/0/6002f8a3af520e53d3f95f8bb5e061c1bd4d1554.gif)

??? example title="Пример"

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
