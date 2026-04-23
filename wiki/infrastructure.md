# Инфраструктура

## Сервер

- **Proxmox** хост: `seaport`
- **OMV VM**: 630, IP `192.168.1.73`
- CPU: 12 vCPU, RAM: 20 GB, Диск: 36 GB (sata0)
- Большой диск: 938 GB (sata2, примонтирован на `/srv/dev-disk-by-uuid-e3906cb9-...`)

## Контейнеры

| Контейнер | Образ | Порт |
|-----------|-------|------|
| whisper | onerahmet/openai-whisper-asr-webservice | 9000 |
| whisper-ui | nginx:alpine | 8090 |
| amnezia-vpn | amneziavpn/amnezia-wg | 1080 (SOCKS) |

Whisper и Nginx — стандартные образы, сборка не нужна.

## Пути

```
/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/
  compose/whisper/whisper.yml     — docker compose файл
  whisper_ui/html/index.html      — веб-интерфейс
  whisper_ui/conf/default.conf    — nginx конфиг
  wisper_/                        — кэш моделей Whisper
  compose/Amnezia_VPN/            — compose и конфиг AmneziaWG
  compose/Amnezia_VPN/config/awg0.conf — клиентский конфиг VPN (не в git)
```

## AmneziaWG VPN

Клиент AmneziaWG запущен на OMV, туннелирует трафик через внешний сервер.

- Compose: `/srv/.../compose/Amnezia_VPN/Amnezia_VPN.yml`
- Конфиг: `/srv/.../compose/Amnezia_VPN/config/awg0.conf` (из `vpn://` URI)
- Порт: 1080/tcp (SOCKS5 прокси через туннель)
- Требует: `privileged: true`, `devices: /dev/net/tun`, убрать DNS и `::/0` из AllowedIPs
- Команда запуска: `wg-quick up /etc/amneziawg/awg0.conf && sleep infinity`

## Nginx

Nginx раздаёт статику и проксирует `/asr` на Whisper — нет CORS проблем, всё через один порт 8090.

```
браузер → nginx:8090 → /           → index.html
                     → /asr        → whisper:9000
```

Groq и DeepSeek вызываются напрямую из браузера (fetch к внешним API). На сервере не проксируются.

## Деплой

**С локального компьютера** (если SSH работает):
```bash
cd ~/Desktop/whisper-ui
./deploy.sh "описание изменений"
```

**С сервера** (через CTerm OMV):
```bash
/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/whisper-ui/update.sh
```

`update.sh` делает:
1. `git pull` — забирает изменения с GitHub
2. `cp` — копирует `index.html` и `default.conf` в рабочую папку nginx
3. `docker restart whisper-ui` — перезапускает nginx

## Репозиторий

[github.com/Andreyhiitola/whisper-ui](https://github.com/Andreyhiitola/whisper-ui)
