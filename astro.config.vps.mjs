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
      cssCodeSplit: true, // Allow individual CSS files for pages
      rollupOptions: {
        output: {
          assetFileNames: 'styles/[name].[hash][extname]' // Consistent path for CSS files
        }
      }
    },
    css: {
      devSourcemap: true, // Helpful for debugging
    }
  },
  
  // Output configuration for static site generation
  output: 'static',
  
  // Optimize for production
  build: {
    assets: '_assets', // Custom assets folder to avoid path conflicts
    inlineStylesheets: 'never', // CSS immer als externe Dateien
  },
  
  // No trailing slash issues for VPS
  trailingSlash: 'ignore'
});