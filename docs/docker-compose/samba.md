[Samba в Docker Hub](https://hub.docker.com/r/dperson/samba)

## Простой запуск

```bash
sudo docker run -it -p 139:139 -p 445:445 -d dperson/samba -p
```

Или с установкой локального хранилища

```bash
sudo docker run -it --name samba -p 139:139 -p 445:445 \
            -v /path/to/directory:/mount \
            -d dperson/samba -p
```

## Через Docker Compose

```yaml
# https://hub.docker.com/r/dperson/samba
  samba:
    container_name: samba
    image: dperson/samba
    ports:
      - "137:137/udp"
      - "138:138/udp"
      - "139:139/tcp"
      - "445:445/tcp"
    read_only: false # доступ для чтения или записи.
    tmpfs:
      - /tmp
    restart: unless-stopped
    stdin_open: true
    tty: true
    environment:
      PUID: $PUID
      PGID: $PGID
      TZ: $TZ
    volumes:
      - /storage/mount1:/mount1 # шары
    command:
    # -s "<name;/path>[;browse;readonly;guest;users;admins;writelist;comment]" 
    # -s "name;/path;no;no;no;example1"
      -s "Serials;/disk1;yes;no;yes" 
      -p
```