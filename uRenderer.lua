--let's write a quick renderer to use in everything else
--by user4992

--x and y start at 1, not 0
--because of course they do

uRenderer = {}
ur = uRenderer --shorthand

--a terrible way of keeping track of background colors, a matrix of every pixel
uRenderer.canvas = {}

uRenderer.rects = {}
--[[
uRenderer.rects.example = {
	["x"] = 2,
	["y"] = 2,
	["w"] = 7,
	["h"] = 2,
	["color"] = colors.blue,
	["func"] = nil, --NYI, on touch, for buttons
}
]]
uRenderer.texts = {}
--[[
uRenderer.texts.example = {
	["prefix"] = nil, --facilitates passing variables into text
	["text"] = "test",
	["suffix"] = nil, --facilitates passing variables into text
	["x"] = 5,
	["y"] = 5,
	["align"] = "left", --left, center, right
	["color"] = colors.white,
	["func"] = nil, --NYI, on touch, for buttons
}
]]
local monitor = nil

function uRenderer.drawRect(rect)

	monitor.setCursorPos(rect.x, rect.y)
	monitor.setBackgroundColor(rect.color)
	for y=rect.y, rect.y+rect.h -1 do
		monitor.setCursorPos(rect.x, y)	
		for x=rect.x, rect.x+rect.w -1 do
			monitor.write(" ")
			if uRenderer.canvas[x] ~= nil and uRenderer.canvas[x][y] ~= nil then
				uRenderer.canvas[x][y] = rect.color
			end
		end	
	end
	
end

function uRenderer.drawText(text)

	monitor.setBackgroundColor(uRenderer.canvas[text.x][text.y])
	monitor.setTextColor(text.color)

	if text.prefix == nil then text.prefix = "" end
	if text.suffix == nil then text.suffix = "" end

	local length = #text.prefix + #tostring(text.text) + #text.suffix

	if text.align == "right" then
		monitor.setCursorPos(text.x - length, text.y)
	elseif text.align == "center" then
		monitor.setCursorPos(text.x - length/2, text.y)
	else
		monitor.setCursorPos(text.x, text.y)
	end

	monitor.write(text.prefix)
	monitor.write(text.text)
	monitor.write(text.suffix)


end

function uRenderer.startup()

	monitor = peripheral.find("monitor")

	--populate the canvas matrix for the monitor size
	local monitorWidth, monitorHeight = monitor.getSize()
	for x=0,monitorWidth +1 do
		uRenderer.canvas[x] = {}
			for y=0,monitorHeight +1 do
				uRenderer.canvas[x][y] = colors.black
			end
	end

	print("screen is " .. monitorWidth .. "x" .. monitorHeight)

	monitor.setBackgroundColor(colors.black)
	monitor.setTextColor(colors.white)
	monitor.clear()

	for k,v in pairs(uRenderer.rects) do
		uRenderer.drawRect(v)
	end

	for k,v in pairs(uRenderer.texts) do
		uRenderer.drawText(v)
	end

end

function uRenderer.update()
	for k,v in pairs(uRenderer.rects) do
		uRenderer.drawRect(v)
	end

	for k,v in pairs(uRenderer.texts) do
		uRenderer.drawText(v)
	end
end

uRenderer.startup()