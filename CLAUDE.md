# WindowManager.spoon

## Repository Structure

This repository follows the SpoonInstall format for automatic installation via Hammerspoon's SpoonInstall plugin.

```
.
├── WindowManager.spoon/     # source code
│   ├── init.lua
│   ├── tiling.lua
│   ├── focus-spatial.lua
│   ├── focus-cluster.lua
│   ├── switcher.lua
│   ├── input-toggle.lua
│   └── reload.lua
├── Spoons/                  # packaged spoon for distribution
│   └── WindowManager.spoon.zip
├── docs/                    # metadata for SpoonInstall
│   └── docs.json
└── README.md
```

## Build Process

After making changes to `WindowManager.spoon/`, rebuild the distribution package:

```bash
cd ~/Developer/hammerspoon
zip -r Spoons/WindowManager.spoon.zip WindowManager.spoon/
git add Spoons/WindowManager.spoon.zip
git commit -m "update spoon package"
git push
```

## SpoonInstall Requirements

SpoonInstall fetches from these URLs:
- Metadata: `https://github.com/etedor/hammerspoon/raw/master/docs/docs.json`
- Package: `https://github.com/etedor/hammerspoon/raw/master/Spoons/WindowManager.spoon.zip`

The `docs.json` must contain at minimum:
```json
[{
  "name": "WindowManager",
  "version": "1.0.0",
  "author": "Eric Tedor <eric@tedor.org>",
  "description": "adaptive window tiling and focus management for macOS",
  "license": "MIT",
  "homepage": "https://github.com/etedor/hammerspoon"
}]
```

## Testing

Test the Spoon installation:

```bash
# manual installation
cd ~/.hammerspoon/Spoons
git clone https://github.com/etedor/hammerspoon WindowManager.spoon

# via SpoonInstall (in init.lua)
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.repos.windowmanager = {
  url = "https://github.com/etedor/hammerspoon",
  desc = "window management spoon",
  branch = "master"
}
spoon.SpoonInstall.use_syncinstall = true
spoon.SpoonInstall:updateRepo("windowmanager")
spoon.SpoonInstall:andUse("WindowManager", {
  repo = "windowmanager",
  start = true,
  config = {
    padding = 10,
    ultrawideThreshold = 2.0,
    terminalApp = "Ghostty",
    enableInputToggle = true,
  }
})
```

## Style

- Comments: lowercase, terse
- Lua conventions: camelCase for variables/functions
- No emoji in code
