#!/usr/bin/env bash
set -euo pipefail

# Install tree-sitter parsers for RPM spec files
# Builds and installs rpmspec + rpmbash parsers to Neovim's site directory

REPO_URL="https://gitlab.com/cryptomilk/tree-sitter-rpmspec.git"
BUILD_DIR=$(mktemp -d)
NVIM_PARSER_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/parser"
NVIM_QUERY_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/queries"

cleanup() { rm -rf "$BUILD_DIR"; }
trap cleanup EXIT

echo "Cloning tree-sitter-rpmspec..."
git clone --depth=1 "$REPO_URL" "$BUILD_DIR"

for lang in rpmspec rpmbash; do
    echo "Building $lang parser..."
    cd "$BUILD_DIR/$lang"
    gcc -shared -fPIC -Isrc -o "lib$lang.so" src/parser.c src/scanner.c

    echo "Installing $lang parser to $NVIM_PARSER_DIR/$lang.so"
    mkdir -p "$NVIM_PARSER_DIR"
    cp "lib$lang.so" "$NVIM_PARSER_DIR/$lang.so"

    echo "Installing $lang queries to $NVIM_QUERY_DIR/$lang/"
    mkdir -p "$NVIM_QUERY_DIR/$lang"
    cp "$BUILD_DIR/$lang/queries/"*.scm "$NVIM_QUERY_DIR/$lang/" 2>/dev/null || true
done

# neovim/ dir has additional rpmbash highlight tweaks
if [ -f "$BUILD_DIR/neovim/queries/rpmbash/highlights.scm" ]; then
    mkdir -p "$NVIM_QUERY_DIR/rpmbash"
    cp "$BUILD_DIR/neovim/queries/rpmbash/"*.scm "$NVIM_QUERY_DIR/rpmbash/" 2>/dev/null || true
fi

echo "Done! rpmspec and rpmbash parsers installed."
echo "Make sure your Neovim config has the following:"
echo ""
echo "  vim.treesitter.language.register('rpmspec', { 'rpm_spec' })"
echo ""
echo "  vim.api.nvim_create_autocmd('FileType', {"
echo "    pattern = { 'rpm_spec' },"
echo "    callback = function(args)"
echo "      vim.treesitter.start(args.buf, 'rpmspec')"
echo "      vim.bo[args.buf].commentstring = '# %s'"
echo "      vim.bo[args.buf].comments = 'b:#'"
echo "    end,"
echo "  })"
