# Whisper UI

Веб-интерфейс для транскрибации речи через [OpenAI Whisper ASR](https://github.com/openai/whisper), запущенный локально через Docker.

## Возможности

- Загрузка нескольких аудио/видео файлов
- Обработка файлов по очереди
- Выбор языка (русский, английский, украинский, авто)
- Форматы вывода: текст, SRT, VTT (с таймкодами)
- Прогресс загрузки и транскрибации с таймером
- Скачать или скопировать результат для каждого файла

## Стек

- [onerahmet/openai-whisper-asr-webservice](https://github.com/ahmetoner/whisper-asr-webservice) — Whisper REST API
- Nginx — раздача UI и проксирование запросов

## Быстрый старт

1. Клонируй репозиторий:
   ```bash
   git clone https://github.com/Andreyhiitola/whisper-ui.git
   cd whisper-ui
   ```

2. Настрой пути в `docker-compose.yml` под своё окружение (пути к кэшу модели и HTML).

3. Запусти:
   ```bash
   docker compose up -d
   ```

4. Открой браузер: `http://localhost:8090`

## Модели Whisper

В `docker-compose.yml` можно выбрать модель через переменную `ASR_MODEL`:

| Модель | Размер | Качество |
|--------|--------|----------|
| tiny   | 75 MB  | низкое   |
| base   | 145 MB | базовое  |
| small  | 460 MB | хорошее  |
| medium | 1.5 GB | высокое  |
| large  | 3 GB   | лучшее   |
