#!/bin/bash

# Description:
# This script replaces "IntegrationTypeName:" with "IntegrationTypeName:" in specified files or
# recursively in all files within subdirectories if no files are specified.
# It creates a backup of each original file with a .bak extension before making changes.

# Usage:
# ./replace_connector.sh [file1 file2 ... fileN]
# If no files are specified, the script processes all regular files in subdirectories.

# Function to perform the replacement on a single file
replace_in_file() {
    local file="$1"
    # Use sed to perform the replacement
    # -i.bak creates a backup file with .bak extension
    sed -i.bak 's/IntegrationTypeName:/IntegrationTypeName:/g' "$file"

    # Check if sed was successful
    if [ $? -eq 0 ]; then
        echo "Successfully processed: $file (backup: $file.bak)"
    else
        echo "Error processing: $file"
    fi
}

# Check if at least one filename is provided
if [ "$#" -ge 1 ]; then
    # Loop through all provided files
    for file in "$@"; do
        if [ -f "$file" ]; then
            replace_in_file "$file"
        else
            echo "Skipping: $file (not a regular file)"
        fi
    done
else
    # No arguments provided; process all regular files in subdirectories
    echo "No files specified. Processing all regular files in subdirectories..."

    # Find all regular files and loop through them
    find . -type f | while read -r file; do
        replace_in_file "$file"
    done

    echo "Replacement complete for all files in subdirectories. Backup files have a .bak extension."
fi
