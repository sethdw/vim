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

    -- Easy install lsp/linters
    {
      'williamboman/mason.nvim',
      lazy = false,
      cmd = "Mason",
      keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
      build = ":MasonUpdate",
      opts = {
        ensure_installed = {
          "python-lsp-server",
          "stylua",
        },
      },
      config = function(_, opts)
        require("mason").setup(opts)
        local mr = require("mason-registry")
        local function ensure_installed()
          for _, tool in ipairs(opts.ensure_installed) do
            local p = mr.get_package(tool)
            if not p:is_installed() then
              p:install()
            end
          end
        end
        if mr.refresh then
          mr.refresh(ensure_installed)
        else
          ensure_installed()
        end
      end,
    },

    -- LSP 
    {
      'neovim/nvim-lspconfig', -- Collection of configurations for built-in LSP client
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
        { "folke/neodev.nvim", opts = {} },
        "mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
      },
      config = function(_, opts)
        local lspconfig = require 'lspconfig'

        local on_attach = function(_, bufnr)
          local attach_opts = { silent = true, buffer = bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, attach_opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, attach_opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, attach_opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, attach_opts)
          vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, attach_opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, attach_opts)
          vim.keymap.set('n', 'so', require('telescope.builtin').lsp_references, attach_opts)
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        lspconfig.pylsp.setup{}
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
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setqflist)

require('neoscroll').setup()

-- Telescope
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native
require('telescope').load_extension 'fzf'

-- Telescope buffer navigation
vim.keymap.set('n', '<C-h>', function() require('telescope.builtin').buffers { sort_lastused = true } end)
vim.keymap.set('n', '<C-o>', function() require('telescope.builtin').find_files { previewer = false } end)

-- Handy telescope searches
vim.keymap.set('n', '<leader>sb', function() require('telescope.builtin').current_buffer_fuzzy_find() end)
vim.keymap.set('n', '<leader>sh', function() require('telescope.builtin').help_tags() end)

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
vim.o.colorcolumn = 80
vim.o.lcs = "trail:⎵"
vim.o.mouse = 'nc'

-- Pretty
vim.o.termguicolors = true
vim.o.syntax = true
vim.cmd.colorscheme 'lunaperche'

-- ;; to exit insert
vim.keymap.set('i', ';;', '<esc>', {noremap = true} )

-- remove gutters for copying for commenting
vim.keymap.set('n', '\\c',
    function() 
        require('gitsigns').toggle_signs()
        vim.cmd("TSToggle python")
        vim.cmd("set number!")
    end
)
