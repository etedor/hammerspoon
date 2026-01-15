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
	if not monitorFocusEnabled then return false end

	local screen = currentWin:screen()
	local nextScreen = screen['to' .. direction](screen)

	if not nextScreen then return false end

	-- get target window based on strategy
	local strategy = settings.monitorFocusStrategy or "recent"
	local targetWin = nil

	if strategy == "edge" then
		targetWin = getEdgeWindowOnScreen(nextScreen, direction)
	else  -- "recent"
		targetWin = getMostRecentWindowOnScreen(nextScreen)
	end

	-- always move mouse to center of target screen
	local frame = nextScreen:frame()
	local centerPoint = {
		x = frame.x + frame.w / 2,
		y = frame.y + frame.h / 2
	}

	-- focus window if found
	if targetWin then
		targetWin:focus()
	end

	-- move mouse after focus (with small delay to ensure it sticks)
	hs.timer.doAfter(0.01, function()
		hs.mouse.absolutePosition(centerPoint)
	end)

	return true
end

-- try spatial focus with monitor fallback
local function tryFocusWithMonitorFallback(direction, focusMethod)
	local win = hs.window.focusedWindow()
	if not win then return end

	local beforeId = win:id()
	win[focusMethod](win, nil, true, true)

	local afterWin = hs.window.focusedWindow()
	if afterWin and afterWin:id() == beforeId then
		focusMonitorInDirection(win, direction)
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
