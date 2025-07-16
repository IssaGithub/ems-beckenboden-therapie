// @ts-check
import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
// Lokale Entwicklungskonfiguration (ohne GitHub Pages base path)
export default defineConfig({
  // Lokale Entwicklung
  site: 'http://localhost:4321',
  
  vite: {
    plugins: [tailwindcss()]
  },
  
  // Output configuration for static site generation
  output: 'static',
  
  // Optimize for production
  build: {
    assets: 'assets'
  }
}); 