# Contributing to tree-sitter-zeru

Thank you for your interest in contributing! Here's how to get started.

## Development Setup

### Prerequisites

- **Node.js 18+** - Required for tree-sitter CLI
- **C compiler** - gcc or clang
- **tree-sitter-cli** - Installed via npm

### Getting Started

```bash
# Clone the repository
git clone https://github.com/miguevr/tree-sitter-zeru
cd tree-sitter-zeru

# Install dependencies
npm install

# Generate the parser
npm run generate

# Run tests
npm test
```

## Making Changes

### Modifying the Grammar

1. Edit `grammar.js`
2. Regenerate the parser: `npm run generate`
3. Run tests: `npm test`
4. Test with real files: `npx tree-sitter parse path/to/file.zr`

### Adding Tests

Tests are in `test/corpus/`. Each test file uses this format:

```
================================================================================
Test Name
================================================================================

code here

--------------------------------------------------------------------------------

(expected_tree
  (nodes here))
```

Example:
```
================================================================================
Simple function
================================================================================

fn main() {}

--------------------------------------------------------------------------------

(source_file
  (function_definition
    name: (identifier)
    parameters: (parameters)
    body: (block)))
```

### Updating Queries

Query files are in `queries/`:

- `highlights.scm` - Syntax highlighting
- `locals.scm` - Scope tracking
- `indents.scm` - Auto-indentation
- `textobjects.scm` - Vim text objects
- `injections.scm` - Language injections

After modifying queries, test them:

```bash
npx tree-sitter highlight path/to/file.zr
```

## Testing Your Changes

### Test the parser

```bash
npm test
```

### Test with a real file

```bash
npx tree-sitter parse ../examples/structs.zr
```

### Test highlighting

```bash
npx tree-sitter highlight ../examples/structs.zr
```

### Test in Neovim

```bash
# Rebuild and install
npm run generate
cc -o zeru.so -shared src/parser.c -I src -fPIC -O2
cp zeru.so ~/.local/share/nvim/site/parser/
cp queries/*.scm ~/.config/nvim/queries/zeru/

# Open Neovim and test
nvim ../examples/structs.zr
```

## Pull Request Process

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-change`
3. Make your changes
4. Run tests: `npm test`
5. Commit with a descriptive message
6. Push and create a Pull Request

### Commit Messages

Use clear, descriptive commit messages:

```
Add support for inline assembly syntax

- Add asm_block rule to grammar
- Add highlighting for asm keywords
- Add test case
```

## Code Style

- Use 2 spaces for indentation in JavaScript
- Keep grammar rules organized by category
- Add comments for complex rules

## Questions?

Open an issue on GitHub if you have questions or need help!
