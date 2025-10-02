#! /bin/bash

# Script to automate taking the website down and rebuilding it
# I got too lazy to even run the like 4 commands this does (shout out automation)


# Make script terminate on error
set -e

# Go into the readme-website folder

cd /home/readme/readme-website/

# Pull GH
printf "Pulling readme-website/\n"
cd readme-website/
git pull --no-rebase
cd ..

# Rebuild the docker image
printf "Rebuilding Docker Image\n"
docker compose build
yes | docker image prune

# Bring the site down
printf "Bringing website down\n"
docker compose down django

# Back stuff up
printf "Backing media up \n"
./backup.sh

# Bring site back up
printf "Bringing website up"
docker compose up -d

printf "Done"
