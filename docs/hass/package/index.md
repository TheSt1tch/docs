# Пакеты конфигурации

С увеличением количества устройств в умном доме, возникает вопрос: как не потеряться в файле конфигурации? На помощь приходят **Packages (пакеты)**. Они позволяют организовывать и группировать компоненты ***Home Assistant*** в один или несколько файлов.

## Первые шаги

Для начала необходимо создать папку **packages** в корне директории, где храниться файл **configuration.yaml**!  
Затем добавьте в **configuration.yaml** следующие строки, указанные ниже! (пример использования на картинке).

```yaml
homeassistant: 
  packages: !include_dir_named packages
```

Готово! Вам осталось придумать, как вы назовёте папки и файлы в которых будут храниться *switch*, *light*, *sensor* и другие компоненты.

К примеру, чтобы перенести все *switch* из **configuration.yaml** в отдельный файл, создайте в папке **packages** файл с названием - **названиеФайла.yaml** и поместите в него ваш код!

## Стандартная структура файла

Для использования компонента, укажите [название интеграции](https://www.home-assistant.io/components/) и поставьте двоеточие. После этого вы можете добавлять свои устройства! Также, можно кастомизировать устройства прямо в пакетах, пример ниже.

```yaml
binary_sensor:
  - platform: workday
    name: tools_workday 
    country: 'RU' 
  - platform: rest
    name: hall_doorbell 
    device_class: sound 
    resource: http://0.0.0.0/sec/?pt=10&cmd=get 
    scan_interval: 1 
    
# Кастомизация устройств в пакетах (не обязательно) 
homeassistant: 
  customize: 
    binary_sensor.tools_workday: 
      friendly_name: Рабочий день
```

Еще можно объединять **несколько компонентов** в один файл:

```yaml
### Очиститель воздуха Philips ### 
# Настройки интеграции 
fan: 
  - platform: philips_airpurifier
    host: !secret host_philips_airpurifier

# Внешний вид 
homeassistant: 
  customize: 
    sensor.philips_pre_filter: 
      friendly_name: 'Предв. фильтр' 

# Датчики 
sensor: 
  - platform: template 
    sensors:
      philips_pre_filter:
        unit_of_measurement: 'ч' 
        value_template: "{{ state_attr('fan.philips_airpurifier', 'pre_filter') }}"
```