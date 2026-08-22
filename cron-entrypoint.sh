#!/bin/sh
set -e

LOG_FILE="/readme-website/logs/cleanup.log"
mkdir -p /readme-website/logs

while true; do
  now=$(date +%s)
  next_midnight=$(date -d "tomorrow 00:00:00" +%s)
  sleep_seconds=$((next_midnight - now))
  echo "$(date): Sleeping ${sleep_seconds}s until next cleanup run" >> "$LOG_FILE"
  sleep "$sleep_seconds"
  echo "$(date): Running clean_temp_uploads" >> "$LOG_FILE"
  python manage.py clean_temp_uploads >> "$LOG_FILE" 2>&1
done