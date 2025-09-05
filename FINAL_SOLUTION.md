# Lösung der CSS/JS 404-Fehler für beckenbodentraining-heilbronn.de

## Das Problem

Die Website konnte auf dem VPS-Server keine CSS- und JS-Dateien laden, was zu folgenden Fehlern führte:

```
GET http://beckenbodentraining-heilbronn.de/ems-beckenboden-therapie/_astro/index.auSXMeHl.css net::ERR_ABORTED 404 (Not Found)
GET http://beckenbodentraining-heilbronn.de/ems-beckenboden-therapie/_astro/anamnesebogen.BsfnLu-n.css net::ERR_ABORTED 404 (Not Found)
```

Die Ursache war, dass die HTML-Dateien nach Assets in `/ems-beckenboden-therapie/_astro/` suchten (GitHub Pages Pfad), aber auf dem VPS-Server waren die Dateien unter `/_astro/` oder `/assets/`.

## Die Lösung

### 1. Astro-Konfiguration korrigiert

- **Local**: `astro.config.local.mjs` - Kein base path, konsistenter assets-Ordner

  ```javascript
  base: '', // Explizit kein Base Path
  build: {
    assets: 'assets', // Konsistenter Asset-Ordner für alle Umgebungen
  }
  ```

- **VPS**: `astro.config.vps.mjs` - Kein base path, gleicher assets-Ordner, rollupOptions entfernt
  ```javascript
  base: '', // Empty base path to ensure no subdirectory
  build: {
    assets: 'assets', // Simple folder name to avoid confusion
  }
  ```

### 2. Template-Links korrigiert

- Favicon: `<link rel="icon" type="image/svg+xml" href="/favicon.svg" />`
- Logo: `<a href="/" class="text-2xl font-bold text-pink-600 italic">`
- Navigation: `<a href="/#therapie" class="text-gray-700 hover:text-pink-600">Über die Therapie</a>`
- Footer: `<a href="/rechtliches#impressum" class="hover:text-pink-400">Impressum</a>`
- Script: `const baseURL = '/';` statt `import.meta.env.BASE_URL || '/'`

### 3. Build & Deployment aktualisiert

- **package.json**: Standard-Build verwendet jetzt VPS-Konfiguration

  ```json
  "build": "astro build --config astro.config.vps.mjs",
  ```

- **deploy.sh**: Überprüft auf verbliebene GitHub Pages Pfade, entfernt alte Verzeichnisse

  ```bash
  # Stelle sicher, dass keine GitHub Pages Pfade verwendet werden...
  if grep -r "ems-beckenboden-therapie" ./dist --include="*.html" | grep -v "grep"; then
      print_error "GitHub Pages Pfade gefunden! Dies sollte nicht passieren."
  else
      print_success "Keine GitHub Pages Pfade gefunden, build ist korrekt."
  fi

  # Entfernt alte GitHub Pages Verzeichnisse
  if [ -d "$VPS_PATH/ems-beckenboden-therapie" ]; then
      echo "Removing old GitHub Pages directory structure..."
      sudo rm -rf "$VPS_PATH/ems-beckenboden-therapie"
  fi
  ```

## Wie man es verwendet

1. **Lokale Entwicklung**:

   ```bash
   npm run dev
   ```

2. **Build für VPS erstellen**:

   ```bash
   npm run build  # oder npm run build:vps
   ```

3. **Auf VPS deployen**:

   ```bash
   npm run deploy:vps
   ```

4. **Tests ausführen**:
   ```bash
   npm run test:css    # CSS-Dateien überprüfen
   npm run test:paths  # Auf verbleibende GitHub Pages Pfade prüfen
   ```

## Ergebnis

- **Keine GitHub Pages Pfade** mehr in HTML, JS oder CSS
- **Konsistente Assets-Ordnerstruktur** für alle Umgebungen
- **Vereinfachte Konfiguration** ohne komplexe Pfad-Manipulation
- **Direkte Pfade** in allen Templates

Diese Lösung stellt sicher, dass sowohl die lokale Entwicklung als auch das Deployment auf VPS und GitHub Pages korrekt funktionieren, ohne Pfadkonflikte oder 404-Fehler.
