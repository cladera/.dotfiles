# Neovim

Opinionated Neovim config using lazy.nvim, LSP via mason, and per-project overrides.

## Install

```
cd ~/.dotfiles
stow nvim
```

This links the config to `~/.config/nvim`.

## Requirements

- Neovim 0.11+ (recommended)
- git
- Optional but useful: `rg` (ripgrep), `fd`, `node`, `npm`
- `nvr` is optional; when present it is used as `GIT_EDITOR` for remote-tab edits

## First run

1. Launch `nvim`.
2. lazy.nvim bootstraps and installs plugins.
3. Open `:Mason` to install/verify LSPs and tools.

## Usage highlights

- Leader key: `<Space>`
- File explorer: `<leader>e` (Oil)
- Save: `<leader>w`
- Window navigation: `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`
- CodeCompanion: `<leader>ca` (actions), `<leader>cc` (chat), `<leader>ch` (history), `<leader>cs` (summaries)
- DAP: `<leader>dt` (toggle breakpoint), `<leader>dc` (continue), `<leader>dU` (toggle UI), `<leader>dr` (REPL)

Note: `CODECOMPANION_TOKEN_PATH` is set to `~/.config` in `init.lua`.

## Extending CodeCompanion

User config is merged on top of defaults. You can add global overrides in `~/.local/nvim/codecompanion.lua` and per-project overrides in `.nvim/codecompanion.lua`.

Example (simple override):

```lua
return {
  setup = function()
    return {
      display = {
        chat = {
          window = {
            width = 0.4,
            border = "rounded",
          },
        },
      },
      interactions = {
        chat = {
          roles = {
            user = "You",
          },
        },
      },
      extensions = {
        history = {
          opts = {
            auto_save = false,
          },
        },
      },
    }
  end,
}
```

You can also return a plain table instead of a `setup` function.

## Extending DAP

DAP loads adapters by default (Node/Chrome) and then applies user configurations from `~/.local/nvim/dap.lua` and `.nvim/dap.lua`. The config file should return a table with a `setup` function:

```lua
return {
  setup = function(configurations, utils)
    configurations.typescript = configurations.typescript or {}
    table.insert(configurations.typescript, {
      name = "Node: launch current file",
      type = "pwa-node",
      request = "launch",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
    })

    configurations.javascript = configurations.javascript or {}
    table.insert(configurations.javascript, {
      name = "Node: debug tests (nx/jest/vitest)",
      type = "pwa-node",
      request = "launch",
      program = utils.repo.resolve_nx_test_program(),
      args = utils.repo.resolve_nx_test_args(false)(),
      cwd = vim.fn.getcwd(),
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    })
  end,
}
```

The `utils` argument exposes helpers from `lua/util/repo.lua` and `lua/util/code.lua`.

