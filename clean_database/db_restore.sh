#!/usr/bin/env bash
set -euo pipefail

STATUS_FILE="/restore_status/completed"

if [ -f "$STATUS_FILE" ]; then
  echo "[restore] Database already restored. Skipping."
  exit 0
fi

echo "[restore] Starting database restore..."
echo "[restore] Source: $S3_DUMP_URL"

apt-get update -qq && apt-get install -y -qq curl unzip

TMPDIR="/restore_cache"
EXTRACT_DIR="/restore_cache/extracted"

if [ -d "$EXTRACT_DIR" ]; then
  echo "[restore] Found cached download, skipping download step."
else
  echo "[restore] Downloading and extracting..."
  mkdir -p "$EXTRACT_DIR"
  curl -fSL --progress-bar "$S3_DUMP_URL" | tar -xz -C "$EXTRACT_DIR"
  echo "[restore] Download and extraction complete."
fi

echo "[restore] Contents of extracted archive:"
ls -lh "$EXTRACT_DIR"
cd $EXTRACT_DIR

echo "[restore] Running regenbash.sh..."
echo "⛃ Setting up the local Neotoma database:"
if psql -U ${PGUSER} -h ${PGHOST} -p ${PGPORT} -f dbsetup.sql
then
  echo "Empty database is now set up."
  echo " ▶ Restoring database content:"
  psql -U $PGUSER -h $PGHOST -p $PGPORT -d postgres -f neotoma_clean*.sql -v ON_ERROR_STOP=1
  echo "[restore] Restore completed successfully."
  mkdir -p /restore_status
  touch "$STATUS_FILE"
else
  echo "[restore] Restore failed. Status file will not be written."
  echo "[restore] Fix the issue and run docker compose up again."
  exit 1
fi