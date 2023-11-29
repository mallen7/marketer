#!/bin/bash

# Function to purge files in a given directory
purge_files() {
    local directory=$1

    # Check if the directory exists
    if [[ -d "$directory" ]]; then
        # Find and delete all files in the directory
        find "$directory" -type f -exec rm {} +
        echo "All files in $directory have been deleted."
    else
        echo "Error: Directory $directory does not exist."
    fi
}

# Check if at least one directory path is provided
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 /path/to/directory1 [/path/to/directory2 ...]"
    exit 1
fi

# Loop through all arguments
for dir in "$@"; do
    purge_files "$dir"
done
