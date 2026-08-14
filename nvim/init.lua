-- Disable unused providers (suppress healthcheck noise)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

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

-- ── Theme profile ──────────────────────────────────────────────────────────────
local function apply_solarized()
  local theme = { background = "dark" }
  local path = vim.fn.expand("~/.config/dotfiles-theme/current/nvim.lua")
  if vim.uv.fs_stat(path) then theme = dofile(path) end
  vim.o.background = theme.background
  vim.cmd("colorscheme solarized")
  for group, colors in pairs(theme.highlights or {}) do
    vim.api.nvim_set_hl(0, group, colors)
  end
end

-- ── Plugins ───────────────────────────────────────────────────────────────────
require("lazy").setup({

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
  -- Requires ripgrep for live_grep.
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

  -- mason-lspconfig: installs and enables language servers
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "ts_ls",         -- TypeScript / JavaScript
        "pyright",       -- Python
        "gopls",         -- Go
        "rust_analyzer", -- Rust
        "bashls",        -- Bash
      },
    },
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

}, {
  change_detection = { notify = false },
  lockfile = vim.fn.stdpath("state") .. "/lazy-lock.json",
  rocks = { hererocks = false },
})

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

vim.keymap.set("n", "<leader>sp", function()
  vim.cmd("edit " .. scratchpad_path)
  vim.cmd("normal! G")
end, { desc = "Open scratchpad" })

local scratchpad_augroup = vim.api.nvim_create_augroup("Scratchpad", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = scratchpad_augroup,
  pattern = scratchpad_path,
  callback = apply_solarized,
})
vim.api.nvim_create_autocmd("BufLeave", {
  group = scratchpad_augroup,
  pattern = scratchpad_path,
  callback = apply_solarized,
})

-- ── Todo ────────────────────────────────────────────────────────────────
local todo_path = vim.fn.expand("~/tmp/todo.md")

vim.keymap.set("n", "<leader>td", function()
  vim.cmd("edit " .. todo_path)
  vim.cmd("normal! G")
end, { desc = "Open todo" })

local todo_augroup = vim.api.nvim_create_augroup("Todo", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = todo_augroup,
  pattern = todo_path,
  callback = apply_solarized,
})
vim.api.nvim_create_autocmd("BufLeave", {
  group = todo_augroup,
  pattern = todo_path,
  callback = apply_solarized,
})

-- Insert DateTime
vim.keymap.set('i', '<F5>', '<C-R>=strftime("%Y-%m-%dT%H-%M-%S%z")<CR>')
vim.keymap.set('n', '<F5>', 'a<C-R>=strftime("%Y-%m-%dT%H-%M-%S%z")<CR><Esc>')

-- Load machine-local config (not tracked in dotfiles)
local local_cfg = vim.fn.stdpath("config") .. "/local.lua"
if vim.uv.fs_stat(local_cfg) then
  dofile(local_cfg)
end

-- Use Tab and Shift+Tab to cycle through buffers
vim.keymap.set("n", "<Tab>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Hide startup message
vim.opt.shortmess:append("I")

