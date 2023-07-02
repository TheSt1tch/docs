# Удаление раскладки "RUS US"

> Ситуация: подключаемся к терминальному серверу и получаем странные раскладки «RUS US» или «ENG RU», при этом их невозможно ни отключить ни удалить.

[Решение](https://social.technet.microsoft.com/Forums/ru-RU/6231938b-44d8-4bca-8a2a-542c49d19fdd/-rus-us?forum=WS8ru)

Добавляем в ветку реестра `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout` параметр `IgnoreRemoteKeyboardLayout` типа `DWORD` равный `00000001`