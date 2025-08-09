/**
 * CSS Path Fixer for VPS Deployment
 * This script modifies HTML files to fix CSS path issues
 */

const fs = require('fs');
const path = require('path');
const { glob } = require('glob');
const { execSync } = require('child_process');

// Configure paths
const distFolder = path.resolve(__dirname, '../dist');

console.log('===== CSS Path Fixer =====');
console.log('Working directory:', process.cwd());
console.log('Dist folder:', distFolder);

// Find all HTML files
const htmlFiles = glob.sync(`${distFolder}/**/*.html`);
console.log(`Found ${htmlFiles.length} HTML files`);

// Replace any incorrect paths
let fixedCount = 0;

htmlFiles.forEach(file => {
  const originalContent = fs.readFileSync(file, 'utf8');
  
  // Look for CSS references with incorrect paths
  const wrongPathRegex = /(href=["'])\/ems-beckenboden-therapie\/(_astro|_assets|styles)\/([^"']+\.css["'])/g;
  const fixedContent = originalContent.replace(wrongPathRegex, (match, prefix, folder, filename) => {
    console.log(`Fixing in ${path.basename(file)}: ${match}`);
    return `${prefix}/${folder}/${filename}`;
  });
  
  if (originalContent !== fixedContent) {
    fs.writeFileSync(file, fixedContent, 'utf8');
    fixedCount++;
    console.log(`Fixed paths in: ${path.relative(distFolder, file)}`);
  }
});

console.log(`Fixed paths in ${fixedCount} files`);

// Generate a report file
const report = {
  timestamp: new Date().toISOString(),
  fixedFiles: fixedCount,
  totalFiles: htmlFiles.length,
};

try {
  const cssFiles = execSync('find dist -name "*.css" -type f').toString().trim().split('\n');
  report.cssFiles = cssFiles.map(file => path.relative(distFolder, file));
} catch (error) {
  report.cssFiles = 'Error finding CSS files';
}

fs.writeFileSync(path.join(distFolder, 'path-fixer-report.json'), JSON.stringify(report, null, 2));
console.log('Report generated at path-fixer-report.json');
