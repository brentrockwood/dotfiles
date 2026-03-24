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
vim.cmd("colorscheme slate")

-- Wrapping
vim.opt.wrap = true
vim.opt.linebreak = true  -- Wrap at word boundaries
vim.opt.list = false      -- Essential for 'linebreak' to work correctly with visible whitespace chars
vim.opt.showbreak = "↳ "  -- Add a character to indicate a wrapped line (optional)

vim.keymap.set("n", "<leader>tw", function()
    vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle word wrap" })

-- Behavior
vim.opt.timeoutlen = 400
vim.g.mapleader = " "
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true, desc = "Exit insert mode" })


-- Quality of life
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

-- Scratchpad
vim.keymap.set("n", "<leader>sc", function()
  vim.cmd("edit " .. vim.fn.expand("~/.scratchpad.md"))
end, { desc = "Open scratchpad" })

local scratchpad_augroup = vim.api.nvim_create_augroup("Scratchpad", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = scratchpad_augroup,
  pattern = vim.fn.expand("~/tmp/scratch.md"),
  callback = function()
    vim.g._prev_colorscheme = vim.g.colors_name
    vim.cmd("colorscheme darkblue")
  end,
})
vim.api.nvim_create_autocmd("BufLeave", {
  group = scratchpad_augroup,
  pattern = vim.fn.expand("~/tmp/scratch.md"),
  callback = function()
    if vim.g._prev_colorscheme then
      vim.cmd("colorscheme " .. vim.g._prev_colorscheme)
    end
  end,
})

