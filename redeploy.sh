#! /bin/bash

# Script to automate taking the website down and rebuilding it
# I got too lazy to even run the like 4 commands this does (shout out automation)

# Make sure this is being run from the readme folder (/home/readme)

# Make script terminate on error
set -e

# Go into the readme-website folder

cd readme-website/

# Rebuild the docker image
printf "Rebuilding Docker Image\n"
docker compose build
yes | docker image prune

# Bring the site down
printf "Bringing website down\n"
docker compose down django

# Back stuff up (go back to the readme folder)
printf "Backing media up \n"
cd ..
./backup.sh

# Bring site back up (in the website folder)
printf "Bringing website up"
cd readme-website/
docker compose up -d

printf "Done"
