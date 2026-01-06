#!/bin/bash
# Installation script for tree-sitter-zeru
# Supports: Neovim, Helix

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARSER_NAME="zeru"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Linux*)  PLATFORM="linux";;
    Darwin*) PLATFORM="macos";;
    *)       error "Unsupported OS: $OS";;
esac

# Build parser
build_parser() {
    info "Building parser..."
    
    cd "$SCRIPT_DIR"
    
    # Check if parser.c exists
    if [ ! -f "src/parser.c" ]; then
        if command -v npx &> /dev/null; then
            info "Generating parser..."
            npx tree-sitter generate
        else
            error "src/parser.c not found. Install Node.js and run: npm install && npm run generate"
        fi
    fi
    
    # Compile
    if [ "$PLATFORM" = "macos" ]; then
        cc -o "${PARSER_NAME}.so" -shared src/parser.c -I src -fPIC -O2 -undefined dynamic_lookup
    else
        cc -o "${PARSER_NAME}.so" -shared src/parser.c -I src -fPIC -O2
    fi
    
    info "Parser built: ${PARSER_NAME}.so"
}

# Install for Neovim
install_neovim() {
    info "Installing for Neovim..."
    
    # Parser directory
    NVIM_PARSER_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/parser"
    mkdir -p "$NVIM_PARSER_DIR"
    cp "${PARSER_NAME}.so" "$NVIM_PARSER_DIR/"
    info "Parser installed to $NVIM_PARSER_DIR/${PARSER_NAME}.so"
    
    # Queries directory
    NVIM_QUERIES_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim/queries/${PARSER_NAME}"
    mkdir -p "$NVIM_QUERIES_DIR"
    cp queries/*.scm "$NVIM_QUERIES_DIR/"
    info "Queries installed to $NVIM_QUERIES_DIR/"
    
    echo ""
    info "Add this to your Neovim config:"
    echo ""
    echo '  vim.filetype.add({ extension = { zr = "zeru" } })'
    echo ""
    info "Done! Restart Neovim and open a .zr file."
}

# Install for Helix
install_helix() {
    info "Installing for Helix..."
    
    # Helix runtime directory
    HELIX_RUNTIME="${XDG_CONFIG_HOME:-$HOME/.config}/helix/runtime"
    
    # Grammars
    HELIX_GRAMMARS="$HELIX_RUNTIME/grammars"
    mkdir -p "$HELIX_GRAMMARS"
    cp "${PARSER_NAME}.so" "$HELIX_GRAMMARS/${PARSER_NAME}.so"
    info "Grammar installed to $HELIX_GRAMMARS/${PARSER_NAME}.so"
    
    # Queries
    HELIX_QUERIES="$HELIX_RUNTIME/queries/${PARSER_NAME}"
    mkdir -p "$HELIX_QUERIES"
    cp queries/*.scm "$HELIX_QUERIES/"
    info "Queries installed to $HELIX_QUERIES/"
    
    echo ""
    info "Add this to ~/.config/helix/languages.toml:"
    echo ""
    cat << 'EOF'
[[language]]
name = "zeru"
scope = "source.zeru"
injection-regex = "zeru"
file-types = ["zr"]
roots = []
comment-token = "//"
indent = { tab-width = 4, unit = "    " }
EOF
    echo ""
    info "Done! Restart Helix and open a .zr file."
}

# Main
main() {
    echo "========================================"
    echo "  tree-sitter-zeru installer"
    echo "========================================"
    echo ""
    
    # Build
    build_parser
    echo ""
    
    # Choose editor
    case "${1:-}" in
        neovim|nvim)
            install_neovim
            ;;
        helix|hx)
            install_helix
            ;;
        all)
            install_neovim
            echo ""
            install_helix
            ;;
        *)
            echo "Usage: $0 <editor>"
            echo ""
            echo "Editors:"
            echo "  neovim, nvim  - Install for Neovim"
            echo "  helix, hx     - Install for Helix"
            echo "  all           - Install for all editors"
            echo ""
            echo "Example:"
            echo "  $0 neovim"
            ;;
    esac
}

main "$@"
