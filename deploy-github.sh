#!/bin/bash

# Annette Fneiche - GitHub Pages Deployment Script
# Dieses Script deployt die Website manuell auf GitHub Pages

# Farben für bessere Ausgabe
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Konfiguration - BITTE ANPASSEN!
GITHUB_USERNAME="your-username"
REPOSITORY_NAME="your-repository-name"
GITHUB_TOKEN="your-github-token"  # Optional: für private Repos

# Funktionen
print_header() {
    echo -e "${BLUE}"
    echo "==========================================="
    echo "  GitHub Pages Deployment"
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

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
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
    
    # Git überprüfen
    if ! command -v git &> /dev/null; then
        print_error "Git ist nicht installiert!"
        exit 1
    fi
    
    print_success "Alle Voraussetzungen erfüllt"
}

# Konfiguration überprüfen
check_config() {
    print_step "Überprüfe Konfiguration..."
    
    if [ "$GITHUB_USERNAME" = "your-username" ]; then
        print_error "Bitte setzen Sie GITHUB_USERNAME in der Konfiguration"
        exit 1
    fi
    
    if [ "$REPOSITORY_NAME" = "your-repository-name" ]; then
        print_error "Bitte setzen Sie REPOSITORY_NAME in der Konfiguration"
        exit 1
    fi
    
    print_success "Konfiguration gültig"
}

# Astro Konfiguration für GitHub Pages aktualisieren
update_astro_config() {
    print_step "Aktualisiere Astro Konfiguration für GitHub Pages..."
    
    # Backup der originalen Konfiguration
    cp astro.config.mjs astro.config.mjs.backup
    
    # Ersetze die Konfiguration
    cat > astro.config.mjs << EOF
// @ts-check
import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  // GitHub Pages deployment configuration
  site: 'https://${GITHUB_USERNAME}.github.io',
  base: '/${REPOSITORY_NAME}',
  
  vite: {
    plugins: [tailwindcss()]
  },
  
  // Output configuration for static site generation
  output: 'static',
  
  // Optimize for production
  build: {
    assets: 'assets'
  }
});
EOF
    
    print_success "Astro Konfiguration aktualisiert"
}

# Sitemap für GitHub Pages aktualisieren
update_sitemap() {
    print_step "Aktualisiere Sitemap für GitHub Pages..."
    
    # Backup der originalen Sitemap
    cp public/sitemap.xml public/sitemap.xml.backup
    
    # Ersetze die URLs in der Sitemap
    sed -i.bak "s|https://www.annette-fneiche.de|https://${GITHUB_USERNAME}.github.io/${REPOSITORY_NAME}|g" public/sitemap.xml
    
    print_success "Sitemap aktualisiert"
}

# Dependencies installieren
install_dependencies() {
    print_step "Installiere Dependencies..."
    if npm ci; then
        print_success "Dependencies erfolgreich installiert"
    else
        print_error "Fehler beim Installieren der Dependencies"
        exit 1
    fi
}

# Build erstellen
build_project() {
    print_step "Erstelle Production Build..."
    if npm run build; then
        print_success "Build erfolgreich erstellt"
    else
        print_error "Fehler beim Erstellen des Builds"
        exit 1
    fi
}

# Git Repository überprüfen
check_git_repo() {
    print_step "Überprüfe Git Repository..."
    
    if [ ! -d ".git" ]; then
        print_error "Kein Git Repository gefunden. Initialisiere Git Repository:"
        echo "git init"
        echo "git remote add origin https://github.com/${GITHUB_USERNAME}/${REPOSITORY_NAME}.git"
        exit 1
    fi
    
    # Überprüfe Remote
    if ! git remote get-url origin &> /dev/null; then
        print_info "Füge Remote hinzu..."
        git remote add origin https://github.com/${GITHUB_USERNAME}/${REPOSITORY_NAME}.git
    fi
    
    print_success "Git Repository bereit"
}

# Zu gh-pages Branch wechseln
setup_gh_pages() {
    print_step "Bereite gh-pages Branch vor..."
    
    # Aktuellen Branch speichern
    CURRENT_BRANCH=$(git branch --show-current)
    
    # Prüfe ob gh-pages Branch existiert
    if git show-ref --verify --quiet refs/heads/gh-pages; then
        print_info "gh-pages Branch existiert bereits"
        git checkout gh-pages
    else
        print_info "Erstelle gh-pages Branch..."
        git checkout --orphan gh-pages
        git rm -rf .
    fi
    
    # Kopiere Build-Dateien
    cp -r dist/* .
    cp dist/.nojekyll . 2>/dev/null || true
    
    print_success "gh-pages Branch vorbereitet"
}

# Deployment auf GitHub Pages
deploy_to_github() {
    print_step "Deploye auf GitHub Pages..."
    
    # Füge alle Dateien hinzu
    git add .
    
    # Commit
    git commit -m "Deploy to GitHub Pages - $(date '+%Y-%m-%d %H:%M:%S')"
    
    # Push to GitHub
    if [ -n "$GITHUB_TOKEN" ]; then
        git push https://${GITHUB_TOKEN}@github.com/${GITHUB_USERNAME}/${REPOSITORY_NAME}.git gh-pages --force
    else
        git push origin gh-pages --force
    fi
    
    print_success "Deployment erfolgreich auf GitHub Pages"
}

# Cleanup
cleanup() {
    print_step "Cleanup..."
    
    # Zurück zum ursprünglichen Branch
    git checkout $CURRENT_BRANCH
    
    # Restore originale Konfiguration
    if [ -f "astro.config.mjs.backup" ]; then
        mv astro.config.mjs.backup astro.config.mjs
    fi
    
    # Restore originale Sitemap
    if [ -f "public/sitemap.xml.backup" ]; then
        mv public/sitemap.xml.backup public/sitemap.xml
    fi
    
    print_success "Cleanup abgeschlossen"
}

# Deployment Status überprüfen
check_deployment() {
    print_step "Überprüfe Deployment..."
    
    SITE_URL="https://${GITHUB_USERNAME}.github.io/${REPOSITORY_NAME}"
    
    print_info "Ihre Website wird verfügbar sein unter:"
    print_info "🌐 $SITE_URL"
    print_info ""
    print_info "GitHub Pages kann einige Minuten benötigen, um die Änderungen zu verarbeiten."
    print_info "Überprüfen Sie den Status unter: https://github.com/${GITHUB_USERNAME}/${REPOSITORY_NAME}/actions"
}

# Haupt-Deployment Funktion
main() {
    print_header
    
    echo "Dieses Script deployt die Annette Fneiche Website auf GitHub Pages."
    echo "Repository: https://github.com/${GITHUB_USERNAME}/${REPOSITORY_NAME}"
    echo "Website: https://${GITHUB_USERNAME}.github.io/${REPOSITORY_NAME}"
    echo ""
    
    read -p "Möchten Sie fortfahren? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Deployment abgebrochen."
        exit 0
    fi
    
    # Deployment Steps
    check_requirements
    check_config
    check_git_repo
    update_astro_config
    update_sitemap
    install_dependencies
    build_project
    setup_gh_pages
    deploy_to_github
    cleanup
    check_deployment
    
    echo ""
    print_success "GitHub Pages Deployment erfolgreich abgeschlossen!"
    echo ""
    echo "Nächste Schritte:"
    echo "  1. Gehen Sie zu https://github.com/${GITHUB_USERNAME}/${REPOSITORY_NAME}/settings/pages"
    echo "  2. Wählen Sie 'gh-pages' als Quelle"
    echo "  3. Warten Sie einige Minuten auf die Aktivierung"
    echo "  4. Besuchen Sie https://${GITHUB_USERNAME}.github.io/${REPOSITORY_NAME}"
}

# Fehlerbehandlung
trap cleanup EXIT

# Script ausführen
main "$@" 