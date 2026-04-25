#!/bin/bash
set -e

DISK="/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e"
REPO="$DISK/whisper-ui"

cd "$REPO"
git fetch origin main
git checkout origin/main -- html/index.html html/config.json nginx/default.conf

cp html/index.html    "$DISK/whisper_ui/html/"
cp html/config.json   "$DISK/whisper_ui/html/"
cp nginx/default.conf "$DISK/whisper_ui/conf/default.conf"

cd "$DISK/compose/whisper"
docker compose -f whisper-ui-compose.yml restart whisper-ui

echo "✅ Готово! https://192.168.1.73:8443"
