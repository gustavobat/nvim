-- LSP
return {
  {
    'folke/neodev.nvim',
    config = function()
      require('neodev').setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
    end
  },
  {
    'VonHeikemen/lsp-zero.nvim', -- LSP/Completion support
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'jose-elias-alvarez/null-ls.nvim' },

      -- Copilot
      { 'github/copilot.vim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'folke/neodev.nvim' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    },
    config = function()
      local lsp_zero = require('lsp-zero').preset({})
      local cmp = require('cmp')
      lsp_zero.nvim_workspace()
      lsp_zero.format_on_save({
        format_opts = {
          async = false,
          timeout_ms = 10000,
        },
        servers = {
          ['lua_ls'] = { 'lua' },
          ['rust_analyzer'] = { 'rust' },
          ['eslint'] = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
          ['null-ls'] = { 'javascript', 'typescript', 'sh', 'bash', 'html' },
        }
      })

      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {},
        handlers = {
          lsp_zero.default_setup,
        },
      })
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.diagnostics.shellcheck,
        },
      })

      -- LSP settings
      -- This function gets run when an LSP connects to a particular buffer
      lsp_zero.on_attach(function(_, bufnr)
        -- Mapping helper function
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Lesser used LSP functionality
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
      end)

      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      local cmp_mappings = lsp_zero.defaults.cmp_mappings({
        ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      })

      -- Disable completion with tab
      cmp_mappings['<Tab>'] = nil
      cmp_mappings['<S-Tab>'] = nil

      lsp_zero.setup_nvim_cmp({
        mapping = cmp_mappings
      })
      -- `nvim-cmp` supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      -- Set env vars for ESP32 projects
      local lspconfig = require('lspconfig')
      local root_pattern = lspconfig.util.root_pattern

      lspconfig.rust_analyzer.setup({
        on_new_config = function(_, root_dir)
          local is_esp = root_pattern('sdkconfig.defaults')
          local is_rust = root_pattern('Cargo.toml')
          if is_esp(root_dir) and is_rust(root_dir) then
            -- Get the path to the ESP32 export file from '.env' file
            local lines = vim.fn.readfile(root_dir .. '/.env')
            local esp_idf_export_path = vim.fn.split(lines[1], '=')[2]
            local source_cmd = 'source ' .. esp_idf_export_path
            vim.fn.system(source_cmd)
          end
        end,
        settings = {
          ['rust-analyzer'] = {
            checkOnSave = {
              allFeatures = true,
              overrideCommand = {
                'cargo', 'clippy', '--workspace', '--message-format=json',
                '--all-targets', '--all-features'
              }
            }
          }
        }
      })

      lsp_zero.setup()
    end
  }
}
