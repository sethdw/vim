# Bootstrap lazy.vim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- Smooth scrolling
    {
      'karb94/neoscroll.nvim',
      lazy = false,
      config = function()
        require('neoscroll').setup()
      end,
    },

    -- Status line
    {
      'nvim-lualine/lualine.nvim',
      opts = {
        options = {
          icons_enabled = false,
          component_separators = '|',
          section_separators = '',
        },
      },
      requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    },

    -- Gitgutter
    {
      'lewis6991/gitsigns.nvim',
      opts = {
          signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        on_attach = function(bufnr)
          vim.keymap.set('n', '[c', require('gitsigns').prev_hunk, { buffer = bufnr })
          vim.keymap.set('n', ']c', require('gitsigns').next_hunk, { buffer = bufnr })
        end,
      }
    },

    -- Treesitter
    {
      'nvim-treesitter/nvim-treesitter',
      version = false,
      build = ":TSUpdate",
      event = { "BufReadPost", "BufNewFile" },
      cmd = { "TSUpdateSync" },
      dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects', -- Additional textobjects for treesitter
        init = function()
          require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
          load_textobjects = true
        end,
      },
      opts = {
        highlight = {
          enable = true, -- false will disable the whole extension
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
          },
        },
        indent = {
          enable = true,
        },
      }
    },

    { -- LSP config - Yoinked from kickstart.nvim
      'neovim/nvim-lspconfig',
      dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',

        -- Useful status updates for LSP.
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        { 'j-hui/fidget.nvim', opts = {} },

        -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        { 'folke/neodev.nvim', opts = {} },
      },
      config = function()
        --  This function gets run when an LSP attaches to a particular buffer.
        --    That is to say, every time a new file is opened that is associated with
        --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
        --    function will be executed to configure the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
          callback = function(event)
            local map = function(keys, func, desc)
              vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
            end

            -- Jump to the definition of the word under your cursor.
            --  This is where a variable was first declared, or where a function is defined, etc.
            --  To jump back, press <C-t>.
            map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

            -- Find references for the word under your cursor.
            map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

            -- Jump to the implementation of the word under your cursor.
            --  Useful when your language has ways of declaring types without an actual implementation.
            map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

            -- Jump to the type of the word under your cursor.
            --  Useful when you're not sure what type a variable is and you want to see
            --  the definition of its *type*, not where it was *defined*.
            map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

            -- Fuzzy find all the symbols in your current document.
            --  Symbols are things like variables, functions, types, etc.
            map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

            -- Fuzzy find all the symbols in your current workspace.
            --  Similar to document symbols, except searches over your entire project.
            map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

            -- Rename the variable under your cursor.
            --  Most Language Servers support renaming across files, etc.
            map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

            -- Execute a code action, usually your cursor needs to be on top of an error
            -- or a suggestion from your LSP for this to activate.
            map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

            -- Opens a popup that displays documentation about the word under your cursor
            --  See `:help K` for why this keymap.
            map('K', vim.lsp.buf.hover, 'Hover Documentation')

            -- WARN: This is not Goto Definition, this is Goto Declaration.
            --  For example, in C this would take you to the header.
            map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          end,
        })

        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        -- Enable the following language servers
        --  Add any additional override configuration in the following tables. Available keys are:
        --  - cmd (table): Override the default command used to start the server
        --  - filetypes (table): Override the default list of associated filetypes for the server
        --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  - settings (table): Override the default settings passed when initializing the server.
        --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
        local servers = {
          -- See `:help lspconfig-all` for a list of all the pre-configured LSPs

          basedpyright = {
            capabilities = (function()
              local caps = vim.lsp.protocol.make_client_capabilities()
              capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
              return caps
            end)(),

            settings = {
              basedpyright = {
                analysis = {
                  reportAny = 'none',
                  typeCheckingMode = 'standard',
                },
              },
            },
          },

          lua_ls = {
            -- cmd = {...},
            -- filetypes = { ...},
            -- capabilities = {},
            settings = {
              Lua = {
                completion = {
                  callSnippet = 'Replace',
                },
                -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                -- diagnostics = { disable = { 'missing-fields' } },
              },
            },
          },
        }

        require('mason').setup()

        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
          'stylua', -- Used to format Lua code
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        require('mason-lspconfig').setup {
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              -- This handles overriding only values explicitly passed
              -- by the server configuration above. Useful when disabling
              -- certain features of an LSP (for example, turning off formatting for tsserver)
              server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
              require('lspconfig')[server_name].setup(server)
            end,
          },
        }
      end,
    },

    -- snippets
    {
      "L3MON4D3/LuaSnip",
      event = "InsertEnter",
      build = (not jit.os:find("Windows"))
          and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
        or nil,
      dependencies = {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load({include = {'python'}})
        end,
      },
      opts = {
        history = true,
        delete_check_events = "TextChanged",
      },
    },

    -- auto completion
    {
      "hrsh7th/nvim-cmp",
      version = false, -- last release is way too old
      event = "InsertEnter",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
      },
      opts = function()
        vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local defaults = require("cmp.config.default")()
        return {
          completion = {
            completeopt = "menu,menuone,noinsert",
          },
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = false,
            },
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
          }),
          sorting = defaults.sorting,
        }
      end,
    },

    -- Fuzzy Finder (files, lsp, etc)
    { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },

    -- Markdown prettifier
    {
        'MeanderingProgrammer/markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('render-markdown').setup({})
        end,
    },

    -- inline git-blame and blame commit copying
    {
      'f-person/git-blame.nvim',
      keys = {
        {' b', '<cmd>GitBlameToggle<CR>', desc = 'Git [b]lame'},
        {' bc', '<cmd>GitBlameCopySHA<CR>', desc = 'Git [b]lame [c]opy commit ID'},
      },
      config = function()
        require('gitblame').setup({})

        vim.g.gitblame_virtual_text_column = 0
        vim.g.gitblame_highlight_group = 'NonText'
        vim.g.gitblame_message_template = '      <committer> - <sha> - <summary>'
      end,
    },

    -- per-cwd session saving
    {
      'rmagatti/auto-session',
      config = function()
        require("auto-session").setup({
          auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        })
        vim.g.auto_session_root_dir = '/home/sethw/.config/nvim/sessions'
      end,
    },

    -- copilot
    {
      'github/copilot.vim',
      config = function()
        vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
          expr = true,
          replace_keycodes = false
        })
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_suggest = false
      end,
    },
  },

  -- Global options
  {
    lazy = true
  }
)

--Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Diagnostic settings
vim.diagnostic.config {
  virtual_text = false,
  update_in_insert = true,
}

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)


-- require('neoscroll').setup()

-- Telescope
-- require('telescope').setup {
--   defaults = {
--     mappings = {
--       i = {
--         ['<C-u>'] = false,
--         ['<C-d>'] = false,
--       },
--     },
--   },
-- }
-- 
-- Enable telescope fzf native
--require('telescope').load_extension 'fzf'

-- Telescope buffer navigation
-- vim.keymap.set('n', '<C-h>', function() require('telescope.builtin').buffers { sort_lastused = true } end)
-- vim.keymap.set('n', '<C-o>', function() require('telescope.builtin').find_files { previewer = false } end)

-- Handy telescope searches
-- vim.keymap.set('n', '<leader>sb', function() require('telescope.builtin').current_buffer_fuzzy_find() end)
-- vim.keymap.set('n', '<leader>sh', function() require('telescope.builtin').help_tags() end)

-- Tools
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.autoread = true
vim.o.wildmenu = true
vim.o.cursorline = true
vim.o.wildmenu = true
vim.o.number = true
--vim.o.colorcolumn = 80
vim.o.lcs = "trail:⎵"
vim.o.mouse = 'nc'

-- Pretty
vim.o.termguicolors = true
vim.cmd.colorscheme 'lunaperche'

-- ;; to exit insert
vim.keymap.set('i', ';;', '<esc>', {noremap = true} )

-- remove gutters for copying for commenting
vim.keymap.set('n', '\\c',
    function()
        require('gitsigns').toggle_signs()
        vim.cmd("TSToggle python")
        vim.cmd("set number!")
        vim.cmd("GitBlameToggle")
    end
)

-- vim.lsp.set_log_level("debug")
