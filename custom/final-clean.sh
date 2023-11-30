#!/bin/bash

# Check if a filename is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# The filename is the first argument
filename=$1

# Replace these with your actual file paths
input_file="results/results_tmp.txt"
output_file="results/emails_${filename}"

# Regular expression for email validation
regex='[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'

# Filtering valid email addresses
grep -Eo "$regex" "$input_file" > "$output_file"

echo "Filtered email addresses saved to $output_file"