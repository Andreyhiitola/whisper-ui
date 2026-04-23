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

Whisper и Nginx — стандартные образы, сборка не нужна.

## Пути

```
/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/
  compose/whisper/whisper.yml     — docker compose файл
  whisper_ui/html/index.html      — веб-интерфейс
  whisper_ui/conf/default.conf    — nginx конфиг
  wisper_/                        — кэш моделей Whisper
```

## Nginx

Nginx раздаёт статику и проксирует `/asr` на Whisper — нет CORS проблем, всё через один порт 8090.

```
браузер → nginx:8090 → /           → index.html
                     → /asr        → whisper:9000
```

Groq и DeepSeek вызываются напрямую из браузера (fetch к внешним API). На сервере не проксируются.

## Деплой

```bash
cd ~/Desktop/whisper-ui
./deploy.sh "описание изменений"
```

Делает:
1. `git commit` + `git push` (если есть изменения)
2. `scp` — копирует `index.html`, `default.conf`, `whisper.yml` на сервер
3. `docker restart whisper-ui` — перезапускает nginx

## Репозиторий

[github.com/Andreyhiitola/whisper-ui](https://github.com/Andreyhiitola/whisper-ui)
