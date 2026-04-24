#!/bin/bash
set -e

REPO="/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/whisper-ui"
HTML_SRC="$REPO/html/index.html"
HTML_DST="/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/whisper_ui/html/index.html"
NGINX_SRC="$REPO/nginx/default.conf"
NGINX_DST="/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/whisper_ui/conf/default.conf"

cd "$REPO"
git pull --rebase

cp "$HTML_SRC" "$HTML_DST"
cp "$NGINX_SRC" "$NGINX_DST"

docker restart whisper-ui
echo "Готово!"
