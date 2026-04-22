#!/bin/bash
set -e

SERVER="root@192.168.1.73"
REMOTE_HTML="/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/whisper_ui/html/"
REMOTE_NGINX="/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/whisper_ui/conf/default.conf"
REMOTE_COMPOSE="/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/compose/whisper/whisper.yml"

# commit и push если есть изменения
if ! git diff --quiet || ! git diff --cached --quiet; then
  git add .
  git commit -m "${1:-update}"
  git push
fi

# деплой на сервер
scp html/index.html "$SERVER:$REMOTE_HTML"
scp nginx/default.conf "$SERVER:$REMOTE_NGINX"
scp docker-compose.yml "$SERVER:$REMOTE_COMPOSE"

echo "Готово! Обновляю nginx..."
ssh "$SERVER" "docker restart whisper-ui"
echo "Задеплоено успешно."
