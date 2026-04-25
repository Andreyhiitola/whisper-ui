# Whisper UI — Статус проекта

## Сервер

| | |
|--|--|
| Сервер | OpenMediaVault, Proxmox VM 630, node seaport |
| IP | 192.168.1.73 |
| UI | https://192.168.1.73:8443 |
| Whisper quality | http://192.168.1.73:9000 (модель small) |
| Whisper fast | http://192.168.1.73:9001 (модель base) |

## Пути на сервере

```
/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/
  whisper-ui/          ← git репозиторий
  whisper_ui/
    html/              ← index.html, config.json
    conf/              ← default.conf
    ssl/               ← nginx.crt, nginx.key
  wisper_/             ← кэш моделей Whisper
  compose/whisper/
    whisper-ui-compose.yml
```

## Реализовано

- [x] HTTPS (самоподписанный сертификат, порт 8443)
- [x] HTTP → HTTPS редирект (порт 80)
- [x] Два Whisper контейнера: quality (small) и fast (base)
- [x] Мультифайловая транскрибация с прогрессом и ETA
- [x] Автосохранение в папку проекта (File System Access API)
- [x] Подпапка на каждый аудиофайл + автосоздание prompt.txt
- [x] Анализ через OpenRouter (Qwen 2.5, Llama 3.3 и др.)
- [x] Анализ через DeepSeek (V3, R1)
- [x] 4 шаблона анализа: отчёт / таблица / тональность / критика
- [x] Загрузка сценария: PDF (PDF.js), фото (Tesseract OCR), TXT
- [x] Чат с историей контекста
- [x] Сохранение чата в папку проекта или выбранную папку
- [x] Автосохранение анализа в папку проекта
- [x] config.json — дефолтные настройки с сервера
- [x] AmneziaWG VPN
- [x] deploy.sh — локальный скрипт деплоя (gitignored)

## Не в git

- `deploy.sh` — у каждой машины свой (шаблон в SETUP.md)
- SSL ключи — только на сервере
- Кэш моделей Whisper
- Папки с проектами (транскрипции, анализы)
