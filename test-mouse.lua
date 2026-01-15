-- simple test to move mouse to screen center
-- run this from hammerspoon console

local screen = hs.screen.mainScreen()
local frame = screen:frame()

print("Screen frame:", frame)
print("Moving mouse to center...")

hs.mouse.absolutePosition({
	x = frame.x + frame.w / 2,
	y = frame.y + frame.h / 2
})

print("Mouse position after:", hs.mouse.absolutePosition())
