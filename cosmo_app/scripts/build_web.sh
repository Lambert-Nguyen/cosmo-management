#!/bin/bash
# Cosmo Management - Web Build Script
#
# This script builds the Flutter web application with optimal settings
# for production deployment.
#
# Usage:
#   ./scripts/build_web.sh [release|profile|debug] [base-href]
#
# Build modes:
#   release - Production build with full optimizations (default)
#   profile - Profile build for performance analysis
#   debug   - Debug build for development
#
# Base href:
#   Optional base path for deployment (default: "/")
#   Example: ./scripts/build_web.sh release /app/
#
# Environment variables:
#   API_URL      - Backend API URL (default: uses env_config.dart settings)
#   SKIP_CLEAN   - Set to "true" to skip flutter clean (faster rebuilds)
#   SKIP_CODEGEN - Set to "true" to skip code generation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
BUILD_MODE="${1:-release}"
BASE_HREF="${2:-/}"

echo -e "${GREEN}=== Cosmo Management Web Build ===${NC}"
echo "Build mode: $BUILD_MODE"
echo "Base href: $BASE_HREF"

# Navigate to project root
cd "$(dirname "$0")/.."

# Clean previous build (unless skipped)
if [ "$SKIP_CLEAN" != "true" ]; then
  echo -e "${YELLOW}Cleaning previous build...${NC}"
  flutter clean
fi

# Get dependencies
echo -e "${YELLOW}Getting dependencies...${NC}"
flutter pub get

# Run code generation (unless skipped)
if [ "$SKIP_CODEGEN" != "true" ]; then
  echo -e "${YELLOW}Running code generation...${NC}"
  dart run build_runner build --delete-conflicting-outputs
fi

# Build web app
echo -e "${YELLOW}Building web application...${NC}"

# Common build args
BUILD_ARGS="--base-href $BASE_HREF"

# Add API_URL if provided
if [ -n "$API_URL" ]; then
  BUILD_ARGS="$BUILD_ARGS --dart-define=API_URL=$API_URL"
fi

case $BUILD_MODE in
  release)
    flutter build web \
      --release \
      --web-renderer canvaskit \
      --tree-shake-icons \
      --dart-define=FLUTTER_WEB_CANVASKIT_URL=https://www.gstatic.com/flutter-canvaskit/latest/ \
      --pwa-strategy offline-first \
      --source-maps \
      $BUILD_ARGS
    ;;
  profile)
    flutter build web \
      --profile \
      --web-renderer canvaskit \
      --source-maps \
      $BUILD_ARGS
    ;;
  debug)
    flutter build web \
      --debug \
      --web-renderer html \
      $BUILD_ARGS
    ;;
  *)
    echo -e "${RED}Invalid build mode: $BUILD_MODE${NC}"
    echo "Valid modes: release, profile, debug"
    exit 1
    ;;
esac

# Generate server configuration files for SPA routing
echo -e "${YELLOW}Generating server configuration files...${NC}"

# Generate .htaccess for Apache servers
cat > build/web/.htaccess << 'EOF'
# Enable rewrite engine
RewriteEngine On

# Redirect all requests to index.html (SPA routing)
RewriteBase /
RewriteRule ^index\.html$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.html [L]

# Enable GZIP compression
<IfModule mod_deflate.c>
  AddOutputFilterByType DEFLATE text/html text/plain text/css application/javascript application/json
</IfModule>

# Set cache headers
<IfModule mod_expires.c>
  ExpiresActive On
  ExpiresByType text/html "access plus 0 seconds"
  ExpiresByType text/css "access plus 1 year"
  ExpiresByType application/javascript "access plus 1 year"
  ExpiresByType image/png "access plus 1 year"
  ExpiresByType image/svg+xml "access plus 1 year"
  ExpiresByType application/font-woff2 "access plus 1 year"
</IfModule>

# Security headers
<IfModule mod_headers.c>
  Header always set X-Content-Type-Options "nosniff"
  Header always set X-Frame-Options "SAMEORIGIN"
  Header always set X-XSS-Protection "1; mode=block"
  Header always set Referrer-Policy "strict-origin-when-cross-origin"
</IfModule>
EOF

# Generate nginx configuration snippet
cat > build/web/nginx.conf.sample << 'EOF'
# Nginx configuration for Cosmo Management SPA
# Include this in your server block or copy the relevant parts

location / {
    root /path/to/build/web;
    try_files $uri $uri/ /index.html;

    # Security headers
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
}

# Cache static assets
location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
    root /path/to/build/web;
    expires 1y;
    add_header Cache-Control "public, immutable";
}

# Gzip compression
gzip on;
gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
EOF

# Print build info
echo ""
echo -e "${GREEN}=== Build Complete ===${NC}"
echo "Output: build/web/"
echo ""

# Calculate bundle size
if [ -d "build/web" ]; then
  TOTAL_SIZE=$(du -sh build/web | cut -f1)
  MAIN_DART_SIZE=$(ls -lh build/web/main.dart.js 2>/dev/null | awk '{print $5}' || echo "N/A")

  echo -e "${BLUE}Bundle size summary:${NC}"
  echo "  Total: $TOTAL_SIZE"
  echo "  main.dart.js: $MAIN_DART_SIZE"
  echo ""

  # List largest files
  echo -e "${BLUE}Largest files:${NC}"
  find build/web -type f -exec ls -lh {} \; 2>/dev/null | sort -k5 -h -r | head -5 | awk '{print "  " $5 " " $9}'
fi

echo ""
echo -e "${BLUE}Server configuration files generated:${NC}"
echo "  - build/web/.htaccess (Apache)"
echo "  - build/web/nginx.conf.sample (Nginx)"
echo ""
echo -e "${GREEN}Deployment instructions:${NC}"
echo "  1. Upload build/web/ contents to your web server"
echo "  2. Configure your server to serve index.html for all routes (SPA)"
echo "  3. For Apache: .htaccess is included (ensure mod_rewrite is enabled)"
echo "  4. For Nginx: Copy nginx.conf.sample settings to your config"
echo ""
echo -e "${GREEN}Local testing:${NC}"
echo "  flutter run -d chrome"
echo "  # Or serve the built files:"
echo "  cd build/web && python3 -m http.server 8080"
