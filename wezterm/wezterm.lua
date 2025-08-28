local wezterm = require('wezterm')

local config = wezterm.config_builder()

local bindings = require('config.bindings')
bindings.setup(config)

local appearance = require('config.appearance')
appearance.setup(config)

return config
