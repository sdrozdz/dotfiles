local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- Colors
config.color_scheme = "Github Dark (Gogh)"

-- Font settings
config.font_size = 13
config.font = wezterm.font("MesloLGL Nerd Font")

-- Appearance
config.window_decorations = "RESIZE"
config.enable_wayland = true

-- Keybidings
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 }
config.keys = {
  {
    key = 's',
    mods = 'LEADER',
    action = wezterm.action.PaneSelect { mode = 'SwapWithActive' },
  }
}

-- ALT: primary actions
for _, v in ipairs({
  { "Enter",      act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { "w",          act.CloseCurrentPane { confirm = true } },
  { "t",          act.SpawnTab 'CurrentPaneDomain' },
  { "h",          act.ActivatePaneDirection 'Left' },
  { "l",          act.ActivatePaneDirection 'Right' },
  { "j",          act.ActivatePaneDirection 'Up' },
  { "k",          act.ActivatePaneDirection 'Down' },
  { "LeftArrow",  act.ActivateTabRelative(-1) },
  { "RightArrow", act.ActivateTabRelative(1) },
}) do table.insert(config.keys, { mods = "ALT", key = v[1], action = v[2] }) end

-- ALT+SHIFT: additional actions
for _, v in ipairs({
  { "Enter", act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { "z",     act.TogglePaneZoomState },
}) do table.insert(config.keys, { mods = "ALT|SHIFT", key = v[1], action = v[2] }) end

-- ALT+1-8: goto tab
for i = 0, 7 do table.insert(config.keys, { mods = "ALT", key = tostring(i + 1), action = act.ActivateTab(i) }) end


-- Mouse bindings
config.mouse_bindings = {
  { event = { Down = { streak = 1, button = "Right" } }, mods = "NONE", action = act.CopyTo("Clipboard") },
  { event = { Down = { streak = 1, button = "Middle" } }, mods = "NONE", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { event = { Down = { streak = 1, button = "Middle" } }, mods = "SHIFT", action = act.CloseCurrentPane { confirm = false } }
}

-- Performance settings
config.max_fps = 120

-- Hooks
wezterm.on('update-status', function(window, pane)
  local name = window:active_key_table()
  local leader = ""

  -- Sprawdzenie czy Leader jest aktywny
  if window:leader_is_active() then
    leader = '  LEADER  '
  end

  window:set_right_status(wezterm.format({
    { Foreground = { Color = '#ffffff' } },
    { Background = { Color = '#ff0000' } }, 
    { Attribute = { Intensity = 'Bold' } },
    { Text = leader },
  }))
end)

return config
