#! /bin/bash
# Script to automate making a sample database
# It also makes the corresponding media folder

set -e

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <folder_name> <volume1> [volume2] ..."
    exit 1
fi

dirname="$1"
shift

KEEP_VOLUMES=$(IFS=,; echo "$*")

mkdir -p "sample_dbs/$dirname"
# Make the sample database (copies from the production database)
cp db.sqlite3 sample_db.sqlite3

# Deletes sensitive data
sqlite3 sample_db.sqlite3 "DELETE FROM auth_user;"
sqlite3 sample_db.sqlite3 "DELETE FROM auth_group;"
sqlite3 sample_db.sqlite3 "DELETE FROM auth_permission;"
sqlite3 sample_db.sqlite3 "DELETE FROM auth_group_permissions;"
sqlite3 sample_db.sqlite3 "DELETE FROM auth_user_groups;"
sqlite3 sample_db.sqlite3 "DELETE FROM auth_user_user_permissions;"

sqlite3 sample_db.sqlite3 "DELETE FROM magazine_authoradminpermission;"
sqlite3 sample_db.sqlite3 "DELETE FROM magazine_authoradminpermission_author_profiles;"

sqlite3 sample_db.sqlite3 "DELETE FROM django_admin_log;"
sqlite3 sample_db.sqlite3 "DELETE FROM django_session;"

# Deletes stuff thats not in the selected vols
sqlite3 sample_db.sqlite3 <<EOF
PRAGMA foreign_keys = ON;

BEGIN;

CREATE TEMP TABLE issues_to_delete AS
SELECT id
FROM magazine_issue
WHERE vol NOT IN ($KEEP_VOLUMES);

DELETE FROM magazine_articleimage
WHERE show_id IN (
    SELECT id
    FROM magazine_article
    WHERE issue_id IN (SELECT id FROM issues_to_delete)
);

DELETE FROM magazine_article_authors
WHERE article_id IN (
    SELECT id
    FROM magazine_article
    WHERE issue_id IN (SELECT id FROM issues_to_delete)
);

DELETE FROM magazine_imagegag_artists
WHERE imagegag_id IN (
    SELECT id
    FROM magazine_imagegag
    WHERE issue_id IN (SELECT id FROM issues_to_delete)
);

DELETE FROM magazine_article
WHERE issue_id IN (SELECT id FROM issues_to_delete);

DELETE FROM magazine_imagegag
WHERE issue_id IN (SELECT id FROM issues_to_delete);

DELETE FROM magazine_rejectedheadline
WHERE issue_id IN (SELECT id FROM issues_to_delete);

DELETE FROM magazine_issue
WHERE id IN (SELECT id FROM issues_to_delete);

DROP TABLE issues_to_delete;

COMMIT;
EOF

# All of the corresponding media
tar_paths=("media/author_images")

for vol in "$@"; do
    path="media/vol$vol"
    if [[ -d "$path" ]]; then
        tar_paths+=("$path")
    else
        echo "Warning: $path does not exist, skipping."
    fi
done

tar -czf "sample_dbs/$dirname/media.tar.gz" "${tar_paths[@]}"
mv "sample_db.sqlite3" "sample_dbs/$dirname/sample_db.sqlite3"