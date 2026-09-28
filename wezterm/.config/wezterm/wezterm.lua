local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action
local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_mac = wezterm.target_triple:find("darwin")

local action_key = "ALT"
local rev_action_key = "ALT|SHIFT"

if is_windows then
	config.default_domain = "WSL:Ubuntu"
end

if is_mac then
	action_key = "CMD"
	rev_action_key = "CMD|SHIFT"
end

-- Colors
-- config.color_scheme = "Hemisu Dark (Gogh)"
config.color_scheme = "Horizon Dark (Gogh)"
config.term = "xterm-256color"

-- Font settings
if is_windows then
	config.font_size = 11
elseif is_mac then 
	config.font_size = 16
else
	config.font_size = 13
end
config.font = wezterm.font("MesloLGL Nerd Font")

-- Appearance
config.window_decorations = "RESIZE"
config.window_background_opacity = 1
config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false

-- Tabs
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  -- 1. Check if an escape sequence (like our Zsh hook) set a tab title
  local title = tab.tab_title
  
  -- 2. Fallback to active pane title if no explicit tab title exists
  if not title or #title == 0 then
	title = tab.active_pane.title
  end

  return {
	{ Text = ' ' .. title .. ' ' },
  }
end)


-- Keybidings
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	{
		key = "=",
		mods = "LEADER",
		action = wezterm.action_callback(function(window)
			local overrides = window:get_config_overrides() or {}
			local current_scheme = overrides.color_scheme or config.color_scheme

			if current_scheme == "Horizon Dark (Gogh)" then
				overrides.color_scheme = "Horizon Bright (Gogh)"
			else
				overrides.color_scheme = "Horizon Dark (Gogh)"
			end

			window:set_config_overrides(overrides)
		end),
	},
	{
		key = "s",
		mods = "LEADER",
		action = wezterm.action.PaneSelect({ mode = "SwapWithActive" }),
	},
	{
		key = "w",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "z",
		mods = "LEADER",
		action = act.TogglePaneZoomState,
	},
}

-- ALT: primary actions
for _, v in ipairs({
	{ "Enter", act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ "w", act.CloseCurrentPane({ confirm = true }) },
	{ "t", act.SpawnTab("CurrentPaneDomain") },
	{ "h", act.ActivatePaneDirection("Left") },
	{ "l", act.ActivatePaneDirection("Right") },
	{ "j", act.ActivatePaneDirection("Up") },
	{ "k", act.ActivatePaneDirection("Down") },
	{ "LeftArrow", act.ActivateTabRelative(-1) },
	{ "RightArrow", act.ActivateTabRelative(1) },
}) do
	table.insert(config.keys, { mods = action_key, key = v[1], action = v[2] })
end

-- ALT+SHIFT: additional actions
for _, v in ipairs({
	{ "Enter", act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ "z", act.TogglePaneZoomState },
}) do
	table.insert(config.keys, { mods = rev_action_key, key = v[1], action = v[2] })
end

-- ALT+1-8: goto tab
for i = 0, 7 do
	table.insert(config.keys, { mods = "ALT", key = tostring(i + 1), action = act.ActivateTab(i) })
end

-- Mouse bindings
config.mouse_bindings = {
	{ event = { Down = { streak = 1, button = "Right" } }, mods = "NONE", action = act.CopyTo("Clipboard") },
	{
		event = { Down = { streak = 1, button = "Middle" } },
		mods = "NONE",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		event = { Down = { streak = 1, button = "Middle" } },
		mods = "SHIFT",
		action = act.CloseCurrentPane({ confirm = false }),
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

-- Performance settings
config.enable_wayland = false
config.front_end = "OpenGL"
config.max_fps = 120
config.prefer_egl = true

-- Hooks
wezterm.on("update-status", function(window, pane)
	local name = window:active_key_table()
	local leader = ""

	-- Sprawdzenie czy Leader jest aktywny
	if window:leader_is_active() then
		leader = "  LEADER  "
	end

	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "#ffffff" } },
		{ Background = { Color = "#ff0000" } },
		{ Attribute = { Intensity = "Bold" } },
		{ Text = leader },
	}))
end)

return config
