# Ansible

Ставим на Debian 12

Хотя Ansible доступен в [основном репозитории Debian](https://packages.debian.org/stable/ansible) , он может быть устаревшим.

Чтобы получить более новую версию, пользователи Debian могут использовать Ubuntu PPA в соответствии со следующей таблицей:

| **Debian** |    | **Ubuntu** | **UBUNTU_CODENAME** |
|----|----|----|----|
| Debian 12 (Bookworm) | -> | Ubuntu 22.04 (Jammy) | jammy |
| Debian 11 (Bullseye) | -> | Ubuntu 20.04 (Focal) | focal |
| Debian 10 (Buster) | -> | Ubuntu 18.04 (Bionic) | bionic |

В следующем примере мы предполагаем, что у вас уже установлены wget и gpg `sudo apt install wget gpg`

Выполните следующие команды, чтобы добавить репозиторий и установить Ansible. Установите `UBUNTU_CODENAME=...` на основе таблицы выше (мы используем `jammy` в этом примере).

```bash
$ UBUNTU_CODENAME=jammy
$ wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | sudo gpg --dearmour -o /usr/share/keyrings/ansible-archive-keyring.gpg
$ echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/ansible.list
$ sudo apt update && sudo apt install ansible
```

!!! Note

    " " вокруг URL-адреса сервера ключей важны. Вокруг "echo deb" важно использовать " ", а не ' '.

Эти команды загружают ключ подписи и добавляют запись в источники apt, указывающую на PPA.

Ранее вы могли использовать `apt-key add` . Теперь это [устарело](https://manpages.debian.org/testing/apt/apt-key.8.en.html) по соображениям безопасности (в Debian, Ubuntu и других местах). Для получения более подробной информации см. [этот пост AskUbuntu](https://askubuntu.com/a/1307181) . Также обратите внимание, что по соображениям безопасности мы НЕ добавляем ключ в `/etc/apt/trusted.gpg.d/`, или туда `/etc/apt/trusted.gpg`, где было бы разрешено подписывать релизы из ЛЮБОГО репозитория.
