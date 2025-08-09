#!/bin/bash

# EMERGENCY FIX SCRIPT
# This script copies CSS and JS files to where the browser is actually looking for them
# Run this script directly on the server after deployment

echo "===== EMERGENCY PATH FIX SCRIPT ====="
echo "Current directory: $(pwd)"
echo "Date: $(date)"

# Make sure we're in the web root
if [ ! -f "index.html" ]; then
  echo "ERROR: Not in web root directory (index.html not found)"
  echo "Please run this script from your website's root directory"
  exit 1
fi

# Create the required directory structure if it doesn't exist
echo "Creating directory structure..."
mkdir -p ems-beckenboden-therapie/_astro

# Find all CSS files
echo "Locating CSS files..."
CSS_FILES=$(find . -name "*.css" -not -path "./ems-beckenboden-therapie/*")
echo "Found $(echo "$CSS_FILES" | wc -l) CSS files"

# Find all JS files
echo "Locating JavaScript files..."
JS_FILES=$(find . -name "*.js" -not -path "./ems-beckenboden-therapie/*")
echo "Found $(echo "$JS_FILES" | wc -l) JavaScript files"

# Copy CSS files to the ems-beckenboden-therapie path
echo "Copying CSS files to GitHub Pages path structure..."
for FILE in $CSS_FILES; do
  # Extract relative path (remove leading ./)
  REL_PATH=${FILE#./}
  DIR_PATH=$(dirname "$REL_PATH")
  
  # Create directory in ems-beckenboden-therapie if needed
  if [[ "$DIR_PATH" != "." ]]; then
    mkdir -p "ems-beckenboden-therapie/$DIR_PATH"
    cp "$FILE" "ems-beckenboden-therapie/$REL_PATH"
    echo "Copied: $REL_PATH -> ems-beckenboden-therapie/$REL_PATH"
  fi
done

# Copy JS files to the ems-beckenboden-therapie path
echo "Copying JavaScript files to GitHub Pages path structure..."
for FILE in $JS_FILES; do
  # Extract relative path (remove leading ./)
  REL_PATH=${FILE#./}
  DIR_PATH=$(dirname "$REL_PATH")
  
  # Create directory in ems-beckenboden-therapie if needed
  if [[ "$DIR_PATH" != "." ]]; then
    mkdir -p "ems-beckenboden-therapie/$DIR_PATH"
    cp "$FILE" "ems-beckenboden-therapie/$REL_PATH"
    echo "Copied: $REL_PATH -> ems-beckenboden-therapie/$REL_PATH"
  fi
done

# For the specific files mentioned in the errors
echo "Creating specific files mentioned in error messages..."

# CSS files with specific names from error messages
SPECIFIC_CSS=(
  "index.auSXMeHl.css"
  "anamnesebogen.BsfnLu-n.css"
)

# JS files with specific names from error messages
SPECIFIC_JS=(
  "ContactForm.astro_astro_type_script_index_0_lang.DN3grZAw.js"
  "Layout.astro_astro_type_script_index_0_lang.B4RrDVrk.js"
)

# Find and copy specific CSS files
for FILENAME in "${SPECIFIC_CSS[@]}"; do
  FOUND_FILE=$(find . -name "$FILENAME" -not -path "./ems-beckenboden-therapie/*")
  if [ -n "$FOUND_FILE" ]; then
    DIR_PATH=$(dirname "$FOUND_FILE")
    TARGET_DIR="ems-beckenboden-therapie/$DIR_PATH"
    mkdir -p "$TARGET_DIR"
    cp "$FOUND_FILE" "$TARGET_DIR/"
    echo "Specifically copied: $FOUND_FILE -> $TARGET_DIR/"
  else
    echo "Warning: Couldn't find specific CSS file: $FILENAME"
  fi
done

# Find and copy specific JS files
for FILENAME in "${SPECIFIC_JS[@]}"; do
  FOUND_FILE=$(find . -name "$FILENAME" -not -path "./ems-beckenboden-therapie/*")
  if [ -n "$FOUND_FILE" ]; then
    DIR_PATH=$(dirname "$FOUND_FILE")
    TARGET_DIR="ems-beckenboden-therapie/$DIR_PATH"
    mkdir -p "$TARGET_DIR"
    cp "$FOUND_FILE" "$TARGET_DIR/"
    echo "Specifically copied: $FOUND_FILE -> $TARGET_DIR/"
  else
    echo "Warning: Couldn't find specific JS file: $FILENAME"
  fi
done

echo "===== EMERGENCY FIX COMPLETE ====="
echo "Next steps:"
echo "1. Clear your browser cache"
echo "2. Restart Nginx with: sudo systemctl restart nginx"
echo "3. Test the website again"
