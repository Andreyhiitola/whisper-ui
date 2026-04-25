# Установка с нуля

Сервер: OpenMediaVault (Proxmox VM 630, node seaport), IP `192.168.1.73`.

## 1. Подготовка сервера

```bash
ssh root@192.168.1.73

# Создать директории
DISK="/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e"
mkdir -p $DISK/whisper_ui/html
mkdir -p $DISK/whisper_ui/conf
mkdir -p $DISK/whisper_ui/ssl
mkdir -p $DISK/wisper_          # кэш моделей Whisper
mkdir -p $DISK/compose/whisper

# Клонировать репозиторий
cd $DISK
git clone https://github.com/Andreyhiitola/whisper-ui.git
```

## 2. SSL сертификат (самоподписанный)

```bash
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout $DISK/whisper_ui/ssl/nginx.key \
  -out $DISK/whisper_ui/ssl/nginx.crt \
  -subj "/CN=192.168.1.73"
```

## 3. Скопировать файлы

```bash
cd $DISK/whisper-ui
cp html/index.html   $DISK/whisper_ui/html/
cp html/config.json  $DISK/whisper_ui/html/
cp nginx/default.conf $DISK/whisper_ui/conf/default.conf
```

## 4. Compose файл и запуск

```bash
cp docker-compose.yml $DISK/compose/whisper/whisper-ui-compose.yml
cd $DISK/compose/whisper
docker compose -f whisper-ui-compose.yml up -d
```

Проверить: https://192.168.1.73:8443

## 5. Настроить деплой с локальной машины

### На сервере — добавить SSH ключ

```bash
echo "YOUR_PUBLIC_KEY" >> ~/.ssh/authorized_keys
```

Посмотреть свой публичный ключ локально: `cat ~/.ssh/id_ed25519.pub`

### На локальной машине — создать deploy.sh

Файл не хранится в git (у каждого своя версия). Создать в корне репозитория:

```bash
cat > deploy.sh << 'SCRIPT'
#!/bin/bash
set -e

SERVER="root@192.168.1.73"
REMOTE_DIR="/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e"

if ! git diff --quiet || ! git diff --cached --quiet; then
  git add .
  git commit -m "${1:-update}"
  git push
fi

ssh -o IdentitiesOnly=yes -i ~/.ssh/id_ed25519 "$SERVER" bash << 'EOF'
  REMOTE_DIR="/srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e"
  cd "$REMOTE_DIR/whisper-ui"
  git fetch origin main
  git checkout origin/main -- html/index.html html/config.json nginx/default.conf
  cp html/index.html   "$REMOTE_DIR/whisper_ui/html/"
  cp html/config.json  "$REMOTE_DIR/whisper_ui/html/"
  cp nginx/default.conf "$REMOTE_DIR/whisper_ui/conf/default.conf"
  cd "$REMOTE_DIR/compose/whisper"
  docker compose -f whisper-ui-compose.yml restart whisper-ui
EOF

echo "✅ Готово! https://192.168.1.73:8443"
SCRIPT
chmod +x deploy.sh
```

Запуск: `bash deploy.sh "описание изменений"`

## 6. Пути на сервере

| Что | Путь |
|-----|------|
| Репозиторий | `/srv/.../whisper-ui/` |
| HTML файлы | `/srv/.../whisper_ui/html/` |
| Nginx конфиг | `/srv/.../whisper_ui/conf/default.conf` |
| SSL сертификат | `/srv/.../whisper_ui/ssl/` |
| Кэш моделей | `/srv/.../wisper_/` |
| Compose файл | `/srv/.../compose/whisper/whisper-ui-compose.yml` |

`...` = `dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e`

## 7. Обновление контейнеров Whisper

```bash
ssh root@192.168.1.73
cd /srv/dev-disk-by-uuid-e3906cb9-c585-4088-9de4-278d2769849e/compose/whisper
docker compose -f whisper-ui-compose.yml pull
docker compose -f whisper-ui-compose.yml up -d
```
