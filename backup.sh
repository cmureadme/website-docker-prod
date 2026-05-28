#!/bin/bash

set -e

# Database to back up
db="/home/readme/website-docker-prod/db.sqlite3"

# Media folder to back up
media="/home/readme/website-docker-prod/media"

# Directory containing backups
backup_dir='/var/lib/readme-website/backups'

last_backup_id="$(ls "${backup_dir}" | sort -n | tail -1)"

# Current Date yyyy-mm-dd
cur_date=$(date +%Y-%m-%d)
# Current time
cur_time=$(date +%H:%M:%S.%N)

printf "Timestamp: %s %s\n" "${cur_date}" "${cur_time}" >&2
printf "Last backup id: %s\n" "${last_backup_id}" >&2

if [ -z "${last_backup_id}" ]; then
    printf "Backing up to: %s\n" "${backup_dir}/0" >&2

    mkdir "${backup_dir}/0"
    printf "\nBacking up db...\n" >&2
    rsync -av "${db}" "${backup_dir}/0/"
    printf "\nBacking up media...\n" >&2
    rsync -av "${media}" "${backup_dir}/0/media"

    printf "%s %s\n" > "${backup_dir}/0/timestamp.txt" "${cur_date}" "${cur_time}"
else
    backup_id="$((last_backup_id+1))"

    printf "Backing up to: %s\n" "${backup_dir}/${backup_id}"

    mkdir "${backup_dir}/${backup_id}"
    printf "\nBacking up db...\n" >&2
    rsync -av "${db}" "${backup_dir}/${backup_id}/"
    printf "\nBacking up media...\n" >&2
    rsync -av --delete --link-dest="${backup_dir}/${last_backup_id}/media/" "${media}/" "${backup_dir}/${backup_id}/media/"

    printf "%s %s\n" > "${backup_dir}/${backup_id}/timestamp.txt" "${cur_date}" "${cur_time}"
fi

printf "\nSuccessful\n" >&2
