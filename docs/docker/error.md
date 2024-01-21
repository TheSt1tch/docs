# Ошибки в Docker

## WARNING: Error loading config file" при вводе команд

При выполнении любой команды, например `docker run --rm -ti ubuntu:14.04 /bin/bash` выдаетс ошибка 

```
WARNING: Error loading config file:/home/username/.docker/config.json - stat /home/username/.docker/config.json: permission denied
```

Причина: нарушена пренадлежность файла `config.json`

Решение: восстановить принадлежность файла: 

```
sudo chown $USER /home/username/.docker/config.json
```
или каталога:
```
sudo chown -R $USER /home/username/.docker
```
