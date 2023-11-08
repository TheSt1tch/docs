# Ошибки консоли Unix

| Текст Ошибки | Решение |
| --- | --- |
| `leapsecond file ('/var/db/ntpd.leap-seconds.list'): expired less than` | `service ntpd onefetch` |
| Ошибки при загрузке ОС, ругается на сегменты | Single mode<br>`fsck -t ufs -y /dev/da0p2`<br>Если говорит что используется журнал<br>`tunefs -j disable /dev/da0p2` |
|     |     |