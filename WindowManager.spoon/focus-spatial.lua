-- cmd+arrows: spatial nav with multi-monitor fallback

local settings = _G.windowManagerSettings or {}
local monitorFocusEnabled = settings.monitorFocusEnabled ~= false

-- get most recently focused window on given screen
local function getMostRecentWindowOnScreen(screen)
	local orderedWins = hs.window.orderedWindows()
	for _, w in ipairs(orderedWins) do
		if w:screen():id() == screen:id() and w:isStandard() then
			return w
		end
	end
	return nil
end

-- get edge window on given screen based on direction
-- going left -> focus rightmost window on left monitor
-- going right -> focus leftmost window on right monitor
local function getEdgeWindowOnScreen(screen, direction)
	local allWins = hs.window.visibleWindows()
	local screenWins = {}

	for _, w in ipairs(allWins) do
		if w:screen():id() == screen:id() and w:isStandard() then
			table.insert(screenWins, w)
		end
	end

	if #screenWins == 0 then return nil end

	-- find leftmost or rightmost window based on direction
	if direction == "West" then
		-- going left, focus rightmost window on left monitor
		table.sort(screenWins, function(a, b)
			return a:frame().x > b:frame().x
		end)
	elseif direction == "East" then
		-- going right, focus leftmost window on right monitor
		table.sort(screenWins, function(a, b)
			return a:frame().x < b:frame().x
		end)
	end

	return screenWins[1]
end

-- focus window on adjacent monitor in given direction
local function focusMonitorInDirection(currentWin, direction)
	print("focusMonitorInDirection called, direction:", direction)

	if not monitorFocusEnabled then
		print("monitor focus disabled")
		return false
	end

	local screen = currentWin:screen()
	local nextScreen = screen['to' .. direction](screen)

	if not nextScreen then
		print("no adjacent screen in direction:", direction)
		return false
	end

	print("found adjacent screen, moving mouse and focusing")

	-- get target window based on strategy
	local strategy = settings.monitorFocusStrategy or "recent"
	local targetWin = nil

	if strategy == "edge" then
		targetWin = getEdgeWindowOnScreen(nextScreen, direction)
	else  -- "recent"
		targetWin = getMostRecentWindowOnScreen(nextScreen)
	end

	-- move mouse to center of target screen first
	local frame = nextScreen:frame()
	print("target screen frame:", frame)
	hs.mouse.absolutePosition({
		x = frame.x + frame.w / 2,
		y = frame.y + frame.h / 2
	})
	print("mouse moved to:", hs.mouse.absolutePosition())

	-- then focus window if found (after mouse movement)
	if targetWin then
		print("focusing window:", targetWin:title())
		targetWin:focus()
	else
		print("no window to focus on target screen")
	end

	return true
end

-- try spatial focus with monitor centering
local function tryFocusWithMonitorFallback(direction, focusMethod)
	print("tryFocusWithMonitorFallback called, direction:", direction)

	local win = hs.window.focusedWindow()
	if not win then
		print("no focused window")
		return
	end

	local beforeScreen = win:screen()
	local beforeId = win:id()
	print("before focus, window ID:", beforeId, "screen:", beforeScreen:id())

	win[focusMethod](win, nil, true, true)

	local afterWin = hs.window.focusedWindow()
	if not afterWin then
		print("no window after focus")
		return
	end

	local afterScreen = afterWin:screen()
	local afterId = afterWin:id()
	print("after focus, window ID:", afterId, "screen:", afterScreen:id())

	-- if screen changed, center mouse on new screen
	if beforeScreen:id() ~= afterScreen:id() then
		print("screen changed! centering mouse on new screen")
		local frame = afterScreen:frame()
		print("target screen frame:", frame)
		hs.mouse.absolutePosition({
			x = frame.x + frame.w / 2,
			y = frame.y + frame.h / 2
		})
		print("mouse moved to:", hs.mouse.absolutePosition())
	else
		print("same screen, no mouse movement")
	end
end

-- hotkeys
hs.hotkey.bind({ "cmd" }, "left", function()
	tryFocusWithMonitorFallback("West", "focusWindowWest")
end)

hs.hotkey.bind({ "cmd" }, "right", function()
	tryFocusWithMonitorFallback("East", "focusWindowEast")
end)

hs.hotkey.bind({ "cmd" }, "up", function()
	tryFocusWithMonitorFallback("North", "focusWindowNorth")
end)

hs.hotkey.bind({ "cmd" }, "down", function()
	tryFocusWithMonitorFallback("South", "focusWindowSouth")
end)
