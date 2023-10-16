-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- See `:help vim.opt`
local options = {
  -- Identation stuff
  expandtab = true,
  shiftwidth = 2,
  smartindent = true,
  tabstop = 2,
  softtabstop = 2,

  -- Line numbering
  number = true,
  relativenumber = true,

  -- Disable swap files
  swapfile = false,

  -- Faster update time (for cmp)
  updatetime = 250,

  -- Save undo history
  undofile = true,

  -- Ensure always 10 lines below the cursor
  scrolloff = 10,

  -- Term GUI colors
  termguicolors = true,
}

for key, value in pairs(options) do
  vim.opt[key] = value
end
