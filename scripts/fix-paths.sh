#!/bin/bash

# Simple script to fix asset paths in HTML files
# This script runs directly in the deployment process and doesn't require additional dependencies

echo "====== Fixing asset paths in HTML files ======"
echo "Working directory: $(pwd)"

# Find all HTML files in the dist directory
HTML_FILES=$(find ./dist -name "*.html" -type f)
FILE_COUNT=$(echo "$HTML_FILES" | wc -l)
echo "Found $FILE_COUNT HTML files to process"

# Counter for modified files
MODIFIED_COUNT=0

for FILE in $HTML_FILES; do
    # Use sed to replace any paths with the pattern /ems-beckenboden-therapie/ to /
    # This handles both CSS and JS files
    # Note: We're using different sed syntax depending on the OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' 's|/ems-beckenboden-therapie/|/|g' "$FILE"
    else
        # Linux/Windows
        sed -i 's|/ems-beckenboden-therapie/|/|g' "$FILE"
    fi
    
    # Check if file was modified
    if [ $? -eq 0 ]; then
        echo "Fixed paths in: $FILE"
        MODIFIED_COUNT=$((MODIFIED_COUNT + 1))
    fi
done

echo "====== Path fixing complete ======"
echo "Modified $MODIFIED_COUNT HTML files"

# Check for any leftover references to the GitHub path
echo "Checking for any remaining incorrect paths..."
grep -r "ems-beckenboden-therapie" ./dist --include="*.html" || echo "No remaining incorrect paths found!"

echo "====== Done ======"
