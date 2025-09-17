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
    opts = {
      auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    }
  },
}
