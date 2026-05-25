#! /bin/bash

# Script to automate making a sample database
# This does the bare minimum of removing sensitive data
# If you only want a sample database to have certain data ie only vol x then you will have to do that manually :)

# Make the sample database (copies from the production database)
cp db.sqlite3 sample_db.sqlite3

sqlite3 sample_db.sqlite3 "DELETE FROM auth_user;"
sqlite3 sample_db.sqlite3 "DELETE FROM auth_group;"
sqlite3 sample_db.sqlite3 "DELETE FROM auth_permission;"
sqlite3 sample_db.sqlite3 "DELETE FROM auth_group_permission;"
sqlite3 sample_db.sqlite3 "DELETE FROM auth_user_groups;"
sqlite3 sample_db.sqlite3 "DELETE FROM auth_user_user_permissions;"

sqlite3 sample_db.sqlite3 "DELETE FROM magazine_authoradminpermission;"
sqlite3 sample_db.sqlite3 "DELETE FROM magazine_authoradminpermission_author_profiles;"

sqlite3 sample_db.sqlite3 "DELETE FROM django_admin_log;"
sqlite3 sample_db.sqlite3 "DELETE FROM django_session;"