# GitHub Pages Deployment für Annette Fneiche EMS Beckenboden Therapie

Diese Anleitung erklärt, wie Sie die Website auf GitHub Pages deployen können - sowohl automatisch mit GitHub Actions als auch manuell.

## 🚀 Automatisches Deployment mit GitHub Actions

### Schritt 1: Repository Setup

1. **Repository erstellen**:

   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/IHR-USERNAME/IHR-REPOSITORY.git
   git push -u origin main
   ```

2. **GitHub Pages aktivieren**:
   - Gehen Sie zu GitHub.com → Ihr Repository → Settings → Pages
   - Wählen Sie "GitHub Actions" als Source
   - Das war's! Der Workflow wird automatisch ausgeführt

### Schritt 2: Konfiguration anpassen

**Bearbeiten Sie `astro.config.mjs`**:

```javascript
export default defineConfig({
  site: "https://IHR-USERNAME.github.io",
  base: "/IHR-REPOSITORY",
  // ... rest der Konfiguration
});
```

**Ersetzen Sie**:

- `IHR-USERNAME` → Ihr GitHub Username
- `IHR-REPOSITORY` → Ihr Repository Name

### Schritt 3: Automatisches Deployment

Bei jedem Push auf `main` Branch wird automatisch deployed:

- ✅ Dependencies werden installiert
- ✅ Build wird erstellt
- ✅ Auf GitHub Pages deployed
- ✅ Website ist verfügbar unter: `https://IHR-USERNAME.github.io/IHR-REPOSITORY`

## 🔧 Manuelles Deployment

### Vorbereitung

1. **Script konfigurieren**:
   Bearbeiten Sie `deploy-github.sh`:

   ```bash
   GITHUB_USERNAME="IHR-USERNAME"
   REPOSITORY_NAME="IHR-REPOSITORY"
   GITHUB_TOKEN="IHR-TOKEN"  # Optional
   ```

2. **Script ausführbar machen**:
   ```bash
   chmod +x deploy-github.sh
   ```

### Deployment ausführen

```bash
# Manuelles Deployment
./deploy-github.sh

# Oder mit npm
npm run deploy:github
```

## 📋 Verfügbare Scripts

```bash
# Lokale Entwicklung (ohne GitHub Pages base path)
npm run dev

# Build für lokale Verwendung
npm run build

# Build für GitHub Pages
npm run build:github

# Vorschau lokal
npm run preview

# Vorschau für GitHub Pages
npm run preview:github

# Manuelles GitHub Pages Deployment
npm run deploy:github
```

## 🔧 Konfigurationsdateien

### `astro.config.mjs` (GitHub Pages)

```javascript
export default defineConfig({
  site: "https://IHR-USERNAME.github.io",
  base: "/IHR-REPOSITORY",
  // Für GitHub Pages Deployment
});
```

### `astro.config.local.mjs` (Lokale Entwicklung)

```javascript
export default defineConfig({
  site: "http://localhost:4321",
  // Kein base path für lokale Entwicklung
});
```

## 🚨 Troubleshooting

### Problem: Links funktionieren nicht auf GitHub Pages

**Lösung**: Überprüfen Sie die `base` Konfiguration in `astro.config.mjs`:

```javascript
base: '/IHR-REPOSITORY-NAME',
```

### Problem: CSS/JS nicht geladen

**Lösung**:

1. Überprüfen Sie die `site` URL in der Konfiguration
2. Stellen Sie sicher, dass `.nojekyll` Datei existiert
3. Prüfen Sie die Konsole im Browser auf Fehler

### Problem: 404 Fehler bei direkten Links

**Lösung**: GitHub Pages unterstützt nur SPA-Routing begrenzt. Für eine statische Site sollten alle Links funktionieren.

### Problem: Deployment schlägt fehl

**Überprüfen Sie**:

1. Repository Permissions (Settings → Actions → General → Workflow permissions)
2. GitHub Pages ist aktiviert (Settings → Pages)
3. Workflow-Dateien sind korrekt commited

## 📊 Monitoring

### GitHub Actions

- Gehen Sie zu: `https://github.com/IHR-USERNAME/IHR-REPOSITORY/actions`
- Überprüfen Sie den Status der Deployments
- Schauen Sie sich die Logs bei Fehlern an

### GitHub Pages Status

- Gehen Sie zu: `https://github.com/IHR-USERNAME/IHR-REPOSITORY/settings/pages`
- Sehen Sie den aktuellen Deployment-Status
- Erhalten Sie die URL Ihrer Website

## 🔒 Sicherheit

### GitHub Token (für private Repositories)

1. **Personal Access Token erstellen**:
   - GitHub → Settings → Developer settings → Personal access tokens
   - Erstellen Sie ein Token mit `repo` Berechtigung

2. **Token im Script verwenden**:
   ```bash
   GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxx"
   ```

### Repository Secrets (für GitHub Actions)

Für sensitive Daten verwenden Sie Repository Secrets:

- GitHub → Repository → Settings → Secrets and variables → Actions
- Fügen Sie `GITHUB_TOKEN` hinzu falls nötig

## 🌐 Custom Domain

### Eigene Domain verwenden

1. **DNS konfigurieren**:

   ```
   CNAME: www.ihre-domain.de → IHR-USERNAME.github.io
   ```

2. **GitHub Pages konfigurieren**:
   - Settings → Pages → Custom domain
   - Geben Sie `www.ihre-domain.de` ein

3. **Astro Konfiguration anpassen**:
   ```javascript
   site: 'https://www.ihre-domain.de',
   base: '/', // Kein base path bei eigener Domain
   ```

## 📈 Performance Optimierung

### Cache-Einstellungen

Die GitHub Actions Workflow-Datei enthält bereits Cache-Optimierungen:

- Node.js Dependencies werden gecacht
- Build-Artefakte werden effizient übertragen

### Build-Optimierungen

```javascript
// In astro.config.mjs
build: {
  assets: 'assets', // Optimierte Asset-Struktur
  inlineStylesheets: 'auto' // CSS-Optimierung
}
```

## 📞 Support

### Häufige Probleme

1. **Deployment dauert zu lange**:
   - Überprüfen Sie GitHub Actions Logs
   - Möglicherweise GitHub Pages Wartung

2. **Änderungen nicht sichtbar**:
   - CDN Cache kann bis zu 10 Minuten dauern
   - Leeren Sie Browser Cache

3. **JavaScript Fehler**:
   - Überprüfen Sie die Browser-Konsole
   - Prüfen Sie relative vs. absolute Pfade

### Nützliche Links

- [GitHub Pages Dokumentation](https://docs.github.com/en/pages)
- [Astro Deployment Guide](https://docs.astro.build/en/guides/deploy/github/)
- [GitHub Actions Dokumentation](https://docs.github.com/en/actions)

## 🎯 Best Practices

1. **Regelmäßige Updates**:
   - Halten Sie Dependencies aktuell
   - Testen Sie vor dem Deployment

2. **Monitoring**:
   - Überwachen Sie die Website-Performance
   - Prüfen Sie regelmäßig auf tote Links

3. **Backup**:
   - Repository ist automatisch ein Backup
   - Zusätzliche Backups der Inhalte empfohlen

---

**Entwickelt für die professionelle EMS Beckenboden Therapie Praxis von Annette Fneiche**
