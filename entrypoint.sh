#!/bin/bash

# Migrate database
python3 manage.py migrate

# Start gunicorn
DJANGO_SETTINGS_MODULE='readme_website.settings.prod' gunicorn --bind 0.0.0.0:8000 readme_website.wsgi
