--- WindowManager.spoon
--- adaptive window tiling and focus management for macos
---
--- homepage: https://github.com/etedor/hammerspoon
--- license: MIT

local obj = {}
obj.__index = obj

obj.name = "WindowManager"
obj.version = "1.0.0"
obj.author = "Eric Tedor <eric@tedor.org>"
obj.license = "MIT - https://opensource.org/licenses/MIT"
obj.homepage = "https://github.com/etedor/hammerspoon"

obj.padding = 0
obj.ultrawideThreshold = 2.0
obj.ultrawideLeftWidth = 0.30
obj.ultrawideCenterWidth = 0.40
obj.ultrawideRightWidth = 0.30
obj.standardLeftWidth = 0.50
obj.standardRightWidth = 0.50
obj.terminalApp = "Ghostty"
obj.enableInputToggle = false
obj.monitorFocusEnabled = true

function obj:init()
	return self
end

function obj:start()
	-- create settings table for modules to access (after config is applied)
	_G.windowManagerSettings = {
		padding = self.padding,
		ultrawideThreshold = self.ultrawideThreshold,
		ultrawideLeftWidth = self.ultrawideLeftWidth,
		ultrawideCenterWidth = self.ultrawideCenterWidth,
		ultrawideRightWidth = self.ultrawideRightWidth,
		standardLeftWidth = self.standardLeftWidth,
		standardRightWidth = self.standardRightWidth,
		terminalApp = self.terminalApp,
		monitorFocusEnabled = self.monitorFocusEnabled,
	}

	-- load modules
	dofile(hs.spoons.resourcePath("reload.lua"))
	dofile(hs.spoons.resourcePath("tiling.lua"))
	dofile(hs.spoons.resourcePath("focus-spatial.lua"))
	dofile(hs.spoons.resourcePath("focus-cluster.lua"))
	dofile(hs.spoons.resourcePath("switcher.lua"))

	-- optional: monitor input toggle (requires m1ddc)
	if self.enableInputToggle then
		dofile(hs.spoons.resourcePath("input-toggle.lua"))
	end

	hs.alert.show("WindowManager loaded")
	return self
end

function obj:stop()
	return self
end

return obj
