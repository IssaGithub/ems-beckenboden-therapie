# EMS Beckenboden Therapie - Landingpage

Eine professionelle, SEO-optimierte Landingpage für EMS Beckenboden Therapie, erstellt mit Astro.js und Tailwind CSS.

## 🚀 Features

- **Moderne UI/UX**: Responsive Design basierend auf professionellem Webdesign
- **SEO-optimiert**: Meta-Tags, strukturierte Daten, Sitemap, robots.txt
- **Performance**: Optimiert für schnelle Ladezeiten und Core Web Vitals
- **Accessibility**: WCAG-konforme Implementierung
- **Call-to-Actions**: Strategisch platzierte Conversion-Elemente

## 📋 Inhalte

- **Hero-Bereich**: Emotionale Ansprache mit klaren CTAs
- **Therapie-Information**: Detaillierte Erklärung der EMS Beckenboden Therapie
- **Vorteile**: Sechs Hauptvorteile der Behandlung
- **Behandlungsablauf**: Vier-Schritte-Prozess
- **Preise**: Transparente Preisstruktur mit Paketen
- **Kontakt**: Kontaktformular und Informationen.

## 🛠 Technologie-Stack

- **Framework**: Astro.js 4.x
- **Styling**: Tailwind CSS 4.x
- **Deployment**: VPS mit Nginx
- **SEO**: Strukturierte Daten, Meta-Tags
- **Performance**: Gzip, Caching, Bildoptimierung

## 📦 Installation

### Voraussetzungen

- Node.js 18+
- npm oder yarn

### Lokale Entwicklung

```bash
# Repository klonen
git clone <repository-url>
cd ems-beckenboden-therapie

# Dependencies installieren
npm install

# Entwicklungsserver starten
npm run dev

# In Browser öffnen: http://localhost:4321
```

### Verfügbare Scripts

```bash
npm run dev          # Entwicklungsserver
npm run build        # Production Build
npm run preview      # Build vorschau
npm run astro        # Astro CLI
```

## 🚀 Deployment

### GitHub Pages Deployment (Automatisch - Empfohlen)

1. **Repository auf GitHub erstellen und pushen**:

   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/IHR-USERNAME/IHR-REPOSITORY.git
   git push -u origin main
   ```

2. **GitHub Pages aktivieren**:
   - Gehen Sie zu GitHub.com → Repository → Settings → Pages
   - Wählen Sie "GitHub Actions" als Source
   - Website ist verfügbar unter: `https://IHR-USERNAME.github.io/IHR-REPOSITORY`

3. **Konfiguration anpassen**:
   Bearbeiten Sie `astro.config.mjs`:
   ```javascript
   site: 'https://IHR-USERNAME.github.io',
   base: '/IHR-REPOSITORY',
   ```

**Verfügbare Scripts**:

```bash
npm run dev                # Lokale Entwicklung
npm run build:github       # Build für GitHub Pages
npm run deploy:github      # Manuelles Deployment
```

📖 **Detaillierte Anleitung**: Siehe [GITHUB_PAGES_DEPLOYMENT.md](GITHUB_PAGES_DEPLOYMENT.md)

🚨 **CSS-Probleme auf GitHub Pages?** → [CSS_TROUBLESHOOTING.md](CSS_TROUBLESHOOTING.md)

### VPS Deployment (Alternativ)

1. **Script konfigurieren**: Bearbeiten Sie `deploy.sh`:

   ```bash
   VPS_HOST="ihre-domain.de"
   VPS_USER="ihr-username"
   VPS_PATH="/var/www/ems-beckenboden-therapie"
   SSH_KEY_PATH="~/.ssh/id_rsa"
   ```

2. **SSH-Key Setup**: Stellen Sie sicher, dass SSH-Key-Authentication eingerichtet ist:

   ```bash
   ssh-copy-id user@ihr-vps.de
   ```

3. **Deployment ausführen**:

   ```bash
   # Linux/Mac
   ./deploy.sh

   # Windows (Git Bash)
   bash deploy.sh
   ```

### Manuelle Deployment-Schritte

1. **Build erstellen**:

   ```bash
   npm run build
   ```

2. **Build auf VPS hochladen**:

   ```bash
   scp -r dist/* user@ihr-vps.de:/var/www/html/
   ```

3. **Nginx konfigurieren** (siehe nginx.conf Beispiel unten)

## ⚙️ Konfiguration

### Nginx Konfiguration

```nginx
server {
    listen 80;
    server_name ihre-domain.de www.ihre-domain.de;

    root /var/www/ems-beckenboden-therapie;
    index index.html;

    # Gzip Kompression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;

    # Cache Einstellungen
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Security Headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

### SSL Setup (Let's Encrypt)

```bash
sudo certbot --nginx -d ihre-domain.de -d www.ihre-domain.de
```

## 🎨 Anpassungen

### Design anpassen

- **Farben**: Tailwind-Klassen in den Komponenten anpassen
- **Schriften**: Google Fonts in `Layout.astro` ändern
- **Bilder**: Bilder in `/public` ersetzen

### Inhalte anpassen

- **Kontaktdaten**: In `Layout.astro` und `index.astro` aktualisieren
- **Preise**: Preissektion in `index.astro` anpassen
- **SEO**: Meta-Tags und strukturierte Daten in `Layout.astro`

### Neue Seiten hinzufügen

```astro
---
// src/pages/neue-seite.astro
import Layout from '../layouts/Layout.astro';
---

<Layout title="Neue Seite">
  <!-- Inhalt hier -->
</Layout>
```

## 📈 SEO Optimierung

### Bereits implementiert

- ✅ Meta-Tags (Title, Description, Keywords)
- ✅ Open Graph Tags für Social Media
- ✅ Strukturierte Daten (Schema.org)
- ✅ Sitemap.xml
- ✅ Robots.txt
- ✅ Semantisches HTML
- ✅ Performance-Optimierung

### Weitere Optimierungen

1. **Google Analytics** hinzufügen
2. **Google Search Console** einrichten
3. **Lokale SEO** für Standort optimieren
4. **Content** regelmäßig aktualisieren

## 📊 Performance

### Optimierungen

- **Code Splitting**: Automatisch durch Astro
- **Image Optimization**: Moderne Formate
- **Minification**: CSS/JS automatisch minimiert
- **Caching**: Browser- und Server-Caching
- **Gzip**: Kompression aktiviert

### Monitoring

```bash
# Lighthouse Score überprüfen
npm install -g lighthouse
lighthouse https://ihre-domain.de

# WebPageTest
# https://www.webpagetest.org/
```

## 🔧 Troubleshooting

### Häufige Probleme

1. **Build-Fehler**:

   ```bash
   rm -rf node_modules package-lock.json
   npm install
   npm run build
   ```

2. **CSS nicht geladen**: Überprüfen Sie Tailwind-Konfiguration
3. **404-Fehler**: Nginx-Konfiguration überprüfen

### Logs anzeigen

```bash
# Nginx Error Log
sudo tail -f /var/log/nginx/error.log

# Nginx Access Log
sudo tail -f /var/log/nginx/access.log
```

## 📞 Support

Bei Fragen oder Problemen:

1. **Issues**: GitHub Issues erstellen
2. **Dokumentation**: [Astro Docs](https://docs.astro.build)
3. **Community**: [Astro Discord](https://astro.build/chat)

## 📄 Lizenz

MIT License - siehe LICENSE Datei für Details.

## 🚀 Roadmap

- [ ] Mehrsprachigkeit (i18n)
- [ ] CMS-Integration (Sanity/Strapi)
- [ ] E-Commerce Features
- [ ] Progressive Web App (PWA)
- [ ] Erweiterte Analytics

---

**Entwickelt für professionelle EMS Beckenboden Therapie Praxis**
