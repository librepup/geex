-------------
-- General --
-------------
---- Fixes
-- Fix Lua TreeSitter Error
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*.lua",
  callback = function()
    vim.b.skip_treesitter = 1
    vim.opt_local.syntax = "lua"
  end,
})
local old_start = vim.treesitter.start
vim.treesitter.start = function(_, opts)
  if vim.bo.filetype == "lua" then
    return
  end
  return old_start(_, opts)
end
---- Variables
local set = vim.opt
local cmd = vim.cmd
local g = vim.g
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
---- Settings
set.termguicolors = true
set.autoindent = true
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.expandtab = true
set.cursorline = false
set.number = true
set.smartindent = true
set.wrap = true
set.swapfile = false
set.smartcase = true
set.breakindent = true
cmd('syntax on')
cmd('filetype plugin indent on')
-- Set Leader Key to Space
g.mapleader = " "
g.maplocalleader = " "

--------------
-- Keybinds --
--------------
---- Tabs
keymap("n", "<leader>T", ":tabnew<CR>", opts)
keymap("n", "<leader>W", ":tabclose<CR>", opts)
keymap("n", "<leader><Tab>", ":tabnext<CR>", opts)
keymap("n", "<leader><S-Tab>", ":tabprevious<CR>", opts)
---- Splits
keymap("n", "<leader>v", ":vsplit<CR>", opts)
keymap("n", "<leader>3", ":vsplit<CR>", opts)
keymap("n", "<leader>h", ":split<CR>", opts)
keymap("n", "<leader>2", ":split<CR>", opts)
keymap("n", "<leader>0", ":close<CR>", opts)
---- Pane (Window) Navigation
keymap("n", "<leader><Right>", "<C-w>l", opts)
keymap("n", "<leader><Left>", "<C-w>h", opts)
keymap("n", "<leader><Up>", "<C-w>k", opts)
keymap("n", "<leader><Down>", "<C-w>j", opts)
---- Save File
keymap("n", "<leader>s", ":write<CR>", opts)

-----------
-- Emacs --
-----------
---- Select
keymap("n", "<C-Space>", "v", opts)
keymap("n", "<C-x><Space>", "<c-v>", opts)
---- Save File
keymap("i", "<C-x>s", "<Esc>:w<CR>", opts)
keymap("n", "<C-x>s", ":w<CR>", opts)
keymap("i", "<C-x>s", "<C-o>:w<CR>", opts)
---- Open File
keymap("i", "<C-x>f", "<Esc>:e<Space>", opts)
keymap("n", "<C-x>f", ":e<Space>", opts)
---- File Explorer
keymap("n", "<C-x>d", ":Explore<CR>", opts)
---- Quit
keymap("n", "<C-x>c", ":q<CR>", opts)
---- Insert Mode Navigation
keymap("i", "<C-a>", "<Home>", opts)
keymap("i", "<C-e>", "<End>", opts)
keymap("i", "<C-b>", "<Left>", opts)
keymap("i", "<C-f>", "<Right>", opts)
keymap("i", "<C-p>", "<Up>", opts)
keymap("i", "<C-n>", "<Down>", opts)
---- Word Navigation in Insert Mode
keymap("i", "<M-b>", "<C-Left>", opts)
keymap("i", "<M-f>", "<C-Right>", opts)
---- Delete to End of Line
keymap("i", "<C-k>", "<C-o>D", opts)
keymap("n", "<C-k>", "dd", opts)
---- Clipboard Operations
keymap("v", "<M-w>", '"+y', opts)
keymap("n", "<C-y>", '"+p', opts)
keymap("i", "<C-y>", "<C-r>+", opts)
---- Undo/Redo
keymap("i", "<C-x>u", "<C-o>u", opts)
keymap("n", "<C-x>u", "u", opts)
keymap("n", "<C-x>r", "<C-r>", opts)
---- Window Management
keymap("n", "<C-x>2", ":split<CR>", opts)
keymap("n", "<C-x>3", ":vsplit<CR>", opts)
keymap("n", "<C-x>1", ":only<CR>", opts)
keymap("n", "<C-x>0", ":close<CR>", opts)
keymap("n", "<C-x>o", "<C-w>w", opts)
---- Tab Management
keymap("n", "<C-c>t", "<Esc>:tabnew<CR>", opts)
keymap("n", "<C-c>w", "<Esc>:tabclose<CR>", opts)
keymap("n", "<C-c><Tab>", "gt", opts)
keymap("n", "<C-c><S-Tab>", "gT", opts)
---- Buffer Switch
keymap("n", "<C-x>b", ":buffer<Space>", opts)
---- Search
keymap("n", "<C-s>", "/", opts)
keymap("i", "<C-s>", "<Esc>/", opts)
---- Cancel
keymap("i", "<C-g>", "<Esc>", opts)
keymap("n", "<C-g>", "<Esc>", opts)
---- Command Execution
keymap("i", "<M-x>c", "<C-o>:", opts)
keymap("n", "<M-x>c", "<C-o>:", opts)

-----------------
-- Colorscheme --
-----------------
vim.api.nvim_set_hl(0, "Normal", { fg = "#c5c5c6", bg = "#0f0f0f" })
vim.api.nvim_set_hl(0, "Cursor", { bg = "#c5c5c6" })
vim.api.nvim_set_hl(0, "Visual", { bg = "#89898a", fg = "#1a1a1a" }) -- 1a1a1a, c5c5c6
vim.api.nvim_set_hl(0, "Search", { fg = "#0f0f0f", bg = "#FFC12D", bold = true })
vim.api.nvim_set_hl(0, "IncSearch", { fg = "#0f0f0f", bg = "#B98E2A" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1a1a1a" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#c5c5c6", bg = "#0f0f0f", bold = true })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#89898a", bg = "#0f0f0f" })
vim.api.nvim_set_hl(0, "Comment", { fg = "#89898a", italic = true })
vim.api.nvim_set_hl(0, "@keyword", { fg = "#B98E2A", bold = true })
vim.api.nvim_set_hl(0, "@string", { fg = "#BC6E32" })
vim.api.nvim_set_hl(0, "@variable", { fg = "#7E8081" })
vim.api.nvim_set_hl(0, "@constant", { fg = "#FFC12D" })
vim.api.nvim_set_hl(0, "@function", { fg = "#ECA530" })
vim.api.nvim_set_hl(0, "@type", { fg = "#FFC12D" })
vim.api.nvim_set_hl(0, "@field", { fg = "#ECA530" })
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#5A5C5D", bold = true })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#B98E2A", bold = true })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#BC6E32", bold = true })
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#89898a" })
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#c5c5c6", bg = "#050505" })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#89898a", bg = "#0a0a0a" })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#050505", fg = "#c5c5c6" })
vim.api.nvim_set_hl(0, "TabLine", { bg = "#0f0f0f", fg = "#FFC12D", bold = true })
vim.api.nvim_set_hl(0, "TabLineSel", { bg = "#0f0f0f", fg = "#FFC12D", bold = true })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1a1a1a", fg = "#c5c5c6" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#ECA530", fg = "#0f0f0f" })
vim.api.nvim_set_hl(0, "MatchParen", { bg = "#FFC12D", fg = "#0f0f0f", bold = true })
vim.api.nvim_set_hl(0, "Directory", { fg = "#ECA530", bold = true })
vim.api.nvim_set_hl(0, "Link", { fg = "#ECA530", underline = true })
vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#BC6E32", bg = "#1a1a0f" })
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#B98E2A", bg = "#1a1a1a" })
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#5A5C5D", bg = "#1a1010" })
vim.api.nvim_set_hl(0, "@text.title1", { fg = "#FFC12D", bold = true })
vim.api.nvim_set_hl(0, "@text.title2", { fg = "#ECA530", bold = true })
vim.api.nvim_set_hl(0, "@text.literal.block", { bg = "#0a0a0a" })
vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#89898a" })
vim.cmd("hi clear SignColumn")
vim.cmd("hi link FloatBorder Comment")
vim.cmd("hi link EndOfBuffer Comment")
