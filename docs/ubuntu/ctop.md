# Ctop - это `top` или `htop` для контейнеров

![](https://github.com/bcicen/ctop/raw/master/_docs/img/logo.png){ align=center width="300" }

#

![release][release] ![homebrew][homebrew] ![macports][macports] ![scoop][scoop]

Удобный интерфейс для метрик контейнеров

`ctop` предоставляет краткий и сжатый обзор метрик в реальном времени для нескольких контейнеров:

![](https://github.com/bcicen/ctop/raw/master/_docs/img/grid.gif)

`ctop` поставляется со встроенной поддержкой Docker и runC

## Установка

Загрузите [последний релиз](https://github.com/bcicen/ctop/releases) для вашей платформы:

#### Debian/Ubuntu

Поддерживается [сторонним разработчиком](https://packages.azlux.fr/)
```bash
sudo apt-get install ca-certificates curl gnupg lsb-release
curl -fsSL https://azlux.fr/repo.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/azlux-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian \
  $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azlux.list >/dev/null
sudo apt-get update
sudo apt-get install docker-ctop
```

#### Arch

```bash
sudo pacman -S ctop
```

_`ctop` is also available for Arch in the [AUR](https://aur.archlinux.org/packages/ctop-bin/)_


#### Linux (Generic)

```bash
sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 -O /usr/local/bin/ctop
sudo chmod +x /usr/local/bin/ctop
```

#### OS X

```bash
brew install ctop
```
or
```bash
sudo port install ctop
```
or
```bash
sudo curl -Lo /usr/local/bin/ctop https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-darwin-amd64
sudo chmod +x /usr/local/bin/ctop
```

#### Windows

`ctop` is available in [scoop](https://scoop.sh/):

```powershell
scoop install ctop
```

#### Docker

```bash
docker run --rm -ti \
  --name=ctop \
  --volume /var/run/docker.sock:/var/run/docker.sock:ro \
  quay.io/vektorlab/ctop:latest
```

### Опции запуска

Option | Description
--- | ---
`-a`	| show active containers only
`-f <string>` | set an initial filter string
`-h`	| display help dialog
`-i`  | invert default colors
`-r`	| reverse container sort order
`-s`  | select initial container sort field
`-v`	| output version information and exit

[build]: _docs/build.md
[connectors]: _docs/connectors.md
[single_view]: _docs/single.md
[release]: https://img.shields.io/github/release/bcicen/ctop.svg "ctop"
[homebrew]: https://img.shields.io/homebrew/v/ctop.svg "ctop"
[macports]: https://repology.org/badge/version-for-repo/macports/ctop.svg?header=macports "ctop"
[scoop]: https://img.shields.io/scoop/v/ctop?bucket=main "ctop"

## Альтернативы

См.  [Awesome Docker список](https://github.com/veggiemonk/awesome-docker/blob/master/README.md#terminal) для получения информации об аналогичных инструментах для работы с Docker.