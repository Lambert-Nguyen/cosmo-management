#!/bin/bash
# Cosmo Management - Web Build Script
#
# This script builds the Flutter web application with optimal settings
# for production deployment.
#
# Usage:
#   ./scripts/build_web.sh [release|profile|debug]
#
# Build modes:
#   release - Production build with full optimizations (default)
#   profile - Profile build for performance analysis
#   debug   - Debug build for development

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default build mode
BUILD_MODE="${1:-release}"

echo -e "${GREEN}=== Cosmo Management Web Build ===${NC}"
echo "Build mode: $BUILD_MODE"

# Navigate to project root
cd "$(dirname "$0")/.."

# Clean previous build
echo -e "${YELLOW}Cleaning previous build...${NC}"
flutter clean

# Get dependencies
echo -e "${YELLOW}Getting dependencies...${NC}"
flutter pub get

# Run code generation
echo -e "${YELLOW}Running code generation...${NC}"
dart run build_runner build --delete-conflicting-outputs

# Build web app
echo -e "${YELLOW}Building web application...${NC}"

case $BUILD_MODE in
  release)
    flutter build web \
      --release \
      --web-renderer canvaskit \
      --tree-shake-icons \
      --dart-define=FLUTTER_WEB_CANVASKIT_URL=https://www.gstatic.com/flutter-canvaskit/latest/ \
      --pwa-strategy offline-first \
      --source-maps
    ;;
  profile)
    flutter build web \
      --profile \
      --web-renderer canvaskit \
      --source-maps
    ;;
  debug)
    flutter build web \
      --debug \
      --web-renderer html
    ;;
  *)
    echo -e "${RED}Invalid build mode: $BUILD_MODE${NC}"
    echo "Valid modes: release, profile, debug"
    exit 1
    ;;
esac

# Print build info
echo ""
echo -e "${GREEN}=== Build Complete ===${NC}"
echo "Output: build/web/"
echo ""

# Calculate bundle size
if [ -d "build/web" ]; then
  TOTAL_SIZE=$(du -sh build/web | cut -f1)
  MAIN_DART_SIZE=$(ls -lh build/web/main.dart.js 2>/dev/null | awk '{print $5}' || echo "N/A")

  echo "Bundle size summary:"
  echo "  Total: $TOTAL_SIZE"
  echo "  main.dart.js: $MAIN_DART_SIZE"
  echo ""

  # List largest files
  echo "Largest files:"
  find build/web -type f -exec ls -lh {} \; 2>/dev/null | sort -k5 -h -r | head -5 | awk '{print "  " $5 " " $9}'
fi

echo ""
echo -e "${GREEN}To serve locally: flutter run -d chrome${NC}"
echo -e "${GREEN}To deploy: Upload build/web/ to your hosting provider${NC}"
