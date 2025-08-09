#!/bin/bash

# Annette Fneiche - EMS Beckenboden Therapie - VPS Deployment Script
# Dieses Script baut die Astro.js Anwendung und deployed sie auf Ihren VPS

# Farben für bessere Ausgabe
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Konfiguration - BITTE ANPASSEN!
VPS_HOST="beckenbodentraining-heilbronn.de"
VPS_USER="your-username"
VPS_PATH="/var/www/beckenbodentraining-heilbronn"
SSH_KEY_PATH="~/.ssh/id_rsa"  # Pfad zu Ihrem SSH-Key

# Funktionen
print_header() {
    echo -e "${BLUE}"
    echo "==========================================="
    echo "  Annette Fneiche Deployment"
    echo "==========================================="
    echo -e "${NC}"
}

print_step() {
    echo -e "${YELLOW}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Überprüfe Voraussetzungen
check_requirements() {
    print_step "Überprüfe Voraussetzungen..."
    
    # Node.js überprüfen
    if ! command -v node &> /dev/null; then
        print_error "Node.js ist nicht installiert!"
        exit 1
    fi
    
    # npm überprüfen
    if ! command -v npm &> /dev/null; then
        print_error "npm ist nicht installiert!"
        exit 1
    fi
    
    # SSH überprüfen
    if ! command -v ssh &> /dev/null; then
        print_error "SSH ist nicht installiert!"
        exit 1
    fi
    
    # rsync überprüfen
    if ! command -v rsync &> /dev/null; then
        print_error "rsync ist nicht installiert!"
        exit 1
    fi
    
    print_success "Alle Voraussetzungen erfüllt"
}

# Dependencies installieren
install_dependencies() {
    print_step "Installiere Dependencies..."
    if npm install; then
        print_success "Dependencies erfolgreich installiert"
    else
        print_error "Fehler beim Installieren der Dependencies"
        exit 1
    fi
}

# Build erstellen mit VPS Konfiguration
build_project() {
    print_step "Erstelle Production Build für VPS..."
    
    # Verwende VPS-spezifische Konfiguration
    if npx astro build --config ./astro.config.vps.mjs; then
        print_success "Build erfolgreich erstellt"
        
        # Prüfe ob CSS-Dateien generiert wurden
        print_step "Überprüfe CSS-Dateien..."
        if find ./dist -name "*.css" -type f | head -1 | grep -q .; then
            print_success "CSS-Dateien gefunden"
            echo "CSS files found:"
            find ./dist -name "*.css" -type f | head -5
        else
            print_error "Keine CSS-Dateien gefunden!"
            echo "Checking build directory structure:"
            ls -la ./dist
            echo "Checking for any style-related files:"
            find ./dist -type f -name "*style*" -o -name "*.css*"
            exit 1
        fi
        
        # Fix asset paths in HTML files
        print_step "Korrigiere Asset-Pfade in HTML-Dateien..."
        chmod +x ./scripts/fix-paths.sh
        if ./scripts/fix-paths.sh; then
            print_success "Asset-Pfade korrigiert"
        else
            print_error "Fehler beim Korrigieren der Asset-Pfade"
            exit 1
        fi
        
        # .nojekyll Datei für bessere Kompatibilität
        touch ./dist/.nojekyll
        
    else
        print_error "Fehler beim Erstellen des Builds"
        exit 1
    fi
}

# VPS Verbindung testen
test_vps_connection() {
    print_step "Teste VPS Verbindung..."
    if ssh -i "$SSH_KEY_PATH" -o ConnectTimeout=10 "$VPS_USER@$VPS_HOST" "echo 'Verbindung erfolgreich'" &> /dev/null; then
        print_success "VPS Verbindung erfolgreich"
    else
        print_error "Kann nicht zum VPS verbinden. Bitte überprüfen Sie:"
        echo "  - VPS_HOST: $VPS_HOST"
        echo "  - VPS_USER: $VPS_USER"
        echo "  - SSH_KEY_PATH: $SSH_KEY_PATH"
        exit 1
    fi
}

# VPS vorbereiten
prepare_vps() {
    print_step "Bereite VPS vor..."
    
    # Verzeichnis erstellen und Berechtigungen setzen
    ssh -i "$SSH_KEY_PATH" "$VPS_USER@$VPS_HOST" "
        sudo mkdir -p $VPS_PATH
        sudo chown -R $VPS_USER:$VPS_USER $VPS_PATH
        sudo chmod -R 755 $VPS_PATH
    "
    
    if [ $? -eq 0 ]; then
        print_success "VPS vorbereitet"
    else
        print_error "Fehler beim Vorbereiten des VPS"
        exit 1
    fi
}

# Build auf VPS hochladen
upload_build() {
    print_step "Lade Build auf VPS hoch..."
    
    # Debug script hochladen
    print_step "Lade Debug-Script hoch..."
    if rsync -avz -e "ssh -i $SSH_KEY_PATH" ./scripts/debug-css.sh "$VPS_USER@$VPS_HOST:$VPS_PATH/debug-css.sh"; then
        print_success "Debug-Script hochgeladen"
        # Make script executable
        ssh -i "$SSH_KEY_PATH" "$VPS_USER@$VPS_HOST" "chmod +x $VPS_PATH/debug-css.sh"
    fi
    
    # Rsync für effizienten Upload
    if rsync -avz --delete -e "ssh -i $SSH_KEY_PATH" ./dist/ "$VPS_USER@$VPS_HOST:$VPS_PATH/"; then
        print_success "Build erfolgreich hochgeladen"
    else
        print_error "Fehler beim Hochladen des Builds"
        exit 1
    fi
    
    # Upload and run emergency fix script
    print_step "Lade Emergency-Fix-Script hoch..."
    if rsync -avz -e "ssh -i $SSH_KEY_PATH" ./scripts/emergency-fix.sh "$VPS_USER@$VPS_HOST:$VPS_PATH/emergency-fix.sh"; then
        print_success "Emergency-Fix-Script hochgeladen"
        # Make script executable
        ssh -i "$SSH_KEY_PATH" "$VPS_USER@$VPS_HOST" "chmod +x $VPS_PATH/emergency-fix.sh"
        
        # Run the emergency fix script
        print_step "Führe Emergency-Fix-Script aus..."
        ssh -i "$SSH_KEY_PATH" "$VPS_USER@$VPS_HOST" "cd $VPS_PATH && ./emergency-fix.sh > emergency-fix-output.txt"
        print_success "Emergency-Fix durchgeführt, Ausgabe in $VPS_PATH/emergency-fix-output.txt"
    fi
    
    # Run debug script
    print_step "Führe Debug-Script aus..."
    ssh -i "$SSH_KEY_PATH" "$VPS_USER@$VPS_HOST" "cd $VPS_PATH && ./debug-css.sh > debug-output.txt"
    print_success "Debug-Informationen gespeichert in $VPS_PATH/debug-output.txt"
}

# Nginx Konfiguration erstellen
create_nginx_config() {
    print_step "Erstelle Nginx Konfiguration..."
    
    # Nginx Config erstellen
    ssh -i "$SSH_KEY_PATH" "$VPS_USER@$VPS_HOST" "
        sudo tee /etc/nginx/sites-available/beckenbodentraining-heilbronn > /dev/null << 'EOF'
server {
    listen 80;
    server_name $VPS_HOST www.$VPS_HOST;
    
    root $VPS_PATH;
    index index.html;
    
    # Gzip Kompression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private must-revalidate auth;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
    
    # CSS files - Extra wide matching to catch all CSS files regardless of path
    location ~* \.(css)$ {
        add_header Content-Type "text/css";
        expires 1y;
        add_header Cache-Control \"public, immutable\";
        # Try multiple possible paths for the CSS file
        try_files \$uri \$uri/ /\$uri /ems-beckenboden-therapie\$uri =404;
        
        # Debug logging for CSS files
        error_log /var/log/nginx/css_debug.log debug;
        access_log /var/log/nginx/css_access.log;
    }

    # JavaScript files - Similar handling to CSS
    location ~* \.(js)$ {
        add_header Content-Type "application/javascript";
        expires 1y;
        add_header Cache-Control \"public, immutable\";
        # Try multiple possible paths for the JS file
        try_files \$uri \$uri/ /\$uri /ems-beckenboden-therapie\$uri =404;
    }

    # Astro assets folder catch-all - match all possible asset folders
    location ~* /(_astro|_assets|assets)/ {
        try_files \$uri \$uri/ =404;
        expires 1y;
        add_header Cache-Control \"public, immutable\";
    }
    
    # Extra asset path for GitHub Pages structure
    location ~* /ems-beckenboden-therapie/(_astro|_assets|assets)/ {
        # First try the direct path with ems-beckenboden-therapie prefix
        # Then try without the prefix
        rewrite ^/ems-beckenboden-therapie/((_astro|_assets|assets)/.*)$ /\$1 last;
    }
    
    # Legacy path handling for GitHub Pages paths - redirect to root
    location /ems-beckenboden-therapie/ {
        rewrite ^/ems-beckenboden-therapie/(.*)$ /\$1 permanent;
    }
    
    # Static assets
    location ~* \.(jpg|jpeg|png|gif|ico|js|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control \"public, immutable\";
    }
    
    # HTML Cache
    location ~* \.html$ {
        expires 1h;
        add_header Cache-Control \"public\";
    }
    
    # Security Headers
    add_header X-Frame-Options \"SAMEORIGIN\" always;
    add_header X-Content-Type-Options \"nosniff\" always;
    add_header X-XSS-Protection \"1; mode=block\" always;
    add_header Referrer-Policy \"strict-origin-when-cross-origin\" always;
    
    # Main location
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    # Robots und Sitemap
    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }
    
    location = /sitemap.xml {
        allow all;
        log_not_found off;
        access_log off;
    }
}
EOF
        
        # Site aktivieren
        sudo ln -sf /etc/nginx/sites-available/beckenbodentraining-heilbronn /etc/nginx/sites-enabled/
        
        # Nginx testen und neuladen
        sudo nginx -t && sudo systemctl reload nginx
    "
    
    if [ $? -eq 0 ]; then
        print_success "Nginx konfiguriert"
    else
        print_error "Fehler bei der Nginx Konfiguration"
        exit 1
    fi
}

# SSL Zertifikat mit Let's Encrypt
setup_ssl() {
    print_step "Richte SSL Zertifikat ein..."
    
    ssh -i "$SSH_KEY_PATH" "$VPS_USER@$VPS_HOST" "
        # Certbot installieren falls nicht vorhanden
        if ! command -v certbot &> /dev/null; then
            sudo apt update
            sudo apt install -y certbot python3-certbot-nginx
        fi
        
        # SSL Zertifikat erstellen
        sudo certbot --nginx -d $VPS_HOST -d www.$VPS_HOST --non-interactive --agree-tos --email admin@$VPS_HOST
    "
    
    if [ $? -eq 0 ]; then
        print_success "SSL Zertifikat eingerichtet"
    else
        print_error "Fehler beim Einrichten des SSL Zertifikats"
        echo "Sie können SSL später manuell einrichten mit: sudo certbot --nginx"
    fi
}

# Backup erstellen
create_backup() {
    print_step "Erstelle Backup der vorherigen Version..."
    
    ssh -i "$SSH_KEY_PATH" "$VPS_USER@$VPS_HOST" "
        if [ -d $VPS_PATH ]; then
            sudo cp -r $VPS_PATH $VPS_PATH.backup.\$(date +%Y%m%d_%H%M%S)
        fi
    "
    
    print_success "Backup erstellt"
}

# Deployment Status überprüfen
check_deployment() {
    print_step "Überprüfe Deployment..."
    
    # HTTP Status überprüfen
    if curl -s -o /dev/null -w "%{http_code}" "http://$VPS_HOST" | grep -q "200"; then
        print_success "Website ist erreichbar unter http://$VPS_HOST"
    else
        print_error "Website ist nicht erreichbar"
    fi
}

# Performance optimieren
optimize_performance() {
    print_step "Optimiere Performance..."
    
    ssh -i "$SSH_KEY_PATH" "$VPS_USER@$VPS_HOST" "
        # Leere Nginx Cache falls vorhanden
        if [ -d /var/cache/nginx ]; then
            sudo rm -rf /var/cache/nginx/*
        fi
        
        # Remove any temporary symbolic links or files from GitHub Pages deployment
        # that could cause path conflicts
        if [ -d "$VPS_PATH/ems-beckenboden-therapie" ]; then
            echo "Removing GitHub Pages directory structure from VPS..."
            sudo rm -rf "$VPS_PATH/ems-beckenboden-therapie"
        fi
        
        # Create symbolic link for backward compatibility with any hardcoded paths
        # This ensures that if any CSS paths reference /ems-beckenboden-therapie/_astro/,
        # they will still work by pointing to the correct files
        echo "Creating compatibility symlinks for CSS paths..."
        mkdir -p "$VPS_PATH/ems-beckenboden-therapie"
        if [ -d "$VPS_PATH/_astro" ]; then
            ln -sfn "$VPS_PATH/_astro" "$VPS_PATH/ems-beckenboden-therapie/_astro"
            echo "Created symlink for _astro directory"
        fi
        if [ -d "$VPS_PATH/assets" ]; then
            ln -sfn "$VPS_PATH/assets" "$VPS_PATH/ems-beckenboden-therapie/assets"
            echo "Created symlink for assets directory"
        fi
        
        # Restart Nginx für beste Performance
        sudo systemctl restart nginx
    "
    
    print_success "Performance optimiert"
}

# Haupt-Deployment Funktion
main() {
    print_header
    
    echo "Dieses Script wird die Annette Fneiche EMS Beckenboden Therapie Website deployen."
    echo "VPS: $VPS_HOST"
    echo "User: $VPS_USER"
    echo "Path: $VPS_PATH"
    echo ""
    
    read -p "Möchten Sie fortfahren? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Deployment abgebrochen."
        exit 0
    fi
    
    # Deployment Steps
    check_requirements
    install_dependencies
    build_project
    test_vps_connection
    create_backup
    prepare_vps
    upload_build
    create_nginx_config
    optimize_performance
    check_deployment
    
    # Optional: SSL Setup
    echo ""
    read -p "Möchten Sie SSL (HTTPS) einrichten? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        setup_ssl
    fi
    
    echo ""
    print_success "Deployment erfolgreich abgeschlossen!"
    echo ""
    echo "Ihre Website ist verfügbar unter:"
    echo "  🌐 http://$VPS_HOST"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "  🔒 https://$VPS_HOST"
    fi
    echo ""
    echo "Nächste Schritte:"
    echo "  1. Testen Sie Ihre Website gründlich"
    echo "  2. Richten Sie regelmäßige Backups ein"
    echo "  3. Überwachen Sie die Performance"
    echo "  4. Aktualisieren Sie regelmäßig Ihre Inhalte"
}

# Script ausführen
main "$@" 