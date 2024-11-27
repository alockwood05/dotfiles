--- === TextReplacer ===
---
--- A spoon to replace specific typed text with custom replacements, like `//today` with the current date.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "TextReplacer"
obj.version = "0.2"
obj.author = "Alexander Lockwood <alex.lockwood@gmail.com>"
obj.license = "MIT"
obj.homepage = "https://hammerspoon.org/"

-- Variables
obj.typedText = "" -- Buffer to track typed text
obj.replacements = {} -- Table to store replacements (keys are each a listenText, values are replacement functions)


-- Maximum buffer size (2x max replacement length)
obj.maxBufferSize = 50 -- Adjust this size based on your use case

obj.escapeChar = "`"

-- Trim the buffer if it exceeds the maximum size
local function trimBuffer(buffer, maxSize)
    if #buffer > maxSize then
        return string.sub(buffer, -maxSize/2) -- max replacement length is 1/2 maxBufferSize
    end
    return buffer
end

-- Helper to handle replacement logic
function obj:_replaceTextInput(typedText, listenText, replacementFn)

    local found = string.sub(typedText, -#listenText) == listenText
    local escaped = string.sub(typedText, -(#listenText + 1), -(#listenText + 1)) == self.escapeChar
    if found and not escaped then
        hs.timer.doAfter(0.1, function()
            hs.eventtap.keyStroke({"cmd"}, "delete") -- Clear the last characters matching `listenText`
            hs.eventtap.keyStrokes(replacementFn()) -- Insert the replacement
        end)
        return "" -- Reset buffer after replacement
    end
    return typedText
end

-- Event watcher
function obj:start()
    self.replacementWatcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
        local currentKey = hs.keycodes.map[event:getKeyCode()]
        -- Update the buffer
        if #currentKey == 1 then
            self.typedText = self.typedText .. currentKey
        elseif currentKey == "space" then
            self.typedText = " " -- only listen to words, no spaces
        elseif currentKey == "delete" then
            self.typedText = string.sub(self.typedText, 1, -2)
        end

        -- Trim the buffer to prevent growth
        self.typedText = trimBuffer(self.typedText, self.maxBufferSize)

        -- Process replacements
        for listenText, replacementFn in pairs(self.replacements) do
            self.typedText = self:_replaceTextInput(self.typedText, listenText, replacementFn)
        end

        return false -- Pass event to the system
    end):start()
end

-- Stop the watcher
function obj:stop()
    if self.replacementWatcher then
        self.replacementWatcher:stop()
        self.replacementWatcher = nil
    end
end

-- Add a replacement
function obj:addReplacement(listenText, replacementFn)
    self.replacements[listenText] = replacementFn
end

return obj
