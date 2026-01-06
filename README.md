# tree-sitter-zeru

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

[Tree-sitter](https://tree-sitter.github.io/) grammar for the [Zeru](https://github.com/miguevr/Zeru) programming language.

## Features

- ✅ Full syntax highlighting
- ✅ Code folding
- ✅ Indentation
- ✅ Text objects (for vim/neovim)
- ✅ Local variable tracking

### Supported Syntax

| Feature | Status |
|---------|--------|
| Functions & Generics | ✅ |
| Structs & Methods | ✅ |
| Enums & Match | ✅ |
| Traits | ✅ |
| Imports | ✅ |
| Pointers (`*T`, `&x`) | ✅ |
| Optional types (`T?`) | ✅ |
| Result types (`T!`) | ✅ |
| For-in loops | ✅ |
| All operators | ✅ |

## Installation

### Neovim (Manual)

#### 1. Clone and build

```bash
git clone https://github.com/miguevr/tree-sitter-zeru
cd tree-sitter-zeru

# Compile the parser
cc -o zeru.so -shared src/parser.c -I src -fPIC -O2
```

#### 2. Install parser

```bash
mkdir -p ~/.local/share/nvim/site/parser
cp zeru.so ~/.local/share/nvim/site/parser/
```

#### 3. Install queries

```bash
mkdir -p ~/.config/nvim/queries/zeru
cp queries/*.scm ~/.config/nvim/queries/zeru/
```

#### 4. Configure filetype

**LazyVim** (`~/.config/nvim/lua/plugins/zeru.lua`):

```lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.filetype.add({ extension = { zr = "zeru" } })
    end,
  },
}
```

**Vanilla Neovim** (`~/.config/nvim/init.lua`):

```lua
vim.filetype.add({ extension = { zr = "zeru" } })
```

#### 5. Restart Neovim

Open a `.zr` file and enjoy syntax highlighting! 🎉

---

### Helix

Add to `~/.config/helix/languages.toml`:

```toml
[[language]]
name = "zeru"
scope = "source.zeru"
injection-regex = "zeru"
file-types = ["zr"]
roots = []
comment-token = "//"
indent = { tab-width = 4, unit = "    " }

[[grammar]]
name = "zeru"
source = { git = "https://github.com/miguevr/tree-sitter-zeru", rev = "main" }
```

Then run:

```bash
hx --grammar fetch
hx --grammar build
mkdir -p ~/.config/helix/runtime/queries/zeru
cp queries/*.scm ~/.config/helix/runtime/queries/zeru/
```

---

### Emacs (tree-sitter)

```elisp
(add-to-list 'treesit-language-source-alist
             '(zeru "https://github.com/miguevr/tree-sitter-zeru"))
(treesit-install-language-grammar 'zeru)
```

---

## Development

### Prerequisites

- Node.js 18+
- tree-sitter-cli (`npm install -g tree-sitter-cli`)
- C compiler (gcc/clang)

### Building

```bash
npm install
npm run generate
npm test
```

### Project Structure

```
tree-sitter-zeru/
├── grammar.js          # Grammar definition
├── src/
│   ├── parser.c        # Generated parser
│   └── tree_sitter/    # Tree-sitter headers
├── queries/
│   ├── highlights.scm  # Syntax highlighting
│   ├── locals.scm      # Scope tracking
│   ├── indents.scm     # Indentation rules
│   ├── injections.scm  # Language injections
│   └── textobjects.scm # Vim text objects
├── test/corpus/        # Test cases
└── package.json
```

## Troubleshooting

### Neovim: Parser not working

1. Verify parser exists:
   ```bash
   ls ~/.local/share/nvim/site/parser/zeru.so
   ```

2. Verify queries exist:
   ```bash
   ls ~/.config/nvim/queries/zeru/
   ```

3. Check filetype (inside Neovim with a `.zr` file open):
   ```vim
   :set ft?
   ```
   Should show `filetype=zeru`

4. Test parser:
   ```vim
   :lua print(pcall(vim.treesitter.get_parser, 0, "zeru"))
   ```
   Should print `true`

5. Inspect syntax tree:
   ```vim
   :InspectTree
   ```

### Rebuild after changes

```bash
npm run generate
cc -o zeru.so -shared src/parser.c -I src -fPIC -O2
cp zeru.so ~/.local/share/nvim/site/parser/
```

## Contributing

1. Fork the repository
2. Edit `grammar.js`
3. Run `npm run generate`
4. Add tests in `test/corpus/`
5. Run `npm test`
6. Submit a PR

## License

MIT License - see [LICENSE](LICENSE)

## Related

- [Zeru Language](https://github.com/miguevr/Zeru) - The Zeru compiler
- [Tree-sitter](https://tree-sitter.github.io/) - Parsing library
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Neovim integration
