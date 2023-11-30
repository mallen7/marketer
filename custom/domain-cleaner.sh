#!/bin/bash

export current_date=$(date +"%Y-%m-%d")
export current_time=$(date +"%H:%M:%S")

# Check if a filename is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# The filename is the first argument
export filename=$1

# Replace these with your actual file paths
export input_file="processing/extracted-domains/dirty/${filename}"
export temp_file="processing/extracted-domains/temp/${filename}"
export output_file="processing/extracted-domains/clean/${filename}"

# Preprocess the input file to extract domain names
sed -E 's#http(s)?://([^/]+).*#\2#g' "$input_file" > "$temp_file"

# Regular expression for simple domain validation
regex='^([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$'

# Filtering valid domains
egrep "$regex" "$temp_file" > "$output_file"

echo "Filtered domains saved to $output_file"