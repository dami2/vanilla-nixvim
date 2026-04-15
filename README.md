# vanilla-nixvim

A portable, opinionated Neovim distribution managed entirely through Nix. Inspired by
[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), this flake produces a fully
configured Neovim binary and can also be consumed as a NixVim module by downstream flakes.

---

## Overview

`vanilla-nixvim` is a [NixVim](https://github.com/nix-community/nixvim) configuration that:

- Builds a runnable Neovim binary with all configuration baked in — no external plugin managers,
  no runtime bootstrapping.
- Exports itself as `nixvimModules.vanilla-nixvim` so it can be imported into any NixOS or
  home-manager flake.
- Works on all four major platforms: `x86_64-linux`, `aarch64-linux`, `x86_64-darwin`,
  `aarch64-darwin`.
- Requires **no patched (Nerd) fonts** — every plugin is configured to work in a standard
  terminal.

---

## Highlights

- **Native LSP completion** — uses Neovim 0.11+'s built-in `vim.lsp.completion` rather than
  nvim-cmp or blink.cmp.
- **fzf-lua for everything** — fuzzy files, live grep, LSP actions, git operations, diagnostics,
  and symbols all go through `fzf-lua`. Telescope is not used.
- **ast-grep structural search** — `<leader>sa` wraps the `ast-grep` CLI for structural code
  queries via fzf-lua.
- **Dynamic mode feedback** — background color and cursor shape change automatically between
  Normal and Insert mode.
- **oil.nvim as default file explorer** — netrw is disabled entirely.
- **Habit enforcement** — `hardtime.nvim` and `precognition.nvim` are both enabled to discourage
  inefficient motions.
- **No external completion plugin** — forward-looking minimal approach using only Neovim built-ins.
- **Wayland and X11 clipboard** — `wl-copy` and `xsel` providers configured out of the box.
- **Mouse disabled** — deliberately keyboard-only.

---

## Requirements

| Requirement | Notes |
|---|---|
| Nix with flakes enabled | `experimental-features = nix-command flakes` |
| Neovim 0.11+ | Required for native LSP completion API |
| `wl-copy` (optional) | Wayland clipboard integration |
| `xsel` (optional) | X11 clipboard integration |
| `ast-grep` (optional) | Structural code search via `<leader>sa` |

---

## Usage

### Run directly (ephemeral, no installation)

```bash
nix run /path/to/vanilla-nixvim#vanilla-nixvim
```

Once published to a remote repository, replace the path with the flake URL:

```bash
nix run github:<owner>/vanilla-nixvim#vanilla-nixvim
```

### Build the package

```bash
nix build .#vanilla-nixvim
./result/bin/nvim
```

### Run flake checks

```bash
nix flake check
```

### Consume as a NixVim module

Add this flake as an input in your own `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    vanilla-nixvim.url = "github:<owner>/vanilla-nixvim";
  };

  outputs = { nixvim, vanilla-nixvim, pkgs, ... }: {
    packages.default = nixvim.lib.makeNixvimWithModule {
      inherit pkgs;
      module = {
          imports = [
          vanilla-nixvim.nixvimModules.vanilla-nixvim
          { inherit pkgs; }
        ];
        # Your additional overrides here
      };
    };
  };
}
```

---

## Project Structure

```
vanilla-nixvim/
├── flake.nix           # Flake entrypoint: inputs, outputs, nixvimModules export
├── flake.lock          # Pinned dependency hashes
├── default.nix         # Core config: opts, globals, colorscheme, autocmds, diagnostics
├── keymaps.nix         # All keybindings declared as Nix (no inline Lua)
├── lsp.nix             # LSP server declarations and LSP-specific keymaps
├── plugins.nix         # All plugin declarations with settings
└── on-lsp-attach.lua   # Lua script executed on every LSP buffer attach event
```

Each `.nix` module takes `{ pkgs }` as an argument, keeping concerns cleanly separated.

---

## Plugins

### UI & Appearance

| Plugin | Purpose |
|---|---|
| `dracula-nvim` | Colorscheme (`dracula-soft` variant) |
| `mini.statusline` | Lightweight statusline (icons disabled) |
| `indent-blankline` | Indentation guide lines using `┊` |
| `smartcolumn` | Context-aware colorcolumn |
| `fidget` | LSP progress indicator in the corner |
| `gitsigns` | Git diff signs in the sign column |
| `todo-comments` | Highlights `TODO`, `NOTE`, `FIXME`, etc. |
| `snacks (bigfile)` | Disables heavy features for large files |
| `snacks (scroll)` | Smooth scrolling |

### Editing & Motions

| Plugin | Purpose |
|---|---|
| `mini.ai` | Extended text objects (`a`, `i` with 500-line lookahead) |
| `mini.surround` | Add/change/delete surrounding characters |
| `mini.comment` | Toggle comments (`<leader>/`) |
| `luasnip` | Snippet engine |
| `vim-sleuth` | Auto-detect `tabstop` / `shiftwidth` from buffer |
| `vim-abolish` | Case-smart substitution and abbreviations |
| `hardtime` | Discourages repeated inefficient motions |
| `precognition` | Overlays available motion hints |
| `nvim-bqf` | Enhanced quickfix window |

### File Navigation & Search

| Plugin | Purpose |
|---|---|
| `fzf-lua` | Fuzzy finder for files, grep, LSP, git, and more |
| `oil.nvim` | File manager as a buffer (replaces netrw) |

### LSP & Formatting

| Plugin | Purpose |
|---|---|
| `nvim-lspconfig` (via NixVim) | LSP client configuration |
| `conform-nvim` | Auto-format on save (LSP fallback; disabled for C/C++) |
| `nvim-lint` | Asynchronous linting |

### Git

| Plugin | Purpose |
|---|---|
| `vim-fugitive` | Full Git integration inside Neovim |
| `git-conflict` | Conflict marker UI and navigation |
| `mini.diff` | Diff view using the sign column |

### Utilities

| Plugin | Purpose |
|---|---|
| `which-key` | Popup showing available keybindings for a prefix |
| `snacks (quickfile)` | Faster file opening for small files |
| `editorconfig` | Respects `.editorconfig` per-project rules |

---

## Keymaps

> Leader key: `<Space>`

### General

| Key | Mode | Action |
|---|---|---|
| `<Esc>` | n | Clear search highlights |
| `<leader>e` | n | Open floating diagnostic |
| `<leader>q` | n | Send diagnostics to location list |
| `<Esc><Esc>` | t | Exit terminal mode |
| `J` | n | Join lines, preserving cursor position |
| `<C-d>` | n | Scroll down and center cursor |
| `<C-u>` | n | Scroll up and center cursor |
| `n` | n | Next search result, centered |
| `N` | n | Previous search result, centered |
| `J` / `K` | v | Move selected lines down / up |

### Window Navigation

| Key | Mode | Action |
|---|---|---|
| `<C-h>` | n | Focus left window |
| `<C-l>` | n | Focus right window |
| `<C-j>` | n | Focus window below |
| `<C-k>` | n | Focus window above |
| `<leader>wh` | n | Arrange windows horizontally |
| `<leader>wv` | n | Arrange windows vertically |

### Search & FZF (`<leader>s*`)

| Key | Action |
|---|---|
| `<leader>z` | Open FZF picker menu |
| `<leader>?` | Recent files |
| `<leader><leader>` | Open buffers |
| `<leader>sf` | Search files |
| `<leader>sg` | Live grep (excludes `*.test` / `*.spec` files) |
| `<leader>sr` | Live grep (all files) |
| `<leader>sa` | Structural search via `ast-grep` (prompts for query) |
| `<leader>sh` | Search help tags |
| `<leader>sk` | Search keymaps |
| `<leader>sc` | Search commands |
| `<leader>sd` | Document diagnostics |
| `<leader>sq` | Quickfix list |
| `<leader>sm` | Git commits |
| `<leader>su` | Git status |
| `<leader>st` | Git stash |
| `<leader>ss` | Browse colorschemes |

### LSP Actions

| Key | Mode | Action |
|---|---|---|
| `grn` | n | Rename symbol |
| `gra` | n, v | Code action |
| `grD` | n | Go to declaration |
| `grd` | n | Go to definition (fzf-lua) |
| `grr` | n | Go to references (fzf-lua) |
| `gri` | n | Go to implementation (fzf-lua) |
| `grt` | n | Go to type definition (fzf-lua) |
| `<leader>D` | n | LSP type definitions |
| `g0` | n | Document symbols |
| `gW` | n | Workspace symbols |
| `<C-Space>` | i | Trigger LSP completion |

### Format & Clipboard

| Key | Mode | Action |
|---|---|---|
| `<leader>f` | n | Format buffer (conform, async, LSP fallback) |
| `<leader>y` | n, v | Yank to system clipboard |
| `<leader>Y` | n | Yank line to system clipboard |

### Buffer Management (`<leader>b*`)

| Key | Action |
|---|---|
| `<leader>bn` | Next buffer |
| `<leader>bp` | Previous buffer |
| `<leader>bd` | Delete buffer |
| `<leader>br` | Reload (refresh) buffer |
| `<leader>bco` | Close all other buffers |
| `<leader>bca` | Close all buffers |

### Toggle (`<leader>t*`)

| Key | Action |
|---|---|
| `<leader>tn` | Toggle line numbers |
| `<leader>tr` | Toggle relative line numbers |
| `<leader>tl` | Toggle LSP on/off |
| `<leader>ts` | Toggle spell check |
| `<leader>tb` | Toggle git blame for current line |
| `<leader>tD` | Toggle inline deleted hunk preview |
| `<leader>th` | Toggle LSP inlay hints (per buffer) |

### Git Hunks (`<leader>h*`)

| Key | Mode | Action |
|---|---|---|
| `]c` | n | Next git hunk |
| `[c` | n | Previous git hunk |
| `<leader>hs` | n, v | Stage hunk |
| `<leader>hr` | n, v | Reset hunk |
| `<leader>hS` | n | Stage entire buffer |
| `<leader>hu` | n | Undo stage hunk |
| `<leader>hR` | n | Reset entire buffer |
| `<leader>hp` | n | Preview hunk |
| `<leader>hb` | n | Blame current line |
| `<leader>hd` | n | Diff against index |
| `<leader>hD` | n | Diff against last commit |

### Oil (File Manager)

| Key | Action |
|---|---|
| `-` | Open parent directory in Oil |
| `<C-r>` | Refresh Oil buffer |
| `.` | Set current directory (`actions.cd`) |
| `<leader>qq` | Close Oil |

### Path Copy (`<leader>cp*`)

| Key | Copies |
|---|---|
| `<leader>cpr` | Relative file path |
| `<leader>cpa` | Absolute file path |
| `<leader>cpf` | File name only |
| `<leader>cpd` | Directory path |

---

## LSP

### Servers

| Server | Filetypes | Notes |
|---|---|---|
| `marksman` | `markdown` | Markdown LSP |

Additional servers can be enabled by importing this module and extending `programs.nixvim.plugins.lsp.servers`.

### Global Server Defaults

All servers receive:

- `multilineTokenSupport = true` — enables multi-line semantic tokens.
- `root_markers = [".git"]` — workspace root is detected from `.git`.

### On-Attach Behavior

Configured via `base/on-lsp-attach.lua`, applied to every LSP-attached buffer:

| Capability | Behavior |
|---|---|
| `textDocument/documentHighlight` | Highlights all references to the symbol under cursor on `CursorHold`; clears on `CursorMoved` |
| Inlay hints | Registers `<leader>th` to toggle inlay hints per buffer |
| Native completion | Enables `vim.lsp.completion` with `autotrigger = true`; sets `completeopt = menu,menuone,noinsert,popup` |

---

## Editor Configuration

### Colorscheme

- **Theme**: `dracula-nvim` with the `dracula-soft` variant
- **Normal background**: `#303030` (custom override)
- **Insert mode background**: `#191A21` (auto-applied via autocmd)
- `DiffAdd`, `DiffText`, diagnostic warning colors, `Search`, and `IncSearch` are all
  customized to fit the soft palette.

### Key Options

| Option | Value | Effect |
|---|---|---|
| `number` + `relativenumber` | `true` | Hybrid line numbers |
| `mouse` | `""` | Mouse completely disabled |
| `clipboard` | `wl-copy`, `xsel` | Wayland and X11 clipboard providers |
| `undofile` | `true` | Persistent undo across sessions |
| `ignorecase` + `smartcase` | `true` | Smart case-insensitive search |
| `signcolumn` | `"auto:2"` | Up to 2 signs side by side (gitsigns + diagnostics) |
| `updatetime` | `250ms` | Fast `CursorHold` for document highlights |
| `timeoutlen` | `300ms` | Snappy key sequence timeout |
| `scrolloff` | `10` | Always keep 10 lines above/below cursor |
| `inccommand` | `"split"` | Live substitution preview in a split |
| `cursorline` | `true` | Highlight current line |
| `laststatus` | `3` | Single global statusline |
| `confirm` | `true` | Confirm before discarding unsaved changes |
| `winborder` | `"rounded"` | Rounded borders on all floating windows |
| `list` + `listchars` | `tab:» , trail:·, nbsp:␣` | Visible whitespace characters |
| `splitright` + `splitbelow` | `true` | Natural split directions |
| `spelllang` | `"en_us"` | Spell language (toggle with `<leader>ts`) |

### Diagnostics

| Option | Value |
|---|---|
| `virtual_text` | `true` |
| `virtual_lines` | `false` |
| `update_in_insert` | `false` |
| `severity_sort` | `true` |
| `float.border` | `"rounded"` |
| `float.source` | `"if_many"` |
| `jump.float` | `true` |

---

## Design Decisions

**No Nerd Fonts.** `have_nerd_font = false`, `web-devicons` is disabled, and all plugins are
configured with icon rendering off. The config works in any standard monospace terminal font.

**Native LSP completion.** Instead of nvim-cmp or blink.cmp, this config uses Neovim 0.11+'s
built-in `vim.lsp.completion` API. This removes a significant layer of plugin complexity while
leveraging Neovim's own forward-looking completion infrastructure.

**fzf-lua over Telescope.** All fuzzy-find workflows — files, grep, LSP navigation, git,
diagnostics — are handled by `fzf-lua` in fullscreen mode with a vertical 45% preview. Telescope
is not included.

**oil.nvim over netrw.** `netrw` is disabled entirely via `g:loaded_netrw`. The `-` key opens
the parent directory as an oil buffer.

**Dynamic mode visual feedback.** Two autocmd pairs respond to `InsertEnter`/`InsertLeave`:
one swaps the `Normal` background color, and one changes the cursor shape. This provides strong,
immediate visual feedback about the current mode without relying on statusline alone.

**Habit enforcement.** Both `hardtime.nvim` (discourages repeated `hjkl` motions) and
`precognition.nvim` (overlays motion hints) are enabled. This reflects a deliberate philosophy
of using Neovim as designed, not as a character-repeat editor.

**Dual consumption model.** The flake outputs both a runnable package (`nix run .#vanilla-nixvim`) for
standalone use and a NixVim module (`nixvimModules.vanilla-nixvim`) for composing into larger
configurations. The module is system-agnostic and lives outside the `perSystem` block.

**Kickstart.nvim lineage.** Auto-group names (`kickstart-highlight-yank`,
`kickstart-lsp-attach`, etc.) and overall structure mirror
[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). This is a NixVim port and
evolution of that starter config.
