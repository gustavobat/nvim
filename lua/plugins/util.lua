return {
  {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      require('hop').setup({ keys = 'etovxqpdygfblzhckisuran' })
    end
  },
  {
    'windwp/nvim-autopairs',
    config = function() require('nvim-autopairs').setup {} end
  },
  {
    'm4xshen/hardtime.nvim',
    event = 'VeryLazy',
    opts = {},
    config = function()
      require('hardtime').setup {
        disable_mouse = false,
      }
    end
  },
}
