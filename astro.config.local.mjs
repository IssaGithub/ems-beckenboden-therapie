// @ts-check
import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
// Lokale Entwicklungskonfiguration
export default defineConfig({
  // Lokale Entwicklung
  site: 'http://localhost:4321',
  base: '', // Explizit kein Base Path
  
  vite: {
    plugins: [tailwindcss()],
    build: {
      assetsInlineLimit: 0, // Keine Assets inline für bessere Caching
      cssCodeSplit: false, // Generate a single CSS file
    },
    css: {
      devSourcemap: true, // Helpful for debugging
    }
  },
  
  // Output configuration for static site generation
  output: 'static',
  
  // Optimize for production
  build: {
    assets: 'assets', // Konsistenter Asset-Ordner für alle Umgebungen
    inlineStylesheets: 'never', // CSS immer als externe Dateien
  },
  
  // Trailingslash für lokale Entwicklung
  trailingSlash: 'ignore'
}); 