# CSS Troubleshooting für GitHub Pages

Wenn CSS auf GitHub Pages nicht funktioniert, folgen Sie dieser Schritt-für-Schritt Anleitung zur Fehlerbehebung.

## 🔍 Schritt 1: Problem diagnostizieren

### Browser Developer Tools öffnen

1. Drücken Sie `F12` oder `Ctrl+Shift+I` (Windows/Linux) / `Cmd+Option+I` (Mac)
2. Gehen Sie zum **Network** Tab
3. Laden Sie die Seite neu (`F5`)
4. Suchen Sie nach CSS-Dateien (Filter: CSS)

### Häufige Fehlermeldungen:

- **404 Not Found** für CSS-Dateien → Pfad-Problem
- **MIME-Type Fehler** → Jekyll-Problem
- **Keine CSS-Dateien gefunden** → Build-Problem

## 🛠️ Schritt 2: Sofortlösungen

### Lösung 1: Astro-Konfiguration prüfen

```javascript
// astro.config.mjs - Korrekte Konfiguration
export default defineConfig({
  site: "https://IHR-USERNAME.github.io",
  base: "/IHR-REPOSITORY-NAME",

  build: {
    assets: "_astro",
    inlineStylesheets: "never",
  },

  trailingSlash: "ignore",
});
```

### Lösung 2: .nojekyll Datei hinzufügen

```bash
# Manuell hinzufügen
echo "" > dist/.nojekyll

# Oder im Build-Prozess (bereits integriert)
touch ./dist/.nojekyll
```

### Lösung 3: Repository-Einstellungen überprüfen

1. Gehen Sie zu: `https://github.com/IHR-USERNAME/IHR-REPOSITORY/settings/pages`
2. Stellen Sie sicher, dass **"GitHub Actions"** als Source gewählt ist
3. **NICHT** "Deploy from a branch" verwenden

## 🔧 Schritt 3: Erweiterte Fehlerbehebung

### Problem: CSS-Dateien werden nicht generiert

**Diagnose:**

```bash
# Lokaler Build-Test
npm run build
find ./dist -name "*.css" -type f
```

**Lösung:**

```bash
# Tailwind CSS neu installieren
npm uninstall @tailwindcss/vite tailwindcss
npm install @tailwindcss/vite@latest tailwindcss@latest

# Dependencies aktualisieren
npm update
```

### Problem: Falsche CSS-Pfade

**Diagnose:**
Überprüfen Sie die HTML-Ausgabe:

```bash
# Nach dem Build
cat dist/index.html | grep -i "stylesheet"
```

**Erwartetes Ergebnis:**

```html
<link rel="stylesheet" href="/IHR-REPOSITORY/_astro/Layout.vspukTd4.css" />
```

**Lösung bei falschen Pfaden:**

```javascript
// In astro.config.mjs
export default defineConfig({
  base: "/IHR-REPOSITORY-NAME", // Muss exakt Ihr Repository-Name sein
  // ...
});
```

### Problem: GitHub Actions Deployment fehlschlägt

**Diagnose:**

1. Gehen Sie zu: `https://github.com/IHR-USERNAME/IHR-REPOSITORY/actions`
2. Klicken Sie auf den fehlgeschlagenen Workflow
3. Schauen Sie in die Build-Logs

**Häufige Fehler und Lösungen:**

```yaml
# .github/workflows/deploy.yml
- name: Build with Astro
  run: |
    npm ci  # Verwenden Sie npm ci statt npm install
    npm run build
    touch ./dist/.nojekyll
    # CSS-Dateien prüfen
    find ./dist -name "*.css" -type f | head -10
```

## 🧪 Schritt 4: Lokale Tests

### Test 1: Lokaler Build mit GitHub Pages Konfiguration

```bash
# Build für GitHub Pages
npm run build:github

# Lokale Vorschau
npm run preview:github
```

### Test 2: Manuelle Deployment-Simulation

```bash
# Deployment-Script testen
bash deploy-github.sh
```

### Test 3: CSS-Pfade überprüfen

```bash
# Nach dem Build
npm run build
python3 -m http.server 8000 -d dist
# Oder mit Node.js
npx serve dist
```

## 🔍 Schritt 5: Spezifische Probleme

### Problem: Tailwind CSS funktioniert nicht

**Überprüfen Sie:**

1. `src/styles/global.css` existiert und enthält `@import "tailwindcss";`
2. Das Layout importiert die CSS-Datei korrekt

**Lösung:**

```astro
---
// src/layouts/Layout.astro
---
<html>
  <head>
    <!-- ... -->
  </head>
  <body>
    <slot />
  </body>
</html>

<script>
  import '../styles/global.css';
</script>
```

### Problem: CSS funktioniert lokal, aber nicht auf GitHub Pages

**Ursache:** Base-Path Konfiguration

**Lösung:**

```javascript
// Separate Konfigurationen verwenden
// astro.config.mjs (GitHub Pages)
export default defineConfig({
  site: 'https://IHR-USERNAME.github.io',
  base: '/IHR-REPOSITORY',
  // ...
});

// astro.config.local.mjs (Lokal)
export default defineConfig({
  site: 'http://localhost:4321',
  // Kein base path
  // ...
});
```

## 🚀 Schritt 6: Quick-Fix für sofortige Lösung

### Notfall-Deployment

```bash
# 1. Konfiguration zurücksetzen
git checkout astro.config.mjs

# 2. Korrekte Werte einsetzen
sed -i 's/your-username/IHR-GITHUB-USERNAME/g' astro.config.mjs
sed -i 's/your-repository-name/IHR-REPOSITORY-NAME/g' astro.config.mjs

# 3. Build testen
npm run build
ls -la dist/_astro/*.css

# 4. Deployment
git add .
git commit -m "Fix CSS configuration for GitHub Pages"
git push
```

## 📊 Schritt 7: Monitoring und Validierung

### CSS-Dateien überprüfen

```bash
# Nach erfolgreichem Deployment
curl -I https://IHR-USERNAME.github.io/IHR-REPOSITORY/_astro/Layout.vspukTd4.css
```

### Lighthouse-Test

```bash
# Performance und Best Practices
npm install -g lighthouse
lighthouse https://IHR-USERNAME.github.io/IHR-REPOSITORY
```

## 🆘 Notfall-Kontakte

### Wenn nichts funktioniert:

1. **Repository-Reset:**

   ```bash
   # Backup erstellen
   git branch backup-$(date +%Y%m%d)

   # Astro-Konfiguration zurücksetzen
   git checkout HEAD~1 astro.config.mjs
   git add astro.config.mjs
   git commit -m "Reset Astro config"
   git push
   ```

2. **Vollständiges Neu-Deployment:**

   ```bash
   # Deployment-Branch löschen
   git push origin --delete gh-pages

   # Neu deployen
   npm run deploy:github
   ```

3. **Support-Informationen sammeln:**

   ```bash
   # Systeminformationen
   echo "Node.js Version: $(node --version)"
   echo "npm Version: $(npm --version)"
   echo "Astro Version: $(npx astro --version)"

   # Build-Informationen
   npm run build 2>&1 | tee build-log.txt
   find dist -name "*.css" -ls
   ```

## 🎯 Erfolgskontrolle

Nach der Fehlerbehebung sollten Sie folgende Punkte überprüfen:

- [ ] **CSS-Dateien werden im Build generiert** (`dist/_astro/*.css`)
- [ ] **GitHub Actions Deployment erfolgreich** (grüner Haken)
- [ ] **Website lädt mit korrektem Styling**
- [ ] **Browser Developer Tools zeigen keine 404-Fehler**
- [ ] **Mobile Ansicht funktioniert korrekt**

## 📱 Kontakt

Falls Sie weiterhin Probleme haben:

- **GitHub Issues:** Erstellen Sie ein Issue mit Build-Logs
- **Astro Discord:** https://astro.build/chat
- **GitHub Pages Status:** https://www.githubstatus.com/

---

**Entwickelt für die professionelle EMS Beckenboden Therapie Praxis von Annette Fneiche**
