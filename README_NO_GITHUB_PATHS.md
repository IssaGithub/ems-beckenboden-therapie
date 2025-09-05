# EMS Beckenboden Therapie Website

Diese Anleitung erklärt, wie die Website ohne GitHub Pages Pfade sowohl lokal als auch auf dem VPS-Server verwendet werden kann.

## Änderungen

Die folgenden Änderungen wurden vorgenommen, um GitHub Pages Pfade zu entfernen:

1. **Astro Konfiguration aktualisiert**:
   - `base` Pfad auf `''` (leer) in allen Konfigurationen gesetzt
   - Konsistenten Assets-Ordner `assets` für alle Umgebungen eingestellt

2. **Template Links korrigiert**:
   - Alle `${import.meta.env.BASE_URL}` Verweise durch direkte Pfade (z.B. `/`) ersetzt
   - Hardcodierte GitHub Pages Pfade entfernt

3. **Build und Deployment Prozess angepasst**:
   - Default Build verwendet jetzt die VPS Konfiguration
   - Prüfung auf verbleibende GitHub Pages Pfade hinzugefügt

## Lokal entwickeln

```bash
# Start development server
npm run dev
# oder
npm start
```

Der Entwicklungsserver verwendet `astro.config.local.mjs` und ist auf http://localhost:4321 verfügbar.

## Build und Test

```bash
# Build mit VPS Konfiguration (default)
npm run build

# CSS Dateien prüfen
npm run test:css

# Prüfen auf GitHub Pages Pfade (sollte keine finden)
npm run test:paths

# Debug-Informationen anzeigen
npm run debug:build
```

## VPS Deployment

```bash
# PDF-Dateien generieren und Build erstellen
npm run build:complete

# Auf VPS deployen
npm run deploy:vps
```

## GitHub Pages Deployment (wenn immer noch benötigt)

```bash
# Build für GitHub Pages erstellen
npm run build:github

# Auf GitHub Pages deployen
npm run deploy:github
```

## Wichtige Hinweise

1. **Asset Pfade**:
   - Alle Assets werden jetzt im `/assets/` Ordner abgelegt
   - Keine `/ems-beckenboden-therapie/` Präfixe mehr in den Pfaden

2. **URL Struktur**:
   - Lokale Entwicklung: `http://localhost:4321/`
   - VPS: `https://beckenbodentraining-heilbronn.de/`
   - GitHub Pages (wenn verwendet): `https://issagithub.github.io/ems-beckenboden-therapie/`

3. **Bei Problemen**:
   - Prüfe mit `npm run test:paths`, ob noch GitHub Pages Pfade im Build vorhanden sind
   - Stelle sicher, dass alle Links im Template direkte Pfade verwenden (`/` statt `${import.meta.env.BASE_URL}`)
   - Cache im Browser leeren nach Deployment

## Warum diese Änderungen?

Die Website hatte CSS-Ladeprobleme auf dem VPS, weil die HTML-Dateien nach CSS-Dateien mit GitHub Pages Pfaden suchten (z.B. `/ems-beckenboden-therapie/_astro/style.css`), aber die Dateien waren unter einem anderen Pfad (z.B. `/_astro/style.css` oder `/assets/style.css`).

Die Änderungen stellen sicher, dass die Website in allen Umgebungen korrekt funktioniert, indem sie immer konsistente Pfade verwendet.
