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

## Пути

```
/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/
  compose/whisper/whisper.yml     — docker compose файл
  whisper_ui/html/index.html      — веб-интерфейс
  whisper_ui/conf/default.conf    — nginx конфиг
  wisper_/                        — кэш моделей Whisper
```

## Nginx

Nginx проксирует `/asr` на Whisper — нет CORS проблем, всё на одном порту 8090.

```
браузер → nginx:8090 → whisper:9000
```

## Деплой

```bash
cd ~/Desktop/whisper-ui
./deploy.sh "описание"
```

Делает: git commit → git push → scp файлов → docker restart whisper-ui
