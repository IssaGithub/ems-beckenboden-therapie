#!/bin/bash

# Debug script to find CSS path issues on VPS

echo "=== CSS Path Debugger ==="
echo "Running on: $(hostname)"
echo "Current directory: $(pwd)"
echo "Date: $(date)"
echo ""

# Check site directory structure
echo "=== Site Directory Structure ==="
echo "Site root content:"
ls -la 
echo ""

# Look for CSS files
echo "=== CSS Files ==="
echo "Finding all CSS files in the site directory:"
find . -name "*.css" -type f
echo ""

# Check for specific path problems
echo "=== Path Problems Check ==="
echo "Checking for 'ems-beckenboden-therapie' path:"
find . -path "*ems-beckenboden-therapie*" -type f | head -10
echo ""

# Check HTML files for CSS references
echo "=== HTML File CSS References ==="
echo "Checking index.html for CSS references:"
grep -o '<link[^>]*\.css[^>]*>' index.html || echo "No CSS links found in index.html"
echo ""

echo "Checking anamnesebogen.html for CSS references:"
grep -o '<link[^>]*\.css[^>]*>' anamnesebogen.html || echo "No CSS links found in anamnesebogen.html"
echo ""

# Check Nginx configuration
echo "=== Nginx Configuration ==="
echo "Checking Nginx configuration if available:"
cat /etc/nginx/sites-enabled/beckenbodentraining-heilbronn 2>/dev/null || echo "Cannot access Nginx configuration"
echo ""

# Check for access logs
echo "=== Nginx Access Logs ==="
echo "Last 10 CSS-related requests (if available):"
grep "\.css" /var/log/nginx/access.log 2>/dev/null | tail -10 || echo "Cannot access Nginx logs"
echo ""

echo "=== Debug Complete ==="
