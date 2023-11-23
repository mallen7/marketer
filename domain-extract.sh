#!/bin/bash

current_date=$(date +"%Y-%m-%d")

find "./proj/google-maps-scraper/output" -type f -print0 | xargs -0 ls -t | head -n 1 | xargs -I '{}' cp '{}' "./processing/latest-q/tmp_output.csv"

cut -d',' -f6 ./processing/latest-q/tmp_output.csv > ./processing/extracted-domains/gmaps-extracted-domains-dirty-${current_date}.csv

sed -E 's#http(s)?://([^/]+)([^ ]*)#\2#g' ./processing/extracted-domains/gmaps-extracted-domains-dirty-${current_date}.csv > ./processing/extracted-domains/gmaps-extracted-domains-clean-${current_date}.txt

rm -f ./processing/extracted-domains/gmaps-extracted-domains-dirty-${current_date}.csv

python3 ./proj/emailscraper/main.py ./processing/extracted-domains/gmaps-extracted-domains-clean-${current_date}.txt