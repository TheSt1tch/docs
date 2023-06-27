Недавно у меня появился на руках сервер HPE ML30 Gen10. Мне больше всего нравится Ubuntu Server, поэтому я решил установить его на сервере. Чуть позднее я узнал, что у HP есть утилиты, которые вы можете установить в Linux для изменения и просмотра настроек и информации на уровне системы, что довольно круто.

Я хотел попробовать их, однако Ubuntu не входит в группу ОС (Red Hat и SUSE), которые получают пакеты [обновлений](https://downloads.linux.hpe.com/SDR/project/spp/) . Так что документация и поддержка минимальны, и мне потребовалось немного времени, чтобы во всем разобраться.

!!! info
	Отказ от ответственности: я работаю над сервером Gen 10, поэтому
	устанавливаемые пакеты могут отличаться от других поколений.

## Установка через APT

Во-первых, чтобы установить утилиты, вам нужно добавить [источник](https://downloads.linux.hpe.com/SDR/project/mcp/) в **apt**:
```bash
sudo echo "deb http://downloads.linux.hpe.com/SDR/repo/mcp dist/project_ver non-free" > /etc/apt/sources.list.d/mcp.list
```
 
Где:
- **dist**: jammy, bullseye, focal, buster, bionic, xenial, precise, stretch, jessie
- **project_ver**: current, 12.40, 12.30, 12.20, 12.05, 12.00, 11.30, 11.21, 11.05

Для **Ubuntu Server 22** команда будет такой:
```bash
sudo echo "deb http://downloads.linux.hpe.com/SDR/repo/mcp jammy/current non-free" > /etc/apt/sources.list.d/mcp.list
```
Затем вам необходимо зарегистрировать [открытые ключи HPE](https://downloads.linux.hpe.com/SDR/keys.html) (в этой же команде, идет преобразование ключей в новый формат, чтобы при обновлении пакетов, не выходило предупреждение):
```bash
curl https://downloads.linux.hpe.com/SDR/hpPublicKey2048.pub | apt-key add -
apt-key export 5CE2D476 | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/hpPublicKey2048.gpg
sudo apt-key --keyring /etc/apt/trusted.gpg del 5CE2D476

curl https://downloads.linux.hpe.com/SDR/hpPublicKey2048_key1.pub | apt-key add -
apt-key export B1275EA3 | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/hpPublicKey2048_key1.gpg
sudo apt-key --keyring /etc/apt/trusted.gpg del B1275EA3

curl https://downloads.linux.hpe.com/SDR/hpePublicKey2048_key1.pub | apt-key add -
apt-key export 26C2B797 | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/hpePublicKey2048_key1.gpg
sudo apt-key --keyring /etc/apt/trusted.gpg del 26C2B797
```
 Теперь вам просто нужно обновить исходники apt и установить утилиты.
```bash 
sudo apt update
```

Несмотря на имена пакетов, указанные на [странице HPE](https://downloads.linux.hpe.com/SDR/project/mcp/) , я обнаружил, что некоторые пакеты просто не существуют или имеют другие имена.

Список доступных компонентов для установки:

|  |  |
| - | - |
| **hp-health**  | HPE System Health Application and Command line Utilities (Gen9 and earlier) |
| **hponcfg** | HPE RILOE II/iLO online configuration utility |
| **amsd** | HPE Agentless Management Service (Gen10 only) |
| **hp-ams** | HPE Agentless Management Service (Gen9 and earlier) |
| **hp-snmp-agents** | Insight Management SNMP Agents for HPE ProLiant Systems (Gen9 and earlier) |
| **hpsmh** | HPE System Management Homepage (Gen9 and earlier) |
| **hp-smh-templates** | HPE System Management Homepage Templates (Gen9 and earlier) |
| **ssacli** | HPE Command Line Smart Storage Administration Utility |
| **ssaducli** | HPE Command Line Smart Storage Administration Diagnostics |
| **ssa** | HPE Array Smart Storage Administration Service |
| **storcli** | MegaRAID command line interface |

Устанавливаются просто: `sudo apt install <name>`. Например `sudo apt install amsd`

## Установка через пакеты .deb

 1. Идем в [репозиторий HPE для Linux](https://downloads.linux.hpe.com), раздел **mpc** — Management Component Pack for ProLiant.
 2. Ищем Ubuntu.
 3. Дальше *pool* → *non-free*.
 4. Находим нужный пакет, копируем ссылку, качаем и устанавливаем. Для примера будет **amsd**:
	```bash
	cd /tmp
	wget https://downloads.linux.hpe.com/SDR/repo/mcp/Ubuntu/pool/non-free/amsd_3.1.0-1745.130-jammy_amd64.deb
	dpkg -i amsd_3.1.0-1745.130-jammy_amd64.deb
	```