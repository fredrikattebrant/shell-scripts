#!/bin/bash

# Compare two JSON files and output the differences

# Usage: ./diffJSONfiles.sh <file1> <file2>

# Check if two arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: ./diffJSONfiles.sh <file1> <file2>"
    exit 1
fi

# Get the file names from the arguments
diff -y --suppress-common-lines <(jq -S . $1) <(jq -S . $2)
