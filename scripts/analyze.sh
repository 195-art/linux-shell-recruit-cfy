#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 FILE"
    exit 1
fi

if [[ ! -f "$1" ]]; then
    echo "Error: file $1 does not exist"
    exit 1
fi

error_count=$(grep -c "ERROR" "$1")
top_code=$(grep 'ERROR' "$1" | cut -d' ' -f5 | cut -d'=' -f2 | sort | uniq -c | sort -nr | head -n1 | awk '{print $2}')

echo "Total ERROR: $error_count"
echo "Top Code: $top_code"
