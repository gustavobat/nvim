-- UI plugins
return {
  -- Git blame and diff signs
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        current_line_blame = false,
        current_line_blame_formatter = '<summary> - <author>, <author_time:%d/%m/%Y>',
        current_line_blame_opts = {
          delay = 100,
        },
        signs = {
          untracked = {
            hl = 'GitSignsAdd',
            text = '│',
            numhl = 'GitSignsAddNr',
            linehl = 'GitSignsAddLn',
          },
        },
      })
    end
  },
  -- File tree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      config = function()
        require('nvim-tree').setup({
          disable_netrw = true,
          hijack_netrw = true,
        })
      end
    },
    tag = 'nightly'
  },
  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup({
        extensions = { 'nvim-tree' },
      })
    end,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
  -- Floating terminal
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require("toggleterm").setup {
        float_opts = {
          border = 'curved'
        }
      }
    end
  },
  -- Status column
  {
    'luukvbaal/statuscol.nvim',
    config = function()
      local builtin = require("statuscol.builtin")
      local cfg = {
        separator              = "|",    -- separator between line number and buffer text ("│" or extra " " padding)
        -- Builtin line number string options for ScLn() segment
        thousands              = false,  -- or line number thousands separator string ("." / ",")
        relculright            = true,   -- whether to right-align the cursor line number with 'relativenumber' set
        -- Custom line number string options for ScLn() segment
        lnumfunc               = nil,    -- custom function called by ScLn(), should return a string
        reeval                 = false,  -- whether or not the string returned by lnumfunc should be reevaluated
        -- Builtin 'statuscolumn' options
        setopt                 = true,   -- whether to set the 'statuscolumn', providing builtin click actions
        order                  = "FSNs", -- order of the fold, sign, line number and separator segments
        -- Click actions
        Lnum                   = builtin.lnum_click,
        FoldPlus               = builtin.foldplus_click,
        FoldMinus              = builtin.foldminus_click,
        FoldEmpty              = builtin.foldempty_click,
        DapBreakpointRejected  = builtin.toggle_breakpoint,
        DapBreakpoint          = builtin.toggle_breakpoint,
        DapBreakpointCondition = builtin.toggle_breakpoint,
        DiagnosticSignError    = builtin.diagnostic_click,
        DiagnosticSignHint     = builtin.diagnostic_click,
        DiagnosticSignInfo     = builtin.diagnostic_click,
        DiagnosticSignWarn     = builtin.diagnostic_click,
        GitSignsTopdelete      = builtin.gitsigns_click,
        GitSignsUntracked      = builtin.gitsigns_click,
        GitSignsAdd            = builtin.gitsigns_click,
        GitSignsChangedelete   = builtin.gitsigns_click,
        GitSignsDelete         = builtin.gitsigns_click,
      }
      require("statuscol").setup(cfg)
    end
  },
  -- LSP progress
  {
    'j-hui/fidget.nvim',
    config = function()
      local options = {
        text = {
          spinner = 'dots'
        },
        fmt = {
          stack_upwards = true
        }
      }
      require('fidget').setup(options)
    end
  }
}
