# Обновление MC9090

## WM5 на WM6.1

Нам понадобится флешка объёмом 2 Гб и прошивка с WM 6, которую можно скачать вот по этой [ссылке](https://cloud.st1t.ru/s/gpeP3WbwqbWnKjG).

1.  Распаковываем содержимое архива в корень флешки.
2.  Помещаем флешку в ТСД (MC9090, если кто забыл).
3.  Переходим на мобильном устройстве на флешку и запускаем там файл `StartUpdLdr_WM5.0.exe`, дожидаемся пока обновится **BootLoader**.
4.  Как только обновление произошло и система вновь загрузилась запускаем `90XXw61X001Upgrade.exe`. Вставляем терминал в кредл и идём пить чай (кофе), т.к. процесс этот достаточно долгий.

После окончания прошивки должна загрузится обновлённая **Windows Mobile 6.1**.

