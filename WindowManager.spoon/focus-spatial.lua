-- cmd+arrows: spatial nav with mouse centering on monitor changes

local settings = _G.windowManagerSettings or {}
local monitorFocusEnabled = settings.monitorFocusEnabled ~= false

-- spatial focus with mouse centering when crossing monitors
local function tryFocusWithMonitorCentering(direction, focusMethod)
	local win = hs.window.focusedWindow()
	if not win then return end

	local beforeScreen = win:screen()

	win[focusMethod](win, nil, true, true)

	local afterWin = hs.window.focusedWindow()
	if not afterWin then return end

	local afterScreen = afterWin:screen()

	-- if screen changed, center mouse on new screen
	if monitorFocusEnabled and beforeScreen:id() ~= afterScreen:id() then
		local frame = afterScreen:frame()
		hs.mouse.absolutePosition({
			x = frame.x + frame.w / 2,
			y = frame.y + frame.h / 2
		})
	end
end

-- hotkeys
hs.hotkey.bind({ "cmd" }, "left", function()
	tryFocusWithMonitorCentering("West", "focusWindowWest")
end)

hs.hotkey.bind({ "cmd" }, "right", function()
	tryFocusWithMonitorCentering("East", "focusWindowEast")
end)

hs.hotkey.bind({ "cmd" }, "up", function()
	tryFocusWithMonitorCentering("North", "focusWindowNorth")
end)

hs.hotkey.bind({ "cmd" }, "down", function()
	tryFocusWithMonitorCentering("South", "focusWindowSouth")
end)
