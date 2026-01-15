-- test mouse movement via hotkey
-- add this to your ~/.hammerspoon/init.lua temporarily

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "m", function()
	local screen = hs.screen.mainScreen()
	local frame = screen:frame()

	print("Hotkey pressed - moving mouse to center")
	print("Screen frame:", frame)

	hs.mouse.absolutePosition({
		x = frame.x + frame.w / 2,
		y = frame.y + frame.h / 2
	})

	print("Mouse position after:", hs.mouse.absolutePosition())
	hs.alert.show("Mouse moved to center")
end)

print("Test hotkey registered: ctrl+alt+cmd+m")
