Работа в командной строке обеспечивает скорость и удобство. Недостатком является то, что вам придется запоминать все команды, а некоторые из них длинные и могут повлиять на вашу производительность. К счастью, мы можем создавать ярлыки для команд, которые могут значительно ускорить работу.

В Ubuntu пользователь может создать файл «.bash\_aliases», содержащий список всех ярлыков или псевдонимов часто используемых команд. Прежде всего, убедитесь, что у вас есть файл .bashrc в вашем домашнем каталоге:

```bash
cd ~
ls -al
```

Проверьте, есть ли у вас файл .bashrc. Если он у вас есть, откройте файл в nano или вашем любимом текстовом редакторе и найдите следующие строки:

```bash
if [ -f ~/.bash_aliases ]; then
   . ~/.bash_aliases
fi
```

Убедитесь, что они не закомментированы (без символа # перед строками).

Теперь создайте файл .bash\_aliases в своем домашнем каталоге и начните добавлять в него свои псевдонимы. Ниже приведен пример файла .bash\_aliases:

```bash
# Update and Upgrade Packages
alias update='sudo apt-get update'
alias upgrade='sudo apt-get upgrade'
 
# Install and Remove Packages
alias install='sudo apt-get install'
alias uninstall='sudo apt-get remove'
alias installf='sudo apt-get -f install' #force install
alias installfr='sudo apt-get -f install --reinstall' #force reinstall
 
# Add repository keys (usage: addkey XXXXXXXX - last 8 digits of the key)
alias addkey='sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com'
 
# Search apt repository
alias search='sudo apt-cache search'
 
# Cleaning
alias clean='sudo apt-get clean && sudo apt-get autoclean'
alias remove='sudo apt-get remove && sudo apt-get autoremove'
alias purge='sudo apt-get purge'
alias deborphan='sudo deborphan | xargs sudo apt-get -y remove --purge'
 
# Shutdown and Reboot
alias shutdown='sudo shutdown -h now'
alias reboot='sudo reboot'
 
# Network Start, Stop, and Restart
alias networkrestart='sudo service networking restart'
alias networkstop='sudo service networking stop'
alias networkstart='sudo service networking start'
 
# Misellaneous
alias fdisk='sudo fdisk -l'
alias uuid='sudo vol_id -u' #list UUIDs
alias rfind='sudo find / -name' #find a file. Usage: rfind 'filename'
alias rd='sudo rm -R' #remove directory
alias imount='sudo mount -o loop -t iso9660' #mount iso. Usage: imount 'filename.iso'
alias dirsize='sudo du -hx --max-depth=1' #directory size. Usage: dirsize directoryname
 
# DOCKER COMMON - All docker commands start with "d"
alias dstop='sudo docker stop $(docker ps -a -q)'
alias dstopall='sudo docker stop $(sudo docker ps -aq)'
alias drm='sudo docker rm $(docker ps -a -q)'
alias dprunevol='sudo docker volume prune'
alias dprunesys='sudo docker system prune -a'
alias ddelimages='sudo docker rmi $(docker images -q)'
alias derase='dstopcont ; drmcont ; ddelimages ; dvolprune ; dsysprune'
alias dprune='ddelimages ; dprunevol ; dprunesys'
alias dexec='sudo docker exec -ti'
alias dps='sudo docker ps -a'
alias dpss='sudo docker ps -a --format "table {{.Names}}\t{{.State}}\t{{.Status}}\t{{.Image}}" | (sed -u 1q; sort)'
alias ddf='sudo docker system df'
alias dlogs='sudo docker logs -tf --tail="50" '

# NAVIGATION
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# COMPRESSION
alias untargz='tar --same-owner -zxvf'
alias untarbz='tar --same-owner -xjvf'
alias lstargz='tar -ztvf'
alias lstarbz='tar -jtvf'
alias targz='tar -zcvf'
alias tarbz='tar -cjvf'

alias dcrun-basic='sudo docker-compose -f /home/docker/basic.yml'
alias dcrun-plex='sudo docker-compose -f /home/docker/plex.yml'
```

---

https://www.smarthomebeginner.com/create-shortcut-to-commands-using-bashaliases-in-ubuntu/