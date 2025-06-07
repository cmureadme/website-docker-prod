#!/bin/bash

# Collect staticfiles
python3 manage.py collectstatic --no-input
python3 manage.py makemigrations
python3 manage.py migrate

# Start gunicorn
gunicorn --bind 0.0.0.0:8000 readme_website.wsgi
