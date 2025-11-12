#!/bin/bash

# Collect static files
python3 manage.py collectstatic --no-input --settings=readme_website.settings.prod

# Migrate database
python3 manage.py migrate --settings=readme_website.settings.prod

# Start gunicorn
DJANGO_SETTINGS_MODULE='readme_website.settings.prod' gunicorn --bind 0.0.0.0:8000 readme_website.wsgi
