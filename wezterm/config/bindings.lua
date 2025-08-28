local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

local mod = {}
mod.SUPER='ALT'
mod.SUPER_REV='ALT|CTRL'

-- stylua: ignore
local keys = {
    -- misc/useful --
    { key = '/',    mods = mod.SUPER,     action = act.ActivateCopyMode },
    { key = 'r',    mods = mod.SUPER_REV, action = act.ReloadConfiguration },

    -- copy/paste --
    { key = 'c',    mods = 'CTRL|SHIFT',  action = act.CopyTo('Clipboard') },
    { key = 'v',    mods = 'CTRL|SHIFT',  action = act.PasteFrom('Clipboard') },

    -- tabs --
    -- tabs: spawn+close
    { key = 't',    mods = mod.SUPER,     action = act.SpawnTab('DefaultDomain') },
    { key = 'w',    mods = mod.SUPER,     action = act.CloseCurrentTab({ confirm = false }) },

    -- tabs: navigation
    { key = '[',    mods = mod.SUPER,     action = act.ActivateTabRelative(-1) },
    { key = ']',    mods = mod.SUPER,     action = act.ActivateTabRelative(1) },
    { key = '[',    mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
    { key = ']',    mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },

    -- tab: title
    {
        key = '0',
        mods = mod.SUPER,
        action = act.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, _, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },

    -- panes --
    -- panes: spawn+close
    { key = 's',    mods = mod.SUPER,     action = act.SplitHorizontal }, -- [s]plit horizontal
    { key = 'v',    mods = mod.SUPER,     action = act.SplitVertical },   -- split [v]ertical
    -- ctrl+D spam to close pane

    -- panes: moving + resizing
    { key = 'h',           mods = mod.SUPER,       action = act.ActivatePaneDirection 'Left' },
    { key = 'l',           mods = mod.SUPER,       action = act.ActivatePaneDirection 'Right' },
    { key = 'j',           mods = mod.SUPER,       action = act.ActivatePaneDirection 'Down' },
    { key = 'k',           mods = mod.SUPER,       action = act.ActivatePaneDirection 'Up' },
    { key = 'LeftArrow',   mods = mod.SUPER,       action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow',  mods = mod.SUPER,       action = act.ActivatePaneDirection 'Right' },
    { key = 'DownArrow',   mods = mod.SUPER,       action = act.ActivatePaneDirection 'Down' },
    { key = 'UpArrow',     mods = mod.SUPER,       action = act.ActivatePaneDirection 'Up' },
    { key = 'h',           mods = mod.SUPER_REV,   action = act.AdjustPaneSize { 'Left', 1 } },
    { key = 'l',           mods = mod.SUPER_REV,   action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'j',           mods = mod.SUPER_REV,   action = act.AdjustPaneSize { 'Down', 1 } },
    { key = 'k',           mods = mod.SUPER_REV,   action = act.AdjustPaneSize { 'Up', 1 } },

    -- panes: fullscreen
    { key = 'f',    mods = mod.SUPER,     action = act.TogglePaneZoomState },
}

local mouse_bindings = {
    -- Ctrl-click will open the link under the mouse cursor
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = act.OpenLinkAtMouseCursor,
    },
}

-- These copy and search modes attempt to emulate the behaviour of tmux's scrollback mode.
-- This means pressing /, searching, then pressing Enter allows searching through the scrollback buffer.
-- Pressing n and N will navigate through the search results without starting selection.
local extend_copy_mode = {
    { key = '/', mods = 'NONE', action = act.Search { CaseInSensitiveString = '' } },
    { key = 'n',
        mods = 'NONE',
        action = act.Multiple {
            act.CopyMode 'NextMatch',
            act.ClearSelection,
            act.CopyMode 'ClearSelectionMode',
        }
    },
    { key = 'N',
        mods = 'SHIFT',
        action = act.Multiple {
            act.CopyMode 'PriorMatch',
            act.ClearSelection,
            act.CopyMode 'ClearSelectionMode',
        }
    },
    { key = 'x', mods = 'NONE', action = act.CopyMode 'ClearSelectionMode' },
    { key = 'Escape', mods = 'NONE', action = act.Multiple{
        act.ClearSelection,
        act.CopyMode 'ClearSelectionMode',
        act.CopyMode 'Close',
    } },
}
local extend_search_mode = {
    {
        key = 'Enter',
        mods = 'NONE',
        action = act.Multiple{
            act.ActivateCopyMode,
            act.ClearSelection,
            act.CopyMode 'ClearSelectionMode',
        }
    },
}


function M.setup(config)
    config.disable_default_key_bindings = true

    -- alt+space as leader key
    config.leader = { key = 'Space', mods = 'CTRL' }

    config.keys = keys
    config.mouse_bindings = mouse_bindings

    copy_mode = wezterm.gui.default_key_tables().copy_mode
    for _, v in ipairs(extend_copy_mode) do
        table.insert(copy_mode, v)
    end
    search_mode = wezterm.gui.default_key_tables().search_mode
    for _, v in ipairs(extend_search_mode) do
        table.insert(search_mode, v)
    end

    config.key_tables = {
        copy_mode = copy_mode,
        search_mode = search_mode,
    }

end

return M
