--works best on 1x1 monitor
--
--too bad the chatbox isn't in 1.16
require "uRenderer"

uRenderer.rects[0] = { --screenwipe
    ["x"] = 1,
    ["y"] = 1,
    ["w"] = 29,
    ["h"] = 12,
    ["color"] = colors.black,
    ["func"] = nil,
}

uRenderer.texts.clock = {
    ["text"] = "--:--",
    ["x"] = 5,
    ["y"] = 1,
    ["align"] = "center",
    ["color"] = colors.gray,
}

uRenderer.texts.day = {
    ["prefix"] = "Day ",
    ["text"] = "---",
    ["x"] = 1,
    ["y"] = 2,
    ["align"] = "left",
    ["color"] = colors.gray,
}

uRenderer.texts.eclipselabel = {
    ["text"] = "NEXT: ",
    ["x"] = 2,
    ["y"] = 4,
    ["align"] = "left",
    ["color"] = colors.gray,
}

uRenderer.texts.countdown = {
    ["text"] = "--",
    ["suffix"] = " days",
    ["x"] = 8,
    ["y"] = 5,
    ["align"] = "right",
    ["color"] = colors.gray,
}

local txt = uRenderer.texts

uRenderer.startup()

local lastSighting
while lastSighting == nil do
    print("Last known Horologium sighting: ")
    local input = read()
    if input ~= nil and tonumber(input) ~= nil then
        lastSighting = math.floor(input)
    end
end

local timer = 0
while true do

    local monitor = peripheral.find("monitor")
    monitor.setTextScale(1)

    txt.clock.text = textutils.formatTime(os.time(), true)
    local day = os.day()
    if day <= 9 then
        txt.day.prefix = "Day   "
    elseif day <= 99 then
        txt.day.prefix = "Day  "
    elseif day <= 999 then
        txt.day.prefix = "Day "
    else
        txt.day.prefix = "Day"
    end
    txt.day.text = tostring(day)

    --horologium doesn't just disappear at midnight
    --so let's only "flip" the day at 6am
    local effectiveDay = os.time() < 6 and day -1 or day

    local delay = 36

    local daysLeft = delay - ((effectiveDay - lastSighting) % delay)
    txt.countdown.text = tostring(daysLeft)
    txt.countdown.suffix = " days"

    if daysLeft == 36 then
        txt.countdown.text = "0"
        txt.countdown.prefix = ""
        txt.countdown.color = colors.blue
    elseif daysLeft == 1 then
        txt.countdown.prefix = "0"
        txt.countdown.suffix = " day "
        txt.countdown.color = colors.green
    elseif daysLeft < 10 then
        txt.countdown.prefix = "0"
        txt.countdown.color = colors.green
    else
        txt.countdown.prefix = ""
        txt.countdown.color = colors.gray
    end

    uRenderer.update()
    print("monitoring eclipse from day ".. lastSighting)

    os.cancelTimer(timer)
    timer = os.startTimer(0.99)

    event, param = os.pullEvent()
    --print(event, param)

end