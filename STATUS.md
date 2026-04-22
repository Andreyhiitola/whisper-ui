# Whisper UI — Статус проекта

## Сервер
- OMV VM: 192.168.1.73 (Proxmox VM 630, node seaport)
- Whisper ASR: http://192.168.1.73:9000
- Whisper UI: http://192.168.1.73:8090

## Пути на сервере
- Compose файл: `/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/compose/whisper/whisper.yml`
- HTML файлы: `/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/whisper_ui/html/`
- Nginx конфиг: `/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/whisper_ui/conf/default.conf`
- Кэш модели: `/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/wisper_/`

## Модель
- Whisper small (~460MB), скачана и закэширована

## Сделано
- [x] Расширен диск VM с 16G до 36G
- [x] Запущен Whisper ASR контейнер (порт 9000)
- [x] Запущен Nginx контейнер для UI (порт 8090)
- [x] Nginx проксирует /asr на Whisper (без CORS проблем)

## TODO
- [ ] Загрузить обновлённый index.html на сервер:
  ```
  scp ~/Desktop/whisper-ui/html/index.html root@192.168.1.73:/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/whisper_ui/html/index.html
  ```

## Возможности UI
- Загрузка нескольких файлов, обработка по очереди
- Выбор языка (ru / en / uk / авто)
- Форматы: txt, SRT, VTT (с таймкодами)
- Прогресс загрузки и транскрибации с таймером
- Скачать / Копировать результат для каждого файла
