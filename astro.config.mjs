// @ts-check
import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  // GitHub Pages deployment configuration
  // WICHTIG: Passen Sie diese Werte an Ihr Repository an!
  site: 'https://izayt.github.io',
  base: '/Annette_Fusspflege/',
  
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
  
  // Trailingslash für GitHub Pages
  trailingSlash: 'ignore'
});