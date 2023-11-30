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
export input_file="./processing/extracted-domains/dirty/${filename}"
export output_file="./processing/extracted-domains/clean/${filename}"

# Regular expression for domain validation
regex='^(([a-zA-Z]{1})|([a-zA-Z]{1}[a-zA-Z]{1})|([a-zA-Z]{1}[0-9]{1})|([0-9]{1}[a-zA-Z]{1})|([a-zA-Z0-9][-a-zA-Z0-9]{0,61}[a-zA-Z0-9]))\.([a-zA-Z]{2,6}|[a-zA-Z0-9-]{2,30}\.[a-zA-Z]{2,3})$'

# Filtering valid domains
egrep "$regex" "$input_file" > "$output_file"

echo "Filtered domains saved to $output_file"
