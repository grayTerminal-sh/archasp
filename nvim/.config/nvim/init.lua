-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Options de base
local o = vim.opt

o.number = true
o.relativenumber = true
o.termguicolors = true
o.cursorline = true

o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true

o.ignorecase = true
o.smartcase = true

o.wrap = false
o.scrolloff = 5
o.signcolumn = "yes"

o.clipboard = "unnamedplus"

-- Avant require("config.lazy")
local ts_site = vim.fn.stdpath("data") .. "/site"
if not vim.tbl_contains(vim.opt.rtp:get(), ts_site) then
  vim.opt.rtp:append(ts_site)
end

-- Appel de Lazy
require("config.lazy")

-- Appel de .md config
require("config.markdown")

-- Position du curser
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- Colorscheme
vim.cmd.colorscheme("catppuccin-nvim")
-- Lire ~/.config/theme : "dark" ou "light"
local mode = "dark"
local ok, file = pcall(io.open, vim.fn.expand("~/.config/theme"), "r")
if ok and file then
  local line = file:read("*l")
  if line == "light" or line == "dark" then
    mode = line
  end
  file:close()
end

-- Config avant le colorscheme (optionnel mais conseillé)
local ok_tn, tn = pcall(require, "catppuccin-nvim")
if ok_tn then
  tn.setup({
    -- style par défaut (dark)
    style = "mocha",
    light_style = "latte", -- utilisé quand background = light
  })
end

if mode == "light" then
  vim.o.background = "light"
  vim.cmd.colorscheme("catppuccin-latte")
else
  vim.o.background = "dark"
  vim.cmd.colorscheme("catppuccin-mocha")
end

-- Keymaps (fichier séparé)
require("config.maps")

-- Undo persistant
local undodir = vim.fn.stdpath("state") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undofile = true

-- Mini
require('mini.map').setup()

vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
