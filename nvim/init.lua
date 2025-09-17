# Bootstrap lazy.vim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath }
end
vim.opt.rtp:prepend(lazypath)


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

vim.keymap.set('n', 'x', '"_x')

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

-- remove gutters for copying for commenting
vim.keymap.set('n', '\\c',
    function()
        require('gitsigns').toggle_signs()
        vim.cmd("TSToggle python")
        vim.cmd("set number!")
    end
)

require('lazy').setup('plugins')
vim.cmd.colorscheme 'onedark_dark'
-- vim.lsp.set_log_level("debug")
