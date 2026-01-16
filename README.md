# WindowManager.spoon

adaptive window tiling and focus management for macOS

## features

- adaptive window tiling (auto-detects ultrawide vs. standard screens)
- spatial window focus (cmd+arrows)
- overlapping window cluster cycling (shift+cmd+up/down)
- window switcher (cmd+tab toggle last two, cmd+` for terminal)
- optional monitor input source toggle (requires m1ddc)

## installation

### using SpoonInstall

```lua
-- in your ~/.hammerspoon/init.lua
hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall.repos.windowmanager = {
  url = "https://github.com/etedor/hammerspoon",
  desc = "window management spoon"
}

spoon.SpoonInstall:asyncUpdateAllRepos()

spoon.SpoonInstall:andUse("WindowManager", {
  repo = "windowmanager",
  start = true,
  config = {
    padding = 8,  -- gap between tiles and screen edges (px)
    ultrawideThreshold = 2.0,  -- aspect ratio threshold (21:9 ≈ 2.33)
    terminalApp = "Ghostty",  -- terminal app for cmd+` toggle
    enableInputToggle = false,  -- requires m1ddc
    monitorFocusEnabled = true,  -- enable mouse centering on monitor changes
  }
})
```

### manual installation

```bash
cd ~/.hammerspoon/Spoons
git clone https://github.com/etedor/hammerspoon WindowManager.spoon
```

```lua
-- in your ~/.hammerspoon/init.lua
local wm = hs.loadSpoon("WindowManager")
wm.padding = 8
wm.ultrawideThreshold = 2.0
wm.terminalApp = "Ghostty"
wm.monitorFocusEnabled = true
wm:start()
```

## hotkeys

### macos system

- **ctrl+←/→** - adjacent workspace
- **ctrl+↑** - mission control
- **ctrl+↓** - app exposé

### window tiling (ctrl+alt)

- **ctrl+alt+arrows** - tile window
- **ctrl+alt+arrow+arrow** - tile quarter/sixth
- **ctrl+alt+f** - fill screen
- **ctrl+alt+c** - center window
- **ctrl+alt+t** - float on top (app-specific)

### window focus (cmd)

- **cmd+←/→/↑/↓** - focus window / monitor
- **shift+cmd+↑/↓** - cycle overlapping windows

### switching

- **cmd+tab** - toggle last two windows
- **cmd+`** - toggle terminal ↔ last app

### meta (ctrl+alt+cmd)

- **ctrl+alt+cmd+r** - reload config
- **ctrl+alt+cmd+i** - toggle monitor input (if enabled)

## monitor input toggle setup

requires [m1ddc](https://github.com/waydabber/m1ddc):

```bash
brew install m1ddc
```

configure monitor input codes in `input-toggle.lua`:

```lua
local HDMI = 17  -- run: m1ddc get input (while on HDMI)
local THUNDERBOLT = 25  -- run: m1ddc get input (while on Thunderbolt)
```
