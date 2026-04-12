local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ============================================================================
-- CORE CONFIGURATION
-- ============================================================================

config.font = wezterm.font_with_fallback({
  '0xProtoNerdFont',
  'FiraCode Nerd Font',
  'JetBrainsMono Nerd Font',
})
config.font_size = 12.0
config.line_height = 1.1

config.color_scheme = 'rose-pine'
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }

config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
config.show_tab_index_in_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = true

config.scrollback_lines = 100000
config.default_cursor_style = 'BlinkingBar'
config.audible_bell = 'Disabled'

-- ============================================================================
-- KEY BINDINGS (tmux-friendly, no SSH bindings)
-- ============================================================================

config.keys = {
  -- Tab management
  { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentPane { confirm = true } },
  { key = 'Tab', mods = 'CTRL', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
  -- Pane splits (Alt-based, leaves Ctrl for tmux)
  { key = '"', mods = 'ALT|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = '%', mods = 'ALT|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  -- Pane navigation
  { key = 'h', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Right' },
  -- Utilities
  { key = 'f', mods = 'CTRL|SHIFT', action = wezterm.action.ShowLauncher },
  { key = 'c', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateCopyMode },
  { key = 'Space', mods = 'ALT|SHIFT', action = wezterm.action.QuickSelect },
  -- Font/size
  { key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = wezterm.action.ResetFontSize },
  { key = 'f', mods = 'CTRL|ALT', action = wezterm.action.ToggleFullScreen },
}

return config
