local wezterm = require('wezterm')

local M = {}

function M.setup(config)
    config.default_cwd = wezterm.home_dir
    config.audible_bell = 'Disabled'
end

return M
