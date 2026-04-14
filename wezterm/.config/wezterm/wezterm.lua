local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font settings
config.font_size = 13
config.font = wezterm.font("MesloLGL Nerd Font")

-- Colors
config.colors = {
	cursor_bg = "white",
	cursor_border = "white",
}

-- Appearance
config.window_decorations = "NONE"
config.enable_wayland = true

return config
