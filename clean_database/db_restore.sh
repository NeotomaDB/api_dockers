#!/usr/bin/env bash
set -euo pipefail

STATUS_FILE="/restore_status/completed"

# -------------------------------------------------------------------
# Skip restore if it has already been completed successfully.
# Delete the postgres_data volume to force a fresh restore.
# -------------------------------------------------------------------
if [ -f "$STATUS_FILE" ]; then
  echo "[restore] Database already restored. Skipping."
  exit 0
fi

echo "[restore] Starting database restore..."
echo "[restore] Source: $S3_DUMP_URL"

# -------------------------------------------------------------------
# Install dependencies (curl + unzip are all we need)
# -------------------------------------------------------------------
apt-get update -qq && apt-get install -y -qq curl unzip

# -------------------------------------------------------------------
# Detect dump format and restore accordingly.
#
# Streaming approach:
#   curl (download) -> unzip -p (decompress to stdout) -> psql/pg_restore
#
# This avoids writing the full dump to disk at any point.
# unzip -p extracts the target file to stdout.
# -------------------------------------------------------------------

echo "[restore] Downloading and restoring (streaming)..."

# Download to a temp file for unzip (unzip needs seekable input, curl | unzip -p handles this)
TMPZIP=$(mktemp /tmp/dump.XXXXXX.zip)

# Trap to clean up temp file on exit
trap 'rm -f "$TMPZIP"' EXIT

echo "[restore] Downloading zip..."
curl -fSL --progress-bar "$S3_DUMP_URL" -o "$TMPZIP"

echo "[restore] Download complete. Beginning restore..."

# Check if the dump inside is plain SQL or custom format
# by reading the first few bytes after extracting
FIRST_BYTES=$(unzip -p "$TMPZIP" "$DUMP_FILENAME" | head -c 5)

if [[ "$FIRST_BYTES" == "PGDMP" ]]; then
  echo "[restore] Detected custom/binary pg_dump format. Using pg_restore..."
  unzip -p "$TMPZIP" "$DUMP_FILENAME" | pg_restore \
    --no-owner \
    --no-acl \
    --exit-on-error \
    -d "$PGDATABASE"
else
  echo "[restore] Detected plain SQL format. Using psql..."
  unzip -p "$TMPZIP" "$DUMP_FILENAME" | psql \
    --set ON_ERROR_STOP=1 \
    -d "$PGDATABASE"
fi

echo "[restore] Restore completed successfully."

# Mark as done so subsequent `docker compose up` calls skip the restore
mkdir -p /restore_status
touch "$STATUS_FILE"