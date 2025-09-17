-- Plugins that affect the user interface

return {

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
      end,
    },
    opts = {
      highlight = {
        enable = true, -- false will disable the whole extension
      },
    }
  },

  -- colorscheme
  {
    "olimorris/onedarkpro.nvim",
    lazy=false,
    priority=1000,
    opts = {
      highlights = {
        -- Highlighting every variable is far far too colourful
        ["@variable"] = { },
      },
    },
  },

  -- Markdown prettifier
  {
      'MeanderingProgrammer/markdown.nvim',
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      opts = {},
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

  -- Smooth scrolling
  {
    'karb94/neoscroll.nvim',
    lazy = false,
    opts = {} ;
  },
}
