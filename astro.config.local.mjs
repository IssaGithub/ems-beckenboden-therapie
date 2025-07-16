// @ts-check
import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
// Lokale Entwicklungskonfiguration (ohne GitHub Pages base path)
export default defineConfig({
  // Lokale Entwicklung
  site: 'http://localhost:4321',
  
  vite: {
    plugins: [tailwindcss()],
    build: {
      assetsInlineLimit: 0, // Keine Assets inline für bessere Caching
    }
  },
  
  // Output configuration for static site generation
  output: 'static',
  
  // Optimize for production
  build: {
    assets: '_astro', // Standard Astro Assets Ordner
    inlineStylesheets: 'never', // CSS immer als externe Dateien
  },
  
  // Trailingslash für lokale Entwicklung
  trailingSlash: 'ignore'
}); 