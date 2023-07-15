# Google Диск (Google Drive)

Загружаем клиент Google Drive:
```
wget -O drive  https://drive.google.com/uc?id=0B3X9GlR6EmbnMHBMVWtKaEZXdDg
```
Перемещаем файл директорию /usr/sbin командой:
```
mv drive /usr/sbin/drive
```
Даем права на файл:
```
chmod +x /usr/sbin/drive
```
На этом установка клиента Google Drive завершена, нам остается лишь запустить его и пройти авторизацию:
```
drive
mv drive /usr/sbin/drive chmod +x /usr/sbin/drive drive

 Go to the following link in your browser: 
https://accounts.google.com/o/oauth2/auth?client_id=367116221053-7n0vf5akeru7on6o2fjinrecpdoe99eg.apps.googleusercontent.com&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive&state=state 
Enter verification code: 
```
Нужно скопировать ссылку и открыть ее в браузере на ПК, после чего разрешить доступ к аккаунту. После этого, вам будет предоставлена ссылка, которую нужно будет ввести в консоли Linux: Google Drive подключен, однако он подключен не через WebDav (не поддерживается) , и вы не видите его как отдельную файловую систему и локальный каталог. Все обращения к хранилищу Google выполняются через клиент drive

Можно проверить какие файлы присутствуют на хранилище Google Диск командой drive list:
```
drive list

 Id Title Size Created
1hG1VSNM67IOXlYCVQp9YqhJlFYU2g1qw test.txt 5.0 B 2019-09-02 17:01:13 
1ih29E4B4piOho3oupLu2YXWfHZtIA330 DE30EF56-523D-4F90-…EE62DD392E89-1.mov 351.0 MB 2019-08-22 10:41:56 
15qbRDBAZztBkN2rWCBhnYidMArTbaqW3 CALLU_8-7-2019_15-35-28_Private.mp3 83.2 KB 2019-07-08 15:35:40 
1A4BUo_PTVH460SAAkbJKmgDlY1567Hno CALLU_8-7-2019_15-31-7_Private.mp3 1.3 MB 2019-07-08 15:34:10 
```
Файлы выводятся в виде таблицы с четырьмя столбцами: Id – уникальный код файла Title – название файла Size – размер Created – дата создания

Для теста можем создать файл и передать его на g.drive:
```
touch drive.txt && drive upload –file drive.txt
```
Файл создался, и виден в консоли:
```
1KbdgtW3jJz46_zZ0Wv-ceBcUSSvEp5n- drive.txt 0.0 B 2019-09-02 17:49:30
```
По-умолчанию Google предлагает бесплатные 15 Гб на своем Google Диск.