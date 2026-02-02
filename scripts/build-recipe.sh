#!/usr/bin/env bash
# Build mojo-asciichart recipe using rattler-build and verify package artifacts

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RECIPE_FILE="$PROJECT_ROOT/recipe.yaml"
OUTPUT_DIR="$PROJECT_ROOT/output"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

info() {
    echo -e "${GREEN}INFO: $1${NC}"
}

# Check prerequisites
if ! command -v pixi &> /dev/null; then
    error "pixi is not installed. Install from https://pixi.sh"
fi

if ! pixi list | grep -q rattler-build; then
    error "rattler-build not found in pixi environment"
fi

if [ ! -f "$RECIPE_FILE" ]; then
    error "Recipe file not found: $RECIPE_FILE"
fi

info "Building recipe: $RECIPE_FILE"

if [ -d "$OUTPUT_DIR" ]; then
    info "Cleaning previous output directory"
    rm -rf "$OUTPUT_DIR"
fi

info "Running rattler-build (tests disabled; tests are covered by pixi test-all)..."
if ! pixi exec rattler-build build \
    --recipe "$RECIPE_FILE" \
    --channel conda-forge \
    --channel https://conda.modular.com/max \
    --channel https://prefix.dev/modular-community \
    --output-dir "$OUTPUT_DIR" \
    --test skip; then
    error "rattler-build failed"
fi

if [ ! -d "$OUTPUT_DIR" ]; then
    error "Output directory not created: $OUTPUT_DIR"
fi

PACKAGE_FILES=($(find "$OUTPUT_DIR" -name "*.conda" -o -name "*.tar.bz2" 2>/dev/null))

if [ ${#PACKAGE_FILES[@]} -eq 0 ]; then
    error "No package files found in $OUTPUT_DIR"
fi

info "Build successful!"
echo ""
info "Built packages:"
for pkg in "${PACKAGE_FILES[@]}"; do
    echo "  - $(basename "$pkg")"
done

echo ""
info "To test installation, you can point pixi at file://$OUTPUT_DIR as a channel."

exit 0
