#!/bin/bash
set -e

SERVER="root@192.168.1.73"
REMOTE_HTML="/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/whisper_ui/html/"
REMOTE_NGINX="/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/whisper_ui/conf/default.conf"
REMOTE_COMPOSE_DIR="/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/compose/whisper"
REMOTE_COMPOSE="$REMOTE_COMPOSE_DIR/whisper.yml"

# commit и push если есть изменения
if ! git diff --quiet || ! git diff --cached --quiet; then
  git add .
  git commit -m "${1:-update}"
  git push
fi

# копирование файлов
scp html/index.html "$SERVER:$REMOTE_HTML"
scp nginx/default.conf "$SERVER:$REMOTE_NGINX"
scp docker-compose.yml "$SERVER:$REMOTE_COMPOSE"
scp -r ocr "$SERVER:$REMOTE_COMPOSE_DIR/"

# перезапуск с пересборкой образа OCR
ssh "$SERVER" "cd $REMOTE_COMPOSE_DIR && docker compose -f whisper.yml up -d --force-recreate --build"

echo "Готово! Стек запущен, OCR-сервис пересобран."
