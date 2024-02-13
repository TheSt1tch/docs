# ARK: Survival Evolved - Dedicated Server

```yaml title="docker-compose.yml"
version: '3.7'

services:
  ark-server:
    restart: always
    container_name: ark-server
    image: hermsi/ark-server:latest
    volumes:
      - ./ark-server:/app #main location for game server
      - ./ark-server-backups:/home/steam/ARK-Backups # folder for backup
    environment:
      - SESSION_NAME=$SESSION_NAME
      - SERVER_MAP=$SERVER_MAP
      - SERVER_PASSWORD=$SERVER_PASSWORD
      - ADMIN_PASSWORD=$ADMIN_PASSWORD
      - MAX_PLAYERS=$MAX_PLAYERS
      - UPDATE_ON_START=$UPDATE_ON_START
      - BACKUP_ON_STOP=$BACKUP_ON_STOP
      - PRE_UPDATE_BACKUP=$PRE_UPDATE_BACKUP
      - WARN_ON_STOP=$WARN_ON_STOP
      - GAME_MOD_IDS=$GAME_MOD_IDS
    ports:
      # Port for connections from ARK game client
      - "7777:7777/udp"
      # Raw UDP socket port (always Game client port +1)
      - "7778:7778/udp"
      # RCON management port
      - "27020:27020/tcp"
      # Steam's server-list port
      - "27015:27015/udp"
```

```env title=".env"
SESSION_NAME="St1t.ru ARK Server"
SERVER_MAP=Viking_P
SERVER_PASSWORD=
ADMIN_PASSWORD=Rhjrjlbkmxbr
MAX_PLAYERS=10
UPDATE_ON_START=true
BACKUP_ON_STOP=true
PRE_UPDATE_BACKUP=false
WARN_ON_STOP=true
GAME_MOD_IDS="1838617463,520879363,889745138,1404697612,1814953878,731604991,2804332920,2718221803,1762210129,2765267311,1251632107,1565015734,821530042,2121156303,702828089,741203089,898049820"
```