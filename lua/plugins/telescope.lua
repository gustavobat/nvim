return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.4',
  dependencies = { { 'nvim-lua/plenary.nvim' }, { 'nvim-telescope/telescope-live-grep-args.nvim' } },
  config = function()
    require('telescope').setup()
  end,
}
