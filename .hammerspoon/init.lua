-- enable command line usage
-- require("hs.ipc")

-- Function to get today's date in the desired format
local function getFormattedDate()
  return os.date("%Y-%m-%d")  -- Customize the format as needed
end

-- Track typed text in a buffer
local typedText = ""

-- Watch for `//today` being typed
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

  -- `//today`
  if string.sub(typedText, -7) == "//today" then
      -- Replace `//today` with the current date
      hs.eventtap.keyStroke({"cmd"}, "delete") -- Clear last 7 characters
      hs.eventtap.keyStrokes(getFormattedDate()) -- Insert the date
      typedText = "" -- Reset the buffer
  end

  return false -- Pass the event to the system
end)

-- Start watching for typed keys
replacementWatcher:start()
