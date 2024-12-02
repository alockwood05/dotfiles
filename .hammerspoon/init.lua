-- enable command line usage
-- require("hs.ipc")

-- hello world
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
end)

-- Function to get today's date in the desired format
local function getFormattedDate()
  return os.date("%Y-%m-%d")  -- Customize the format as needed
end

-- Track typed text in a buffer
local typedText = ""

-- logic to check for a string and replace text
local function replaceTextInput(listenText, replacementFn)
  local precedingTextIsBacktick = string.sub(typedText, -(#listenText), -(#listenText+1)) == "`"
  local listenTextMatches = string.sub(typedText, -#listenText) == listenText
  if (listenTextMatches and not precedingTextIsBacktick ) then
    hs.timer.doAfter(0.1, function()
      hs.eventtap.keyStroke({"alt"}, "delete")
      hs.eventtap.keyStrokes(replacementFn())
      typedText = "" -- Reset the buffer
    end)
  end
end

-- Watch text being typed
local replacementWatcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
  local currentKey = hs.keycodes.map[event:getKeyCode()]
  -- Update the buffer based on the key pressed
  if #currentKey == 1 then
      typedText = typedText .. currentKey
  elseif currentKey == "space" then
      typedText = typedText .. " "
  elseif currentKey == "delete" then
      typedText = string.sub(typedText, 1, -2) -- Remove the last character
  end

  -- Replacements
  replaceTextInput("//today", getFormattedDate)
  return false -- Pass the event to the system
end)

-- Start watching for typed keys
replacementWatcher:start()
