# OIDC логин через Authentik

Добавил авторизацию через Authentik, но потребовалось сделать так, чтобы формы входа не было. Чтобы сразу шел редирект на страницу авторизации Authentik.

Для этого нужно выолпнить команду (nextcloud в докере):

```
docker exec -ti --user 1000 nextcloud_app php occ config:app:set --value=0 user_oidc allow_multiple_user_backends
```
где `nextcloud_app` - имя контейнера

Применимо только для приложения nextcloud: **user_oidc** (https://github.com/nextcloud/user_oidc)