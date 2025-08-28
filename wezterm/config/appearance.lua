local wezterm = require('wezterm')

local M = {}

function M.setup(config)
     config.enable_scroll_bar = true
     config.window_decorations="RESIZE"
     config.enable_tab_bar = true
     config.inactive_pane_hsb = {
         saturation = 0.75,
         brightness = 0.75,
     }
     config.font = wezterm.font('FiraCode Nerd Font', {weight='Regular', stretch='Normal', style='Normal'})
end

return M
