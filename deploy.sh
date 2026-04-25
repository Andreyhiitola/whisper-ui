#!/bin/bash
set -e

SERVER="root@192.168.1.73"
REMOTE_DIR="/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e"

# commit и push если есть изменения
if ! git diff --quiet || ! git diff --cached --quiet; then
  git add .
  git commit -m "${1:-update}"
  git push
fi

# на сервере: pull → cp → restart
ssh "$SERVER" bash << 'EOF'
  REMOTE_DIR="/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e"
  cd "$REMOTE_DIR/whisper-ui"
  git pull origin main
  cp html/index.html "$REMOTE_DIR/whisper_ui/html/"
  cp html/config.json "$REMOTE_DIR/whisper_ui/html/"
  cp nginx/default.conf "$REMOTE_DIR/whisper_ui/conf/default.conf"
  cd "$REMOTE_DIR/compose/whisper"
  docker compose -f whisper-ui-compose.yml restart whisper-ui
EOF

echo "✅ Готово! https://192.168.1.73:8443"
