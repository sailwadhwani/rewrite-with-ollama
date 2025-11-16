-- ~/.hammerspoon/init.lua
-- FULL: polished thinking UI + Cmd+Shift+Y + reliable double-modifier triggers
-- Set DOUBLE_CMD_ENABLE or DOUBLE_OPT_ENABLE as you prefer.

-------------------------------------------------------
-- CONFIG
-------------------------------------------------------

local hotModifiers = {"cmd", "shift"}
local hotKey = "Y"
local SCRIPT_PATH = os.getenv("HOME") .. "/bin/rewrite-with-ollama"
local TASK_TIMEOUT = 45 -- seconds

-- Double-modifier options
local DOUBLE_CMD_ENABLE = false    -- enable double-tap Cmd
local DOUBLE_OPT_ENABLE = true   -- enable double-tap Option (Alt)
local DOUBLE_INTERVAL = 0.30      -- seconds allowed between taps

local hs_timer = hs.timer
local hs_task = hs.task
local hs_eventtap = hs.eventtap
local hs_pasteboard = hs.pasteboard
local hs_alert = hs.alert
local hs_notify = hs.notify
local hs_drawing = hs.drawing
local hs_geometry = hs.geometry
local hs_screen = hs.screen

-------------------------------------------------------
-- BANNER STATE
-------------------------------------------------------

local banner = nil
local bannerShadow = nil
local bannerText = nil
local cloud = nil
local ellipsesTimer = nil
local fadeTimer = nil
local cloudTimer = nil

local ellipsesState = 0
local fadeState = 0

-------------------------------------------------------
-- UTILITY
-------------------------------------------------------

local function safeDelete(obj)
    if not obj then return end
    pcall(function() obj:delete() end)
end

-------------------------------------------------------
-- SHOW BANNER (centered polished UI)
-------------------------------------------------------

local function showBanner(baseText)
    -- cleanup previous
    if ellipsesTimer then ellipsesTimer:stop(); ellipsesTimer = nil end
    if fadeTimer then fadeTimer:stop(); fadeTimer = nil end
    if cloudTimer then cloudTimer:stop(); cloudTimer = nil end
    safeDelete(bannerText); bannerText = nil
    safeDelete(cloud); cloud = nil
    safeDelete(banner); banner = nil
    safeDelete(bannerShadow); bannerShadow = nil

    local screen = hs_screen.mainScreen():frame()
    local w = screen.w * 0.60
    local h = 220
    local x = screen.x + (screen.w - w) / 2
    local y = screen.y + (screen.h - h) / 2

    -- shadow
    bannerShadow = hs_drawing.rectangle(hs_geometry.rect(x - 8, y + 8, w + 16, h + 16))
    bannerShadow:setRoundedRectRadii(24, 24)
    bannerShadow:setFill(true)
    bannerShadow:setFillColor({red = 0, green = 0, blue = 0, alpha = 0.14})
    bannerShadow:setStroke(false)
    bannerShadow:setLevel(hs_drawing.windowLevels.overlay)
    bannerShadow:show()

    -- banner
    banner = hs_drawing.rectangle(hs_geometry.rect(x, y, w, h))
    banner:setRoundedRectRadii(20, 20)
    banner:setFill(true)
    banner:setFillColor({red = 0.02, green = 0.02, blue = 0.03, alpha = 0.0})
    banner:setStroke(false)
    banner:setLevel(hs_drawing.windowLevels.overlay)
    banner:show()

    -- text
    local textRect = hs_geometry.rect(x + 36, y + (h / 2) - 36, w - 140, 72)
    bannerText = hs_drawing.text(textRect, baseText)
    bannerText:setTextSize(52)
    bannerText:setTextFont("Helvetica Neue")
    bannerText:setTextColor({white = 1, alpha = 0.0})
    bannerText:setTextStyle({alignment = "left"})
    bannerText:setLevel(hs_drawing.windowLevels.overlay)
    bannerText:show()

    -- cloud emoji
    local cloudSize = 80
    local cloudX = x + w - 100
    local cloudY = y + (h / 2) - (cloudSize / 2)
    cloud = hs_drawing.text(hs_geometry.rect(cloudX, cloudY, cloudSize, cloudSize), "💭")
    cloud:setTextSize(56)
    cloud:setTextFont("Apple Color Emoji")
    cloud:setTextStyle({alignment = "center"})
    cloud:setLevel(hs_drawing.windowLevels.overlay)
    cloud:setTextColor({white=1, alpha=0.0})
    cloud:show()

    -- fade-in
    fadeState = 0
    fadeTimer = hs_timer.doEvery(0.016, function()
        fadeState = fadeState + 1
        local t = math.min(fadeState / 12, 1)
        local ease = t * t * (3 - 2 * t)

        banner:setFillColor({red=0.02, green=0.02, blue=0.03, alpha=0.86 * ease})
        bannerShadow:setFillColor({red=0, green=0, blue=0, alpha=0.14 * ease})
        bannerText:setTextColor({white=1, alpha=1.0 * ease})
        cloud:setTextColor({white=1, alpha=1.0 * ease})

        if t >= 1 then fadeTimer:stop(); fadeTimer=nil end
    end)
    fadeTimer:start()

    -- animated dots (up to 6)
    ellipsesState = 0
    ellipsesTimer = hs_timer.doEvery(0.30, function()
        ellipsesState = (ellipsesState + 1) % 7
        bannerText:setText(baseText .. string.rep(".", ellipsesState))
    end)
    ellipsesTimer:start()

    -- cloud float
    local cloudPhase = 0
    cloudTimer = hs_timer.doEvery(0.032, function()
        cloudPhase = (cloudPhase + 1) % 360
        local r = math.rad(cloudPhase)
        local dx = math.sin(r * 0.75) * 6
        local dy = math.cos(r * 0.6) * 3
        local scale = 1.0 + (math.sin(r * 1.2) * 0.03)

        cloud:setFrame(hs_geometry.rect(
            cloudX + dx,
            cloudY + dy,
            cloudSize * scale,
            cloudSize * scale
        ))
    end)
end

-------------------------------------------------------
-- HIDE BANNER
-------------------------------------------------------

local function hideBanner()
    if ellipsesTimer then ellipsesTimer:stop(); ellipsesTimer=nil end
    if fadeTimer then fadeTimer:stop(); fadeTimer=nil end
    if cloudTimer then cloudTimer:stop(); cloudTimer=nil end

    safeDelete(bannerText); bannerText=nil
    safeDelete(cloud); cloud=nil
    safeDelete(banner); banner=nil
    safeDelete(bannerShadow); bannerShadow=nil
end

-------------------------------------------------------
-- RESTORE CLIPBOARD
-------------------------------------------------------

local function safeSetClipboardDelayed(contents, delay)
    hs_timer.doAfter(delay or 0.12, function()
        hs_pasteboard.setContents(contents or "")
    end)
end

-------------------------------------------------------
-- RUN REWRITE
-------------------------------------------------------

local function runRewrite()
    local originalClipboard = hs_pasteboard.getContents()

    hs_eventtap.keyStroke({"cmd"}, "c")
    hs_timer.usleep(120000)

    local selected = hs_pasteboard.getContents() or ""
    selected = selected:gsub("^%s+", ""):gsub("%s+$", "")

    if selected == "" then
        hs_alert.show("No selection to rewrite")
        if originalClipboard then hs_pasteboard.setContents(originalClipboard) end
        return
    end

    showBanner("AI is thinking")

    local task = hs_task.new(SCRIPT_PATH, function(exitCode, stdOut, stdErr)
        hideBanner()

        if exitCode ~= 0 then
            hs_alert.show("Rewrite failed (" .. tostring(exitCode) .. ")")
            if stdErr and stdErr ~= "" then
                hs_notify.new({title="Rewrite Error", informativeText=stdErr}):send()
            end
            if originalClipboard then hs_pasteboard.setContents(originalClipboard) end
            return
        end

        local outText = (stdOut or ""):gsub("%s+$", "")
        if outText == "" then
            hs_alert.show("No output from rewrite script")
            if originalClipboard then hs_pasteboard.setContents(originalClipboard) end
            return
        end

        hs_pasteboard.setContents(outText)
        hs_eventtap.keyStroke({"cmd"}, "v")
        hs_timer.usleep(120000)

        safeSetClipboardDelayed(originalClipboard, 0.15)
    end)

    -- Timeout
    hs_timer.doAfter(TASK_TIMEOUT, function()
        if task and task:isRunning() then
            task:terminate()
            hideBanner()
            hs_alert.show("Rewrite timed out")
            if originalClipboard then hs_pasteboard.setContents(originalClipboard) end
        end
    end)

    task:setInput(selected)
    task:start()
end

-------------------------------------------------------
-- HOTKEY: CMD + SHIFT + Y
-------------------------------------------------------

hs.hotkey.bind(hotModifiers, hotKey, function()
    runRewrite()
end)

-------------------------------------------------------
-- DOUBLE-MODIFIER DETECTION (reliable)
-------------------------------------------------------

-- We'll listen for flagsChanged events and detect modifier "down" presses.
-- On modifier DOWN we compare timestamps; two DOWNs within DOUBLE_INTERVAL trigger action.
local lastCmdPress = 0
local lastOptPress = 0

local modWatcher = hs_eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
    local flags = event:getFlags()
    local now = hs_timer.secondsSinceEpoch()

    -- Command pressed (down)
    if DOUBLE_CMD_ENABLE then
        if flags.cmd then
            -- check time since last cmd-down
            if lastCmdPress > 0 and (now - lastCmdPress) <= DOUBLE_INTERVAL then
                -- trigger
                runRewrite()
                -- reset to avoid triple-trigger
                lastCmdPress = 0
            else
                lastCmdPress = now
            end
        end
    end

    -- Option (alt) pressed (down)
    if DOUBLE_OPT_ENABLE then
        if flags.alt then
            if lastOptPress > 0 and (now - lastOptPress) <= DOUBLE_INTERVAL then
                runRewrite()
                lastOptPress = 0
            else
                lastOptPress = now
            end
        end
    end

    return false -- do not swallow the event
end)

modWatcher:start()

-------------------------------------------------------
-- LOADED NOTICE
-------------------------------------------------------

hs.notify.new({
    title="Hammerspoon",
    informativeText="Rewrite hotkeys active (Cmd+Shift+Y and double-modifier)"
}):send()