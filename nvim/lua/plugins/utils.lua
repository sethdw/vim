-- Miscellaneous utilities plugins that don't quite fit in anywhere else


return {
  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
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

  -- keymaps helper
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  },

  -- be a nuisance when using bad habits
  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      disable_mouse = false,
      restriction_mode = "hint",
    },
  },
}
