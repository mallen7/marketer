#!/bin/bash
clear

# Current date variable
export current_date=$(date +"%Y-%m-%d")
export current_time=$(date +"%H:%M:%S")
export fuid=${current_date}-${current_time}

# Generate a random number between 0000 and 9999 variable
export random_number=$(( RANDOM % 10000 ))
export rand_num=$(printf "%04d" $random_number)

# Clear previous runs
rm -rf ./proj/google-maps-scraper/output/*

# User prompts
read -rp "Enter Google Maps Scraper query: " query
read -rp "Enter email address to send output to: " email

# Google Maps scraper
echo "Running Google Maps Scraper..."
cd proj/google-maps-scraper
python3 ./main.py "${query}"
cd ../..

# Get latest Google Maps query output
echo "Pulling scraper output..."
find "proj/google-maps-scraper/output" -type f -name "*.csv" -not -path "proj/google-maps-scraper/output/all/*" -print0 | xargs -0 ls -t | head -n 1 | xargs -I '{}' cp -fr '{}' "processing/latest-q/tmp_$fuid.csv"
if [ $? -ne 0 ]; then
    echo "Error occurred in find or copy command"
fi

# Cut out the domain column and create new file
echo "Performing ETL operations..."
cut -d',' -f6 "processing/latest-q/tmp_${fuid}.csv" >> "./processing/extracted-domains/dirty/gmaps-extracted-domains.csv"
# rm -f ./processing/latest-q/tmp_output.csv

# Clean up domain data
#echo "Cleaning data 1/2..."
#sed -i '' -E 's#http(s)?://([^/]+)([^ ]*)#\2#g' ./process
ing/extracted-domains/dirty/gmaps-extracted-domains.csv

# Clean domains again
echo "Cleaning data 2/2..."
./custom/domain-cleaner.sh gmaps-extracted-domains.csv
mv gmaps-extracted-domains.csv gmaps-extracted-domains.txt

# rm -f ./processing/extracted-domains/gmaps-extracted-domains-dirty-${current_date}.csv

# Run email scraper
echo "Running email crawler..."
python3 ./proj/emailscraper/main.py ./processing/extracted-domains/clean/gmaps-extracted-domains.txt

# Emailing results
mail -s "Marketer; Google Maps/Email Scraper Results ${current_date}-${current_time}" -a "results/Results_${date_string}_${time_string}.csv" -a "processing/latest-q/tmp_${fuid}.csv" "${email}" < /dev/null
# mutt -s "Marketer; Google Maps/Email Scraper Results ${current_date}-${current_time}" -a "./processing/extracted-emails/gmaps-extracted-emails-${date_string}.csv" -a "./processing/latest-q/tmp_${fuid}.csv" -- $email < /dev/null

# Data Cleanup
./custom/purge_files.sh ./processing 