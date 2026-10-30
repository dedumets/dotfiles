-- Use line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Add visual columns for long lines
vim.opt.colorcolumn = "80,120"

-- Use a sign column for gitsigns
vim.opt.signcolumn = "yes:1"

-- Sync clipboard between OS and Neovim
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Save undo history
vim.opt.undofile = true

-- Search case-insensitively unless casing is used or \C is enabled
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Two-space tabs, auto-indent newlines
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smarttab = true

-- Speed up flows
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Split naturally
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Make whitespace visible
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions in realtime
vim.opt.inccommand = "split"

-- Prevent scrolling off-screen
vim.opt.scrolloff = 10

-- Allow whitespace selection in block mode
vim.opt.virtualedit = "block"

-- Hide command line until commands are relevant
vim.opt.cmdheight = 0
