# Neovim config

lazy.nvim config for Typst/LaTeX writing and Python. Language servers come
from Nix (see home.nix), not Mason.

```
init.lua             leader keys, load modules, bootstrap lazy.nvim
lua/options.lua      editor options and indentation
lua/keymaps.lua      global keymaps
lua/autocmds.lua     diagnostics, LSP keymaps, prose wrapping
lua/typst.lua        heading folds and PDF export on save
lua/lsp.lua          language server settings
lua/harper.lua       grammar checker settings
lua/plugins/*.lua    plugin specs, one file per area
```

Add a plugin by adding a spec to any file in `lua/plugins/`, then `:Lazy sync`.

## Keymaps

Leader is Space, local leader is `,`.

| Key | Action |
| --- | --- |
| `<leader>ff` / `fg` / `fb` | Find files / grep / buffers |
| `<leader>fh` / `fd` / `fs` / `fr` | Help / diagnostics / symbols / resume |
| `<leader>1`..`9`, `0` | Go to buffer, last buffer |
| `<leader><Left>` / `<Right>` | Previous / next buffer |
| `<leader>bd` | Close buffer |
| `<leader>n` | File tree |
| `<leader>ft` | Terminal |
| `<leader>lg` | LazyGit |
| `<leader>xx` / `xX` | Trouble: buffer / all diagnostics (`a` in the list: code action) |
| `<leader>tp` | Typst preview |
| `<leader>tg` | Toggle grammar checking |
| `gd` / `gr` / `gR` / `K` | Definition / references / rename / hover |
| `<leader>ca` | Code action (also adds words to the dictionary) |
| `<leader>ci` / `cy` | Implementation / type definition |
| `<leader>e` | Diagnostic at cursor |
| `]d` / `[d` | Next / previous diagnostic |

Insert mode: `<C-Space>` opens completion, `<C-n>`/`<C-p>` select,
`<C-y>` or `<C-l>` accept, `<Tab>` accepts a Copilot suggestion.

## Typst

Saving a `.typ` file compiles the project's `main.typ` to PDF. For another
main file, set `vim.g.typst_main = "/path/to/main.typ"`.

tinymist is off by default (memory use). Run `:TinymistStart` to use it.
