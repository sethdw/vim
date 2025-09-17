-- Plugins for Version Control Systems (aka Git, but maybe I'll need another in the future)

return {
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

}
