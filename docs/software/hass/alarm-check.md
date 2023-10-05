# Будильник для Home Assistant

Представление карточки в Home Assistant:

В карточке используется дополнительный компонент [custom:fold-entity-row](https://github.com/thomasloven/lovelace-fold-entity-row). Ставится при помощи HACS.

## Внешний вид карточки

![](https://api.sprut.ai/static/media/cache/00/83/47/40/4289/77973/1600x_image.png?1620313596)

Карточка будильника

![](https://api.sprut.ai/static/media/cache/00/83/47/40/4289/77974/1600x_image.png?1620313597)

Карточка будильника развернута

## Код карточки

``` yaml
type: entities
entities:
  - entity: group.alarm_1
    icon: mdi:alarm-check
    name: Будильник
  - entity: sensor.alarm_1_time
    icon: mdi:clock-outline
    name: Время срабатывания
  - entity: input_number.alarm_1_hour
    icon: mdi:cog-clockwise
    name: Часы
  - entity: input_number.alarm_1_minutes
    icon: mdi:cog-clockwise
    name: Минуты
  - type: custom:fold-entity-row
    head:
      type: section
      label: Параметры
    entities:
      - entity: sensor.time_date
        name: Текущее время и дата
      - entity: sensor.alarm_1_time_minus_offset
        icon: mdi:progress-clock
        name: Время отложенного срабатывания
      - entity: sensor.alarm_1_time_minus_cover
        name: Время открытия шторы
      - entity: input_number.alarm_1_offset
        name: Отложить на
      - entity: input_number.alarm_1_cover
        name: Шторы
      - entity: input_boolean.alarm_1_weekday
        name: Рабочие дни
      - entity: input_boolean.alarm_1_weekend
        name: Выходные дни
      - entity: automation.wake_me_up_weekday_offset
        icon: mdi:calendar
        name: Отложеное время в рабочие дни
      - entity: automation.wake_me_up_weekend_offset
        icon: mdi:calendar
        name: Отложеное время в выходные дни

```

## Как это работает

В указанное время срабатывает будильник.

Начинает проигрываться мелодия.

Ночник и светодиодная лента плавно включаются и добавляют яркость, цветопередача солнечного цвета.
~~Я люблю поваляться в стиле “еще 15 минут”, рукой толкаю куб Aqara, будильник откладывается на 15 минут.~~
~~Через 15 минут снова начинает проигрываться мелодия, плавно включается освещение, поднимается штора.~~
~~Я переворачиваю куб Aqara на 90°, будильник выключается, ночник и лента загораются на максимальной яркости. Home Assistant начинает доклад о погоде и дорожной обстановке, указывает время до работы на авто и время до ближайшего автобуса (интеграции Yandex карты и транспорт).~~

## Код будильника

```yaml
#ДОБАВЛЯЕМ ЭЛЕМЕНТЫ ВВОД И УПРАВЛЕНИЯ 
input_number: 
  alarm_1_hour: 
    name: Hours 
    icon: mdi:timer 
    initial: 7 
    min: 0 
    max: 23 
    step: 1 
  alarm_1_minutes: 
    name: Minutes 
    icon: mdi:timer 
    initial: 15 
    min: 0 
    max: 59 
    step: 1 
  alarm_1_offset: 
    name: Transition 
    icon: mdi:blur-linear 
    initial: 5 
    min: 0 
    max: 60 
    step: 5 
  alarm_1_cover: 
    name: Transition 
    icon: mdi:blur-linear 
    initial: 15 
    min: 0 
    max: 60 
    step: 5 
#ПЕРЕКЛЮЧАТЕЛИ
input_boolean: 
  alarm_1_weekday: 
    name: Weekdays 
    initial: off 
    icon: mdi:calendar 
  alarm_1_weekend: 
    name: Weekends 
    initial: off 
    icon: mdi:calendar 
  alarm_1_offset_boolen: 
    name: Offset 
    initial: off 
    icon: mdi:timer 
#СЕНСОРЫ ДЛЯ ПОДСЧЕТА ВРЕМЕНИ В ОТЛОЖЕННЫХ ФУНКЦИЯХ 

sensor: 
  - platform: template 
    sensors: 
      alarm_1_time: 
        value_template: >- 
          {{ '%0.02d:%0.02d' | format(states('input_number.alarm_1_hour') | int, states('input_number.alarm_1_minutes') | int) }}
  - platform: template 
    sensors: 
      alarm_1_time_minus_offset: 
        friendly_name: 'Offset Time' 
        value_template: >- 
          {{ "%0.02d:%0.02d" | format( ((((states("input_number.alarm_1_hour") | int)*60 (states("input_number.alarm_1_minutes") | int) (states("input_number.alarm_1_offset"))| int)/60)| int),(((((((((states("input_number.alarm_1_hour") | int)*60 (states("input_number.alarm_1_minutes") | int) (states("input_number.alarm_1_offset")) | int)/60)) - ((((states("input_number.alarm_1_hour") | int)*60 (states("input_number.alarm_1_minutes") | int) (states("input_number.alarm_1_offset")) | int)/60)| int))*100) | int)*60/100) | round) ) }}
  - platform: template
    sensors: 
      alarm_1_time_minus_cover: 
        friendly_name: 'Cover Time' 
        value_template: >- 
          {{ "%0.02d:%0.02d" | format( ((((states("input_number.alarm_1_hour") | int)*60 (states("input_number.alarm_1_minutes") | int) (states("input_number.alarm_1_cover"))| int)/60)| int),(((((((((states("input_number.alarm_1_hour") | int)*60 (states("input_number.alarm_1_minutes") | int) (states("input_number.alarm_1_cover")) | int)/60)) - ((((states("input_number.alarm_1_hour") | int)*60 (states("input_number.alarm_1_minutes") | int) (states("input_number.alarm_1_cover")) | int)/60)| int))*100) | int)*60/100) | round) ) }} #for -# {{ "%0.02d:%0.02d" | format( ((((states("input_number.alarm_1_hour") | int)*60 (states("input_number.alarm_1_minutes") | int) - (states("input_number.alarm_1_cover"))| int)/60)| int),(((((((((states("input_number.alarm_1_hour") | int)*60 (states("input_number.alarm_1_minutes") | int) - (states("input_number.alarm_1_cover")) | int)/60)) - ((((states("input_number.alarm_1_hour") | int)*60 (states("input_number.alarm_1_minutes") | int) - (states("input_number.alarm_1_cover")) | int)/60)| int))*100) | int)*60/100) | round) ) }}
      
#ГРУПИРОВКА ВЫКЛЮЧАТЕЛЯ "БУДИЛЬНИК" 
group: 
  alarm_1: 
    name: Wake Me Up 
    entities: 
      - input_boolean.alarm_1_weekday 
      - automation.wake_me_up_weekday_offset
      
#ВКЛЮЧЕНИЕ БУДИЛЬНИКА ПРИ ЗАПУСКЕ HA 
automation: 
  - id: 'startup_on_alarm_clock' 
    alias: Включение будильника при запуске HA 
    trigger: 
      platform: homeassistant 
      event: start 
    condition: 
      condition: time 
      after: '09:00:00' 
      before: '00:00:00' 
    action: 
      - delay: 0:01 
      - service: script.yandex_tts_4 

  #ВКЛЮЧЕНИЕ КЛАВИШАМИ. ПРОСТО ЗВУКОВОЕ СООБЩЕНИЕ О ВКЛЮЧЕНИИ 
  - id: 'on_alarm_clock' 
    alias: "Включение будильника клавишей" 
    trigger: 
      platform: state 
      entity_id: 
        - input_boolean.alarm_1_weekday 
        - input_boolean.alarm_1_weekend 
      to: 'on' 
    action: 
      - service: script.yandex_tts_2 

  #ВЫКЛЮЧЕНИЕ КЛАВИШАМИ. ПРОСТО ЗВУКОВОЕ СООБЩЕНИЕ О ВЫКЛЮЧЕНИИ 
  - id: 'off_alarm_clock' 
    alias: "Выключение будильника клавишей" 
    trigger: 
      platform: state 
      entity_id: 
        - input_boolean.alarm_1_weekday 
        - input_boolean.alarm_1_weekend 
      to: 'off' 
    action: 
      - service: script.yandex_tts_3 

####################################### 
# Автоматизация для основного времени #
#######################################
#ЗАПУСКАЕМ СКРИПТ БУДИЛЬНИКА. 
  - id: 'alarm_1_weekday' 
    alias: Wake me up (weekday) 
    trigger: 
      - platform: time_pattern 
        minutes: "/1" 
        seconds: 0 
    condition: 
      - condition: state 
        entity_id: input_boolean.alarm_1_weekday 
        state: 'on' 
      - condition: time 
        weekday: 
          - mon 
          - tue 
          - wed 
          - thu 
          - fri 
      - condition: template 
        value_template: >- 
          {{ now().strftime("%H:%M") == states.sensor.alarm_1_time.state }}
    action: 
      - data: {} 
        service: script.wakeup_sequence 

####################################### 
# Автоматизация для выходных ##########
#######################################
#ЗАПУСКАЕМ СКРИПТ БУДИЛЬНИКА. 
  - id: 'alarm_1_weekend' 
    alias: Wake me up (weekend) 
    trigger: 
      - platform: time_pattern 
        minutes: "/1" 
        seconds: 0 
    condition: 
      - condition: state 
        entity_id: input_boolean.alarm_1_weekend 
        state: 'on' 
      - condition: time 
        weekday: 
          - sat 
          - sun 
      - condition: template 
        value_template: >- 
          {{ now().strftime("%H:%M") == states.sensor.alarm_1_time.state }} 
    action: 
      - data: {} 
        service: script.wakeup_sequence 

####################################### 
# Автоматизация для отложенного времени #
###################################### 
#ЗАПУСКАЕМ СКРИПТ БУДИЛЬНИКА ЕСЛИ ОТЛОЖИЛИ БУДИЛЬНИК. 
  - id: 'alarm_1_weekday_offset' 
    alias: Wake me up (weekday_offset) 
    trigger: 
      - platform: time_pattern
        minutes: "/1" 
        seconds: 0 
    condition: 
      - condition: state 
        entity_id: input_boolean.alarm_1_weekday 
        state: 'on' 
      - condition: time 
        weekday: 
          - mon 
          - tue 
          - wed 
          - thu 
          - fri 
      - condition: template 
        value_template: >- 
          {{ now().strftime("%H:%M") == states.sensor.alarm_1_time_minus_offset.state }} 
    action: 
      - data: {} 
        service: script.wakeup_sequence 

####################################### 
# Автоматизация для отложенного времени в выходные #
###################################### 
# ЗАПУСКАЕМ СКРИПТ БУДИЛЬНИКА ЕСЛИ ОТЛОЖИЛИ БУДИЛЬНИК. 
  - id: 'alarm_1_weekend_offset' 
    alias: Wake me up (weekend offset) 
    trigger: 
      - platform: time_pattern 
        minutes: "/1" 
        seconds: 0 
    condition: 
      - condition: state 
        entity_id: input_boolean.alarm_1_weekend 
        state: 'on' 
      - condition: time 
        weekday: 
          - sat 
          - sun 
      - condition: template 
        value_template: >- 
          {{ now().strftime("%H:%M") == states.sensor.alarm_1_time_minus_offset.state }} 
    action: 
      - data: {} 
        service: script.wakeup_sequence 

####################################### 
# Автоматизация для Штор #
####################################### 
#ПОДНИМАЕМ ШТОРЫ ПО УКАЗАННОМУ ВРЕМЕНИ 
  - id: 'alarm_1_weekday_cover' 
    alias: Wake me up (weekday_cover) 
    trigger: 
      - platform: time_pattern 
        minutes: "/1" 
        seconds: 0 
    condition: 
      - condition: state 
        entity_id: input_boolean.alarm_1_weekday 
        state: 'on' 
      - condition: time 
        weekday: 
          - mon 
          - tue 
          - wed 
          - thu 
          - fri 
      - condition: template 
        value_template: >- 
          {{ now().strftime("%H:%M") == states.sensor.alarm_1_time_minus_cover.state }} 
    action: 
      - service: mqtt.publish 
        data: 
          topic: "cmnd/blind/Backlog" 
          payload: "ShutterOpen1" 
          
  - id: 'alarm_1_weekend_cover' 
    alias: Wake me up (weekend cover) 
    trigger: 
      - platform: time_pattern 
        minutes: "/1" 
        seconds: 0 
    condition: 
      - condition: state 
        entity_id: input_boolean.alarm_1_weekend 
        state: 'on' 
      - condition: time 
        weekday: 
          - sat 
          - sun 
      - condition: template 
        value_template: >- 
          {{ now().strftime("%H:%M") == states.sensor.alarm_1_time_minus_cover.state }} 
    action: 
      - service: mqtt.publish 
        data: 
          topic: "cmnd/blind/Backlog" 
          payload: "ShutterOpen1" 

###################################### 
# СКРИПТ БУДИЛЬНИКА #
###################################### 
#Срабатывает последовательно: выставляется оттенок цвета, яркость в 0.
script: 
  'wakeup_dim': 
    alias: wakeup_dim 
    sequence:
      - service: light.turn_on
        data: 
          brightness: '0' 
          rgb_color: 
            - 255 
            - 169 
            - 92 
          entity_id: 
            - light.yeelink_ceilb_f571_ambient_light 

#Срабатывает последовательно: постепенно включается освещение.
  'wakeup_bright': 
    alias: wakeup_bright 
    sequence: 
      - service: light.turn_on 
        data_template: 
          brightness: '255' 
          transition: '{{(states(''input_number.alarm_1_offset'') | int ) *60}}' 
          entity_id: 
            - light.yeelink_ceilb_f571_ambient_light 
          rgb_color: 
            - 255 
            - 169 
            - 92 
      
#Главный скрипт будильника 
  'wakeup_sequence': 
    alias: wakeup_sequence 
    sequence: 
      - data: {}
      #сбрасываем параметры освещения 
        service: script.wakeup_dim 
      - delay: 00:00:02 
      #включаем плавное наращивание освещения 
      - service: script.wakeup_bright 
      - delay: '00:{{ states.input_number.alarm_1_offset.state | int }}:00' 
      - data: {}
      #Включение музыки на яндекс станции 
        service: script.yandex_tts_1 
      # ИЛИ запуск проигрывания мелодии # 
      #- service: script.play_wakeup_music #в систему HA подгружена заранее собранная и настроенная мной мелодия. 
      #Я выбрал медленную композицию Daft Punk, в звуковом редакторе установил плавное увеличение громкости для нее и экспортировал в mp3. 
      #По сути HA просто воспроизводит mp3 через подключаемый addon https://github.com/bestlibre/hassio-addons/tree/master/mopidy

      
  # TTS YANDEX
  yandex_tts_1:
    alias: YaStation_Запуск будильника
    sequence:
    - service: media_player.volume_set
      data:
        entity_id:
        - media_player.yandex_station_m0017y300grsqb
        volume_level: 0.1
    - delay: 00:00:01
    - service: yandex_station.send_command
      data:
        entity_id: media_player.yandex_station_m0017y300grsqb
        command: sendText
        text: Включи фоновую музыку.
    - delay: 00:01:00
    - service: media_player.volume_set
      data:
        entity_id:
        - media_player.yandex_station_m0017y300grsqb
        volume_level: 0.2
    - delay: 00:00:30
    - service: media_player.volume_set
      data:
        entity_id:
        - media_player.yandex_station_m0017y300grsqb
        volume_level: 0.3
    - delay: 00:00:30
    - service: media_player.volume_set
      data:
        entity_id:
        - media_player.yandex_station_m0017y300grsqb
        volume_level: 0.4

  yandex_tts_2:
    alias: YaStation_Включение будильника
    sequence:
    - service: media_player.volume_set
      data:
        entity_id:
        - media_player.yandex_station_m0017y300grsqb
        volume_level: 0.4
    - delay: 00:00:01
    - service: media_player.play_media
      entity_id: media_player.yandex_station_m0017y300grsqb
      data:
        media_content_id: Включаю будильник на {{ states('sensor.alarm_1_time') }}
        media_content_type: text

  yandex_tts_3:
    alias: YaStation_Выключение будильника
    sequence:
    - service: media_player.volume_set
      data:
        entity_id:
        - media_player.yandex_station
        volume_level: 0.4
    - service: media_player.play_media
      entity_id: media_player.yandex_station_m0017y300grsqb
      data:
        media_content_id: Будильник выключен.
        media_content_type: text
```