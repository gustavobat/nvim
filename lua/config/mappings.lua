-- Helper functions
-- See `:help vim.keymap.set()`

-- Helper functions
local nmap = function(tbl)
  vim.keymap.set('n', tbl[1], tbl[2], tbl[3])
end

local vmap = function(tbl)
  vim.keymap.set('v', tbl[1], tbl[2], tbl[3])
end

-- Better defaults
vmap({ "J", ":m '>+1<CR>gv=gv", { desc = 'Move line down in visual mode' } })
vmap({ "K", ":m '<-2<CR>gv=gv", { desc = 'Move line up in visual mode' } })
nmap({ "J", "mzJ`z", { desc = 'Like J but keeping cursor position' } })
nmap({ "<C-d>", "<C-d>zz" })
nmap({ "<C-u>", "<C-u>zz" })
nmap({ "n", "nzzzv" })
nmap({ "N", "Nzzzv" })
nmap({ "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]] })
nmap({ 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true } })
nmap({ 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true } })
nmap({ '<esc>', [[:noh<cr><esc>]], { silent = true } })

-- Disable space in normal/visual mode
nmap({ '<Space>', '<Nop>', { silent = true } })
vmap({ '<Space>', '<Nop>', { silent = true } })

-- Diagnostic keymaps
nmap({ '[d', vim.diagnostic.goto_prev })
nmap({ ']d', vim.diagnostic.goto_next })
nmap({ '<leader>e', vim.diagnostic.open_float })
nmap({ '<leader>q', vim.diagnostic.setloclist })

-- Formatting
nmap({ "<leader>fmt", vim.lsp.buf.format })

-- Telescope
-- See `:help telescope.builtin`
local status_ok, t = pcall(require, 'telescope.builtin')
if status_ok then
  pcall(t.load_extension, 'fzf')            -- Enable telescope fzf native, if installed
  pcall(t.load_extension, 'live_grep_args') -- Enable telescope live_grep_args, if installed
  nmap({ '<leader>sf', t.find_files, { desc = '[S]earch [F]iles' } })
  nmap({ '<leader>sh', t.help_tags, { desc = '[S]earch [H]elp' } })
  nmap({ '<leader>sw', t.grep_string, { desc = '[S]earch current [W]ord' } })
  nmap({ '<leader>sg', t.live_grep, { desc = '[S]earch by [G]rep' } })
  nmap({ '<leader>sd', t.diagnostics, { desc = '[S]earch [D]iagnostics' } })
  nmap({ '<leader>sv', t.git_files, { desc = '[S]earch [V]ersion Control' } })
  nmap({ '<leader>sh', t.help_tags, { desc = '[S]earch [H]elptags' } })
  nmap({ '<leader>sc', require('telescope').extensions.live_grep_args.live_grep_args, { desc = '[S]earch [C]omposite' } })

  nmap({ '<leader>?', t.oldfiles, { desc = '[?] Find recently opened files' } })
  nmap({ '<leader><space>', t.buffers, { desc = '[ ] Find existing buffers' } })
  nmap({ '<leader>/',
    function()
      t.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end,
    { desc = '[/] Fuzzily search in current buffer]' } })
end

-- File tree
status_ok, t = pcall(require, 'nvim-tree.api')
if status_ok then
  nmap({ '<leader>pv', t.tree.toggle, { desc = '[P]roject [V]iew' } })
end

-- Toggle terminal
nmap({ '<leader>tt', '<cmd>ToggleTerm direction=horizontal<cr>', { desc = '[T]erminal [T]oggle' } })

-- Toggleterm
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- HOP / Search current buffer
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, { remap = true })
vim.keymap.set('', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, { remap = true })
vim.keymap.set('', 't', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, { remap = true })
vim.keymap.set('', 'T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, { remap = true })
hop.setup()

