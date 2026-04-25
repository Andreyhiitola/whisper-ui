# Whisper UI

Веб-интерфейс для транскрибации аудио через Whisper и анализа разговоров через LLM.

## Что делает

**Вкладка 1 — Транскрибация**
- Загрузка нескольких аудио/видео файлов
- Две модели: `small` (качество) и `base` (быстро)
- Языки: русский, английский, украинский, авто
- Форматы: TXT, SRT, VTT
- Автосохранение в папку проекта (File System Access API, Chrome/Edge + HTTPS)

**Вкладка 2 — Анализ и чат**
- Сценарий проверки: текст / PDF (PDF.js) / фото (Tesseract OCR)
- Анализ через LLM: OpenRouter (Qwen, Llama и др.) или DeepSeek
- 4 шаблона: отчёт, таблица, тональность, критические нарушения
- Чат для уточнений
- Сохранение чата в папку проекта или выбранную папку

## Стек

| Компонент | Что |
|-----------|-----|
| `whisper` | onerahmet/openai-whisper-asr-webservice, модель `small`, порт 9000 |
| `whisper-fast` | то же, модель `base`, порт 9001 |
| `whisper-ui` | nginx:alpine, HTTPS 8443, раздаёт UI и проксирует /asr |
| LLM | OpenRouter API или DeepSeek API (ключи в браузере) |

## Быстрый старт

```bash
git clone https://github.com/Andreyhiitola/whisper-ui.git
cd whisper-ui
```

Полная инструкция по первоначальной установке — в [SETUP.md](SETUP.md).

## Деплой изменений

```bash
bash deploy.sh "описание"
```

`deploy.sh` — локальный файл (не в git). Коммитит, пушит на GitHub, по SSH обновляет файлы на сервере и перезапускает контейнер.

## Адреса

| | |
|--|--|
| UI | https://192.168.1.73:8443 |
| Whisper API (quality) | http://192.168.1.73:9000 |
| Whisper API (fast) | http://192.168.1.73:9001 |

## API ключи

Вводятся в интерфейсе (⚙️ Настройки API), хранятся в `localStorage`. Дефолты можно прописать в `html/config.json`.

| Провайдер | Где получить | Цена |
|-----------|-------------|------|
| OpenRouter | openrouter.ai/keys | Бесплатно (Llama 3.3 70B и др.) |
| DeepSeek | platform.deepseek.com | ~$0.0003/запрос |
