// @ts-check
import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  // VPS deployment configuration
  site: 'https://beckenbodentraining-heilbronn.de',
  // NO base path for VPS - site runs from domain root
  
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
  
  // No trailing slash issues for VPS
  trailingSlash: 'ignore'
});