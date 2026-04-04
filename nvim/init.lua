-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Rulers
vim.opt.colorcolumn = "80,100,120"

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- UI
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

-- Wrapping
vim.opt.wrap = true
vim.opt.linebreak = true  -- wrap at word boundaries
vim.opt.list = false      -- required for linebreak to work with visible whitespace
vim.opt.showbreak = "↳ "

-- Behavior
vim.opt.timeoutlen = 400
vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

-- Keymaps
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true, desc = "Exit insert mode" })
vim.keymap.set("n", "<leader>tw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle word wrap" })

-- ── Plugin manager (lazy.nvim) ────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ── System appearance detection ───────────────────────────────────────────────
local function system_appearance()
  if vim.fn.has("mac") == 1 then
    local result = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null")
    return result:gsub("%s+", "") == "Dark" and "dark" or "light"
  end
  return "dark"  -- SSH / Linux console: always dark
end

local function apply_solarized()
  local bg = system_appearance()
  vim.o.background = bg
  vim.cmd("colorscheme solarized")
  
  -- Swap status bar and line numbers to use opposite theme's body colors
  if bg == "dark" then
    -- Dark theme: use light theme body colors for status/line numbers
    vim.api.nvim_set_hl(0, "StatusLine", { fg = "#657b83", bg = "#fdf6e3" })
--    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#586e75", bg = "#fdf6e3" })
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#657b83", bg = "#073642" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#839496", bg = "none" })
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#073642" })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#073642" })
  else
    -- Light theme: use dark theme body colors for status/line numbers
    vim.api.nvim_set_hl(0, "StatusLine", { fg = "#eee8d5", bg = "#002b36" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#93a1a1", bg = "#073642" })
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#839496", bg = "#073642" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#657b83", bg = "#93a1a1" })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#eee8d5" })
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#eee8d5" })
  end
  
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
end

-- ── Plugins ───────────────────────────────────────────────────────────────────
require("lazy").setup({

  -- ActivityWatch: local watcher plugin for Vim/Neovim edits
  {
    dir = "/Users/br/src/dotfiles/nvim/pack/activitywatch/start/aw-watcher-vim",
    name = "aw-watcher-vim",
    lazy = false,
  },

  -- Colorscheme: Solarized (tracks system dark/light)
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    config = apply_solarized,
  },

  -- Treesitter: real parse-tree syntax highlighting + text objects
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "bash", "go", "javascript", "lua", "markdown",
          "python", "rust", "tsx", "typescript",
        },
        highlight = { enable = true },
      })
    end,
  },

  -- Telescope: fuzzy finding for files, grep, buffers, diagnostics
  -- Requires: brew install ripgrep  (for live_grep)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local b = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", b.find_files,  { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", b.live_grep,   { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", b.buffers,     { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fd", b.diagnostics, { desc = "Find diagnostics" })
    end,
  },

  -- Mason: GUI installer for language servers (open with :Mason)
  { "williamboman/mason.nvim", config = true },

  -- mason-lspconfig: auto-installs and wires up language servers
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",         -- TypeScript / JavaScript
          "pyright",       -- Python
          "gopls",         -- Go
          "rust_analyzer", -- Rust
          "bashls",        -- Bash
        },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({})
          end,
        },
      })
    end,
  },

  -- blink.cmp: LSP-powered autocompletion (ships pre-compiled, no Rust needed)
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = { preset = "default" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },

  -- gitsigns: git diff in the sign column, stage/unstage hunks
  { "lewis6991/gitsigns.nvim", config = true },

}, { change_detection = { notify = false } })

-- ── LSP keybindings (active only when LSP attaches to a buffer) ───────────────
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local map = function(keys, fn, desc)
      vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = desc })
    end
    map("gd",         vim.lsp.buf.definition,   "Go to definition")
    map("gD",         vim.lsp.buf.declaration,  "Go to declaration")
    map("gr",         vim.lsp.buf.references,   "References")
    map("K",          vim.lsp.buf.hover,        "Hover docs")
    map("<leader>rn", vim.lsp.buf.rename,       "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action,  "Code action")
    map("[d",         vim.diagnostic.goto_prev, "Prev diagnostic")
    map("]d",         vim.diagnostic.goto_next, "Next diagnostic")
  end,
})

-- Re-apply theme when Neovim regains focus (picks up system theme changes)
vim.api.nvim_create_autocmd("FocusGained", {
  callback = apply_solarized,
})

-- ── Scratchpad ────────────────────────────────────────────────────────────────
local scratchpad_path = vim.fn.expand("~/tmp/scratch.md")

vim.keymap.set("n", "<leader>sc", function()
  vim.cmd("edit " .. scratchpad_path)
end, { desc = "Open scratchpad" })

local scratchpad_augroup = vim.api.nvim_create_augroup("Scratchpad", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = scratchpad_augroup,
  pattern = scratchpad_path,
  callback = function() vim.cmd("colorscheme darkblue") end,
})
vim.api.nvim_create_autocmd("BufLeave", {
  group = scratchpad_augroup,
  pattern = scratchpad_path,
  callback = apply_solarized,
})
